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

-(void)viewWillAppear:(BOOL)animated{
    
    [self color];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
    [self fromConnect];
    
}

-(void)color{
    
    self.title = @"出发城市";
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
}
-(void)backActon{
    
    [self.delegate createscroll];
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - 网络请求
-(void)fromConnect{
    
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
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kMainConnectUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.dictionary addEntriesFromDictionary:dic];
        
        [_table reloadData];
    }];
    
}

-(void)hiddenLine:(UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
}

-(void)createTableView{
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    
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
    
    [self.delegate cityNames:[dic objectForKey:@"cityName"]];
    
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
