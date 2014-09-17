//
//  LiveViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "LiveViewController.h"

static LiveViewController * live = nil;

@interface LiveViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
}

@property (strong,nonatomic)NSIndexPath *lastpath;

@end

@implementation LiveViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        live = [[self alloc] initWithNibName:nil bundle:nil];
    });
    
    return live;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.addressArray = [[NSMutableArray alloc]init];
  
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self qzy];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self qzyTableView];
    
    [self connect];
}

-(void)qzy
{
    self.title = self.nowAddress;
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
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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

-(void)change{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * type = @"nickName";
    NSString * value = @"";
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,timeString,type,value,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    type = [NSString stringWithFormat:@"%@=%@%@",@"type",type,@"&"];
    value = [NSString stringWithFormat:@"%@=%@%@",@"value",value,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kReviseUrl,time,type,value];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
    }];

}

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
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kMainConnectUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [_addressArray addObjectsFromArray:[dic objectForKey:@"data"]];
        
        [_addressTable reloadData];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
    }];
    
}

-(void)qzyTableView{
    
    self.addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _addressTable.delegate = self;
    _addressTable.dataSource = self;
    
    [self setExtraCellLineHidden:_addressTable];
    [self.view addSubview:_addressTable];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.addressArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellIden = @"cell";
    ConditionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    
        NSDictionary * dic = [self.addressArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:[dic objectForKey:@"cityName"]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        if ([[dic objectForKey:@"cityName"]isEqualToString:_liveHere]) {
            _lastpath = indexPath;
            [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
        }
        
    }
    return cell;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId = [[NSUserDefaults standardUserDefaults]objectForKey:@"memberId"];
    NSString * type = @"cityId";
    NSString * value = [[_addressArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,timeString,type,value,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    type = [NSString stringWithFormat:@"%@=%@%@",@"type",type,@"&"];
    value = [NSString stringWithFormat:@"%@=%@%@",@"value",value,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kReviseUrl,time,type,value];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
    }];
    
    //选中
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
    NSDictionary * string = [self. addressArray objectAtIndex:indexPath.row];
    
    [self.delegate address:[string objectForKey:@"cityName"]];
    
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
