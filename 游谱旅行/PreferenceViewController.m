//
//  PreferenceViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "PreferenceViewController.h"

@interface PreferenceViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
}

@property (nonatomic, strong) NSIndexPath * lastpath;

@end

@implementation PreferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.withDic = [[NSMutableDictionary alloc]init];
        self.array = [[NSMutableArray alloc]init];
        self.idArray = [[NSMutableArray alloc]init];
        self.selectArr = [NSMutableArray array];
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
    
    [self lineHidden:_withTable];
    
}

//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}

-(void)setNavigationBar{
    
    self.title = @"旅行偏好";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
-(void)save{
    
    [self.delegate preference:_array];
    [self.delegate preferenceId:_idArray];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)lineHidden:(UITableView *)tableView{
    
    UIView * view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
    
}

-(void)createLable{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [lable setText:@"    选择您的旅行偏好,可多选"];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [lable setFont:[UIFont systemFontOfSize:12]];
    lable.layer.borderWidth = 1;
    lable.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    [self.view addSubview:lable];
    
}



- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
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
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kFilterCaseListUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [self.withDic addEntriesFromDictionary:dic];
        
        [_withTable reloadData];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        
        
    }];
}

-(void)createTable{
    
    self.withTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.withTable.delegate = self;
    self.withTable.dataSource = self;
    [_withTable setEditing:YES];
    [self.view addSubview:self.withTable];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary * dic = [self.withDic objectForKey:@"data"];
    NSArray * array = [dic objectForKey:@"travelType"];
    return [array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    ConditionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        NSDictionary * dic = [self.withDic objectForKey:@"data"];
        NSArray * array = [dic objectForKey:@"travelType"];
        NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[nameDic objectForKey:@"value"]];
        cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
 
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = [self.withDic objectForKey:@"data"];
    NSArray * array = [dic objectForKey:@"travelType"];
    NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
    NSString * idString = [nameDic objectForKey:@"value"];
    NSString * qqq = [nameDic objectForKey:@"id"];
    [_array addObject:idString];
    [_idArray addObject:qqq];
 

    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
