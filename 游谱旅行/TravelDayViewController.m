//
//  TravelDayViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-25.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "TravelDayViewController.h"

static TravelDaysViewController * travel = nil;

@interface TravelDayViewController ()
{
    MBProgressHUD * _progressHUD;
}

@property (strong,nonatomic)NSIndexPath *lastpath;

@end

@implementation TravelDayViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        
        travel = [[self alloc] initWithNibName:nil bundle:nil];
    });
    return travel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.travelDic = [[NSMutableDictionary alloc] init];
        
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
    [self createLable];
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
    
    self.title = @"旅行天数";
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
    
    if ([_titleStr isEqualToString:@"天数"]) {
        [self.delegate travelColor:[UIColor whiteColor]];
    }else{
        [self.delegate travelColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)createLable{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lable setText:@"    选择您的游玩天数"];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [lable setFont:[UIFont systemFontOfSize:14]];
    lable.layer.borderWidth = 0.5;
    lable.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    [self.view addSubview:lable];
    
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
        
        [self.travelDic addEntriesFromDictionary:dic];
        
        [_travelTable reloadData];
        [_progressHUD hide:YES];
        [_progressHUD removeFromSuperViewOnHide];
        
    }];
}

-(void)createTable{
    
    self.travelTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-104) style:UITableViewStylePlain];
    
    self.travelTable.delegate = self;
    self.travelTable.dataSource = self;
    [self.travelTable setScrollEnabled:NO];
    
    NSInteger selectedIndex = 0;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.travelTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:self.travelTable];
    
    [self setExtraCellLineHidden:self.travelTable];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary * dic = [self.travelDic objectForKey:@"data"];
    NSArray * array = [dic objectForKey:@"travelDays"];
    return [array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    ConditionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        NSDictionary * dic = [self.travelDic objectForKey:@"data"];
        NSArray * array = [dic objectForKey:@"travelDays"];
        NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[nameDic objectForKey:@"value"]];
        
        cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        
        if (_travelValue ==nil) {
            if (indexPath.row==0) {
                _lastpath =indexPath;
                [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
            }
        }
        
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        int newRow = [indexPath row];
        int oldRow = (_lastpath != nil) ? [_lastpath row] : newRow-1;
        if (newRow != oldRow) {
            ConditionTableViewCell *newCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                         indexPath];
            [newCell.image setImage:[UIImage imageNamed:@"钩钩"]];
            [newCell.image setHidden:NO];
            
            ConditionTableViewCell *oldCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                         _lastpath];
            [oldCell.image setHidden:YES];
            
            _lastpath = indexPath;
        }
        // 取消选择状态
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row==0) {
            NSDictionary * dic = [self.travelDic objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"travelDays"];
            NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
            [self.delegate travel:[nameDic objectForKey:@"value"]];
            NSString * dayString = [nameDic objectForKey:@"id"];
            NSDictionary * dicc = [NSDictionary dictionaryWithObject:dayString forKey:@"day"];
            SingleClass * single  = [SingleClass singleClass];
            [single.singleDic addEntriesFromDictionary:dicc];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];

            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            NSDictionary * dic = [self.travelDic objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"travelDays"];
            NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
            
            [self.delegate travel:[nameDic objectForKey:@"value"]];
            
            NSString * dayString = [nameDic objectForKey:@"id"];
            NSDictionary * dicc = [NSDictionary dictionaryWithObject:dayString forKey:@"day"];
            SingleClass * single  = [SingleClass singleClass];
            [single.singleDic addEntriesFromDictionary:dicc];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
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
