//
//  TimeViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-25.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "TimeViewController.h"

static TimeViewController * timess = nil;

@interface TimeViewController ()
{
    MBProgressHUD * _progressHUD;
    NSString * _jiequ;
}

@property (strong,nonatomic)NSIndexPath *lastpath;
@property (strong,nonatomic)NSIndexPath *lastSection;

@end

@implementation TimeViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        
        timess = [[self alloc] initWithNibName:nil bundle:nil];
    });
    return timess;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.timeDic = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTable];
    [self connect];
}

-(void)addIndicator
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    [_progressHUD setMode:MBProgressHUDModeIndeterminate];
    [_progressHUD setLabelText:@"加载中..."];
    [_progressHUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}
-(void) myProgressTask{
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress -=0.01f;
        _progressHUD.progress = progress;
        usleep(50000);
    }
}


-(void)setNavigationBar{
    
    self.title = @"旅行时间";
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

-(void)backActon{
    
    if ([_titleStr isEqualToString:@"出发时间"]) {
        [self.delegate timeColor:[UIColor whiteColor]];
    }else{
        [self.delegate timeColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark - 筛选条件网络请求
-(void)connect{
    
    [self addIndicator];
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * QZY = [NSString stringWithFormat:@"%@%@",timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kFilterUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",url,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.timeDic addEntriesFromDictionary:dic];
        
        [_timeTable reloadData];
        [_progressHUD hide:YES];
        [_progressHUD removeFromSuperViewOnHide];
    }];
}

-(void)createTable{
    
    self.timeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    
    self.timeTable.delegate = self;
    self.timeTable.dataSource = self;

    if ([[[UIDevice currentDevice]systemVersion ]floatValue] >=7.0) {
        [_timeTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    NSInteger selectedIndex = 0;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.timeTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:self.timeTable];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return [[[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"1"]count];
    }
    return [[[[_timeDic objectForKey:@"data"] objectForKey:@"months"]objectForKey:@"2"]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    ConditionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    if (indexPath.section==0) {
        [cell.textLabel setText:[[[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"0"] objectForKey:@"value"]];
        
    }
    if (indexPath.section==1) {
        
        NSArray * array = [[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"1"];
        NSDictionary * dic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[dic objectForKey:@"value"]];
    }
    if (indexPath.section==2) {
        NSArray * array = [[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"2"];
        NSDictionary * dic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[dic objectForKey:@"value"]];
    }
    
    if (_lastpath != nil) {
        if (_lastpath.row == indexPath.row && _lastSection.section==indexPath.section) {
            [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
            cell.image.hidden = NO;
        }
        else {
            
            [cell.image setHidden:YES];
        }
    }

    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.04];

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0.001;
    }if (section==1) {
        return 30;
    }
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return nil;
    }if (section==1) {
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [lable setText:@"   重要节假日"];
        [lable setFont:[UIFont systemFontOfSize:14]];
        [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [lable setBackgroundColor:[UIColor whiteColor]];
        lable.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        lable.layer.borderWidth = 0.5;
//        CALayer *qwe = [CALayer layer];
//        qwe.frame = CGRectMake(0, 0, self.view.frame.size.width, 2);
//        qwe.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
//        [lable.layer addSublayer:qwe];
//        CALayer *qweR = [CALayer layer];
//        qweR.frame = CGRectMake(0, 29.5, self.view.frame.size.width, 0.5);
//        qweR.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
//        [lable.layer addSublayer:qweR];
        return lable;
    }else{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [lable setText:@"   日期"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [lable setBackgroundColor:[UIColor whiteColor]];
    lable.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    lable.layer.borderWidth = 0.5;
    return lable;
    }
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int newSection = [indexPath section];
    int oldSection = (_lastSection != nil) ? [_lastSection section] : newSection-1;
    if (newSection != oldSection) {
        ConditionTableViewCell *newCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     indexPath];
        [newCell.image setImage:[UIImage imageNamed:@"钩钩"]];
        
        ConditionTableViewCell *oldCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     _lastSection];
        [oldCell.image setHidden:YES];
        
        _lastSection = indexPath;
    }
    
    int newRow = [indexPath row];
    int oldRow = (_lastpath != nil) ? [_lastpath row] : newRow-1;
    if (newRow != oldRow) {
        ConditionTableViewCell *newCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     indexPath];
        [newCell.image setImage:[UIImage imageNamed:@"钩钩"]];
        
        ConditionTableViewCell *oldCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     _lastpath];
        [oldCell.image setHidden:YES];
        
        _lastpath = indexPath;
    }
    // 取消选择状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
     [self.delegate time:[[[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"0"] objectForKey:@"value"]];
        NSDictionary * dictionary = [NSDictionary dictionaryWithObject:@"0" forKey:@"time"];
        SingleClass * single  = [SingleClass singleClass];
        [single.singleDic addEntriesFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (indexPath.section==1) {

        NSArray * array = [[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"1"];
        NSDictionary * dic = [array objectAtIndex:indexPath.row];
        NSString * String = [dic objectForKey:@"id"];
        NSDictionary * dictionary = [NSDictionary dictionaryWithObject:String forKey:@"time"];
        SingleClass * single  = [SingleClass singleClass];
        [single.singleDic addEntriesFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
        NSString * jieri =[dic objectForKey:@"value"];
        if (indexPath.row<3) {
            _jiequ = [jieri substringWithRange:NSMakeRange(0, 3)];
        }else{
        _jiequ = [jieri substringWithRange:NSMakeRange(0, 2)];
        }
        [self.delegate time:[dic objectForKey:@"shortValue"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (indexPath.section==2) {

        NSArray * array = [[[_timeDic objectForKey:@"data"]objectForKey:@"months"] objectForKey:@"2"];
        NSDictionary * dic = [array objectAtIndex:indexPath.row];
        NSNumber *number =[dic objectForKey:@"id"];
        NSString * String = [number stringValue];
        NSDictionary * dictionary = [NSDictionary dictionaryWithObject:String forKey:@"time"];
        SingleClass * single  = [SingleClass singleClass];
        [single.singleDic addEntriesFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
        [self.delegate time:[dic objectForKey:@"value"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
