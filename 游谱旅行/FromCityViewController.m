//
//  FromCityViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-19.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "FromCityViewController.h"

static FromCityViewController * fromCity = nil;

@interface FromCityViewController ()
{
      UIActivityIndicatorView * _indicator;//菊花
}

@property (strong,nonatomic)NSIndexPath *lastpath;

@end

@implementation FromCityViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        
        fromCity = [[self alloc] initWithNibName:nil bundle:nil];
        
    });
    
    return fromCity;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    
    self.title = @"出发城市";
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

-(void)createLable{
    
    UILabel * aLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
    aLable.layer.borderWidth = 1;
    aLable.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    [self.view addSubview:aLable];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [lable setText:@"    选择您的出发城市"];
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
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kMainConnectUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [self.dictionary addEntriesFromDictionary:dic];
        [_destinationTable reloadData];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        
    }];
}

-(void)createTable{
    
    self.destinationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, [UIScreen mainScreen].bounds.size.height-40) style:UITableViewStylePlain];
    
    self.destinationTable.delegate = self;
    self.destinationTable.dataSource = self;
    
    NSInteger selectedIndex = 0;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.destinationTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:self.destinationTable];
    
    [self setExtraCellLineHidden:self.destinationTable];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.dictionary objectForKey:@"data"]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    ConditionTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        NSArray * array = [self.dictionary objectForKey:@"data"];
        NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[nameDic objectForKey:@"cityName"]];
        
        cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        if ([[nameDic objectForKey:@"cityName"] isEqualToString:_fromcityStr]) {
            _lastpath = indexPath;
            [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
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
        
        ConditionTableViewCell *oldCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     _lastpath];
        [oldCell.image setHidden:YES];
        
        _lastpath = indexPath;
    }
    // 取消选择状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * array = [self.dictionary objectForKey:@"data"];
    NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
    NSString * string = [nameDic objectForKey:@"id"];
     NSString * strings = [nameDic objectForKey:@"cityName"];
    [self.delegate fromCity:string];
    [self.delegate fromName:strings];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    
    
    
    
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
