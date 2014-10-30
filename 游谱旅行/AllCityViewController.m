//
//  AllCityViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-29.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "AllCityViewController.h"

static AllCityViewController * all = nil;

@interface AllCityViewController ()
{
    NSInteger _i;
    MBProgressHUD * _progressHUD;
}

@property (nonatomic, strong) NSIndexPath * lastpath;

@end

@implementation AllCityViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
       
        all = [[self alloc]initWithNibName:nil bundle:nil];
        
    });
    
    return all;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dictionary = [[NSMutableDictionary alloc]init];
        _i=0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self color];
    [self fromConnect];
    [self createTableView];
    
}

-(void)color{
    
    self.title = @"出发城市";
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)backActon{
    
    [self.delegate createscroll];
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark
#pragma mark - 网络请求
-(void)fromConnect{
    
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
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kMainConnectUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",url,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.dictionary addEntriesFromDictionary:dic];
        
        [_table reloadData];
        [_progressHUD hide:YES];
        [_progressHUD removeFromSuperViewOnHide];
    }];
    
}

-(void)hiddenLine:(UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
}

-(void)createTableView{
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self hiddenLine:_table];
    
    [self.view addSubview:_table];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.dictionary objectForKey:@"data"]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIden = @"cell";
    ConditionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    NSArray * array = [self.dictionary objectForKey:@"data"];
    NSDictionary * dic = [array objectAtIndex:indexPath.row];
    [cell.textLabel setText:[dic objectForKey:@"cityName"]];
    [cell.textLabel setFont: [UIFont systemFontOfSize:16]];

    if (_lastpath != nil) {
        if (_lastpath.row == indexPath.row) {
            [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
            cell.image.hidden = NO;
        }
        else {
            
            [cell.image setHidden:YES];
        }
    }
    if ([[dic objectForKey:@"cityName"]isEqualToString:_nowName] ) {
        _lastpath = indexPath;
        [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
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
        
        ConditionTableViewCell *oldCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     _lastpath];
        [oldCell.image setHidden:YES];
        
        _lastpath = indexPath;
    }
    // 取消选择状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * arr = [self.dictionary objectForKey:@"data"];
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    NSString * string = [dic objectForKey:@"areaId"];
    NSString * idString = [dic objectForKey:@"id"];
    NSInteger k = 2;
    NSInteger a = 1;
    NSString * key = [NSString stringWithFormat:@"%d",k];
    NSString * aaa = [NSString stringWithFormat:@"%d",a];
    NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:string,@"dic",idString,@"idStr",key,@"key",aaa,@"aaa", nil];
    SingleClass * single  = [SingleClass singleClass];
    [single.singleDic addEntriesFromDictionary:diction];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
    
    _nowName = [dic objectForKey:@"cityName"];
    [self.delegate cityNames:_nowName];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
