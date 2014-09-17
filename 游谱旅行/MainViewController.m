//
//  MainViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "AllCityViewController.h"

@interface MainViewController ()
{
     UIActivityIndicatorView * _indicator;//菊花
    BOOL _value;
}

@property (strong, nonatomic) UINavigationController *desNavigationController;
@property (strong, nonatomic) UINavigationController *priceNavigationController;
@property (strong, nonatomic) UINavigationController *travelNavigationController;
@property (strong, nonatomic) UINavigationController *timeNavigationController;
@property (strong, nonatomic) UINavigationController *allNavigationController;
@property (strong, nonatomic) UINavigationController *detailNavigationController;

@property (assign, nonatomic) NSInteger separatorIndex;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dictionary = [[NSMutableDictionary alloc] init];
        
        self.lineDic = [[NSMutableDictionary alloc]init];
        
        self.refreshArray = [[NSMutableArray alloc] init];
        self.separatorIndex = -1;
        _value = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"qzy" object:nil];
        
        _i=0;
        _j=1;
        _k=0;
        _a=0;
        _rn=0;
        _detailNumber = 0;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (_detailNumber ==0) {
        
        [self navigationView];
        [self createMaxOut];
        [self addFooter];
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.tab.selectedIndex !=0 && _k!=1) {
        [self connect];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUpView];


}
//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}


-(void)navigationView{
    
    [self.navigationController.navigationBar setHidden:YES];
    NavigationView *navi = [NavigationView shareSingle];
    [navi.button addTarget:self action:@selector(cityName:) forControlEvents:UIControlEventTouchUpInside];
    if (_kindName !=nil) {
        [navi.button setTitle:_kindName forState:UIControlStateNormal];
        [navi.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navi.button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
    }
    [self.view addSubview:navi];
    
}
-(void)cityName:(id)sender{

    if (_allNavigationController ==nil) {
        AllCityViewController * all = [AllCityViewController shareSingle];
        all.delegate = self;
        _allNavigationController =[[UINavigationController alloc] initWithRootViewController:all];
    }
    _k=2;
    [self presentViewController:_allNavigationController animated:NO completion:nil];
    
}
-(void)cityNames:(NSString *)names{

    self.kindName = names;

}
-(void)createscroll{
    [self connect];
}
/*
 md5加密
 */
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
#pragma mark - 协议传值(button的标题)
-(void)destination:(NSString *)region{

    UIButton * button = (UIButton *)[self.view viewWithTag:1000];
    if ([region isEqualToString:@"不限目的地"]&& ![button.currentTitle isEqualToString:@"目的地"]) {
        _toCityName = @"0";
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.fromString,@"dic",self.fromCityId,@"idStr",self.idString,@"id",self.toCityName,@"string",self.dayString,@"day",self.timeString,@"time", nil];
        NSNotification * notification = [NSNotification notificationWithName:@"qzy" object:nil userInfo:dic];
        [self receiveMessage:notification];

    }
    if ([region isEqualToString:@"不限目的地"]) {
        [button setTitle:@"目的地" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]  forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"小树线"]];
        [self connect];
        
    }else{
        
        [button setTitle:region forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"加号"]];
    }

    
}

-(void)price:(NSString *)price{
    
    UIButton * button = (UIButton *)[self.view viewWithTag:1001];
    if ([price isEqualToString:@"不限价格"]&& ![button.currentTitle isEqualToString:@"价格"]) {
        _idString = @"0";
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.fromString,@"dic",self.fromCityId,@"idStr",self.idString,@"id",self.toCityName,@"string",self.dayString,@"day",self.timeString,@"time", nil];
        NSNotification * notification = [NSNotification notificationWithName:@"qzy" object:nil userInfo:dic];
        [self receiveMessage:notification];
    }
    if ([price isEqualToString:@"不限价格"]) {
        [button setTitle:@"价格" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]  forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"小树线"]];
        [self connect];
    }else{
        
        [button setTitle:price forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"加号"]];
    }
}

-(void)travel:(NSString *)travel{

    UIButton * button = (UIButton *)[self.view viewWithTag:1002];
    if ([travel isEqualToString:@"不限天数"]&& ![button.currentTitle isEqualToString:@"天数"]) {
        _dayString = @"0";
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.fromString,@"dic",self.fromCityId,@"idStr",self.idString,@"id",self.toCityName,@"string",self.dayString,@"day",self.timeString,@"time", nil];
        NSNotification * notification = [NSNotification notificationWithName:@"qzy" object:nil userInfo:dic];
        [self receiveMessage:notification];
    }
    if ([travel isEqualToString:@"不限天数"]) {
        [button setTitle:@"天数" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]  forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"小树线"]];
        [self connect];
    }else{

        [button setTitle:travel forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"加号"]];
    }
    
}

-(void)time:(NSString *)time{
    
    UIButton * button = (UIButton *)[self.view viewWithTag:1003];
    if ([time isEqualToString:@"不限时间"]&& ![button.currentTitle isEqualToString:@"出发时间"]) {
        _timeString = @"0";
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.fromString,@"dic",self.fromCityId,@"idStr",self.idString,@"id",self.toCityName,@"string",self.dayString,@"day",self.timeString,@"time", nil];
        NSNotification * notification = [NSNotification notificationWithName:@"qzy" object:nil userInfo:dic];
        [self receiveMessage:notification];
    }
    if ([time isEqualToString:@"不限时间"]) {
        [button setTitle:@"出发时间" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]  forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"小树线"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"小树线"]];
        [self connect];
    }else{
        
        [button setTitle:time forState:UIControlStateNormal];
        UIImageView * image = (UIImageView *)[self.view viewWithTag:100];
        [image setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image1 = (UIImageView *)[self.view viewWithTag:101];
        [image1 setImage:[UIImage imageNamed:@"加号"]];
        UIImageView * image2 = (UIImageView *)[self.view viewWithTag:102];
        [image2 setImage:[UIImage imageNamed:@"加号"]];
    }
}

#pragma mark
#pragma mark --------------------- 协议传值点击返回传button字体正常状态颜色
-(void)desColor:(UIColor *)normal{
    UIButton * button = (UIButton *)[self.view viewWithTag:1000];
    [button setTitleColor:normal forState:UIControlStateNormal];
    if ([button.currentTitle isEqualToString:@"目的地"]) {
        [self connect];
    }
}
-(void)color:(UIColor *)normal{
    UIButton * button = (UIButton *)[self.view viewWithTag:1001];
    [button setTitleColor:normal forState:UIControlStateNormal];
    if ([button.currentTitle isEqualToString:@"价格"]) {
        [self connect];
    }
}
-(void)travelColor:(UIColor *)normal{
    UIButton * button = (UIButton *)[self.view viewWithTag:1002];
    [button setTitleColor:normal forState:UIControlStateNormal];
    if ([button.currentTitle isEqualToString:@"天数"]) {
        [self connect];
    }
}
-(void)timeColor:(UIColor *)normal{
    UIButton * button = (UIButton *)[self.view viewWithTag:1003];
    [button setTitleColor:normal forState:UIControlStateNormal];
    if ([button.currentTitle isEqualToString:@"出发时间"]) {
        [self connect];
    }
}

#pragma mark 
#pragma mark ------------------------ 消息中心传值 (tableview网络请求)
-(void)receiveMessage:(NSNotification *)noti{
    if (_i==0) {
        [self addIndicator];
    }
    if (_i==1) {
        if (!_indicator.isAnimating) {
            //添加菊花
            _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
            [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
            [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
            [_indicator startAnimating];
            [self.view addSubview:_indicator];
        }
    }
    //选择出发城市的判断
//    NSInteger allKey = [[[noti userInfo]objectForKey:@"key"] intValue];
//    if (allKey == 2)
//    {
//        _k = allKey;
//    }
    NSInteger aaa = [[[noti userInfo]objectForKey:@"aaa"] intValue];
    if (aaa ==1) {
        _a=1;
        [self createMaxOut];
         [self addFooter];
    }
    
    if (_k==0)
    {
        if (_fromString !=nil && _fromCityId!=nil) {
            [[NSUserDefaults standardUserDefaults]setObject:_fromString forKey:@"fromArea"];
            [[NSUserDefaults standardUserDefaults]setObject:_fromCityId forKey:@"fromId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        self.fromString = [[noti userInfo] objectForKey:@"dic"];
        self.fromCityId = [[noti userInfo] objectForKey:@"idStr"];
    }
    else if (_k==1)
    {
        if (_i==1)
        {
            [_refreshArray removeAllObjects];
            _j=1;
            
        }
        self.toCityName = [[noti userInfo] objectForKey:@"string"];
        self.idString = [[noti userInfo] objectForKey:@"id"];
        self.dayString = [[noti userInfo] objectForKey:@"day"];
        self.timeString = [[noti userInfo]objectForKey:@"time"];
        self.fromString = [[noti userInfo] objectForKey:@"dic"];
        self.fromCityId = [[noti userInfo] objectForKey:@"idStr"];

    }else
    {
        if (_a==1)
        {
            [_refreshArray removeAllObjects];
            _j=1;
        }
        
        if ([_toCityName isEqualToString:@"0"]&& ![[[noti userInfo] objectForKey:@"string"]isEqualToString:@""]) {
            _toCityName = @"0";
        }else{
            self.toCityName = [[noti userInfo] objectForKey:@"string"];
        }
        if ([_idString isEqualToString:@"0"]&& ![[[noti userInfo] objectForKey:@"id"]isEqualToString:@""]) {
            _idString = @"0";
        }else{
            self.idString = [[noti userInfo] objectForKey:@"id"];
        }
        if ([_dayString isEqualToString:@"0"]&& ![[[noti userInfo] objectForKey:@"day"]isEqualToString:@""]) {
            self.dayString = @"0";
        }else{
            self.dayString = [[noti userInfo] objectForKey:@"day"];
        }
        if ([_timeString isEqualToString:@"0"]&& ![[[noti userInfo] objectForKey:@"time"]isEqualToString:@""]) {
            self.timeString = @"0";
        }else{
            self.timeString = [[noti userInfo]objectForKey:@"time"];
        }
        
        self.fromString = [[noti userInfo] objectForKey:@"dic"];
        
        self.fromCityId = [[noti userInfo] objectForKey:@"idStr"];
    }

    if (_toCityName ==nil) {
        _toCityName = @"0";
    }if (_idString ==nil) {
        _idString = @"0";
    }if (_dayString ==nil) {
        _dayString = @"0";
    }if (_timeString ==nil) {
        _timeString = @"0";
    }
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_j];
    NSString * daysSelect = self.dayString;
    NSString * fromCityAreaId = self.fromString;
    NSString *priceSelect = self.idString;
    NSString *toCitySelect = self.toCityName;
    NSString *travelDateSelect = self.timeString;
    NSString * fromCityId = self.fromCityId;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",daysSelect,fromCityAreaId,fromCityId,page,priceSelect,timeString,toCitySelect,travelDateSelect,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kLineUrl,time];
    daysSelect = [NSString stringWithFormat:@"%@=%@%@",@"daysSelect",self.dayString,@"&"];
    fromCityAreaId = [NSString stringWithFormat:@"%@=%@%@",@"fromCityAreaId",self.fromString,@"&"];
    priceSelect = [NSString stringWithFormat:@"%@=%@%@",@"priceSelect",self.idString,@"&"];
    toCitySelect = [NSString stringWithFormat:@"%@=%@%@",@"toCitySelect",self.toCityName,@"&"];
    travelDateSelect = [NSString stringWithFormat:@"%@=%@%@",@"travelDateSelect",self.timeString,@"&"];
    fromCityId = [NSString stringWithFormat:@"%@=%@%@",@"fromCityId",self.fromCityId,@"&"];
    page = [NSString stringWithFormat:@"%@=%@%@",@"page",page,@"&"];
    
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",lastUrl,daysSelect,fromCityAreaId,fromCityId,priceSelect,toCitySelect,travelDateSelect,page];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            [self.refreshArray addObjectsFromArray:[dic objectForKey:@"data"]];
            self.separatorIndex = -1;
            [self.refreshArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if ([obj[@"rn"] integerValue] != 1) {
                    self.separatorIndex = idx;
                    *stop = YES;
                }
            }];
        
        if ([_idString isEqualToString:@"0"]&&[ _toCityName isEqualToString:@"0"]&&[_dayString isEqualToString:@"0"]&&[_timeString isEqualToString:@"0"]) {
            _value = YES;
            [self connect];
            [_table setTableHeaderView:_scroll];
            if (_i==0 ||_rn==1) {
                [_table reloadData];
            }
            
        }else{
            _value = NO;
            [_table setTableHeaderView:nil];
            [_table reloadData];
        }
        [_footer endRefreshing];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        
    }];
    _j+=1;
}

-(void)hiddenLine:(UITableView *)tableView{
    
    UIView * view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
}

#pragma mark
#pragma mark 创建上方筛选button
-(void)createUpView{

    NSArray * array = [NSArray arrayWithObjects:@"目的地",@"价格",@"天数",@"出发时间", nil];
    
    for (int i = 0; i < 4; i++) {
        
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i*80, 64, 80, 50)];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:39/255.0 green:45/255.0 blue:55/255.0 alpha:0.9f]];
        
        button.tag = i+1000;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIImageView * image= [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 10, 10)];
        [image setImage:[UIImage imageNamed:@"小三角"]];
        [button addSubview:image];
    }
    
    for (int j = 0; j < 3; j++) {
        
        UIImageView * smallImage= [[UIImageView alloc] initWithFrame:CGRectMake(80*j+70, 78, 20, 20)];
        [smallImage setImage:[UIImage imageNamed:@"树线"]];
        smallImage.tag = j+100;
        [self.view addSubview:smallImage];
    }
}

#pragma mark
#pragma mark ---------------------筛选条件按钮点击事件
-(void)buttonAction:(id)sender{
    _k=1;
    _i=1;
    [_pageControl setHidden:YES];
    

    UIButton * button = (UIButton *)sender;
    switch (button.tag) {
        case 1000:{
            
            [button setTitleColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
            DestinationViewController * des = [DestinationViewController shareSingle];
            des.delegate = self;
            des.titleStr = button.currentTitle;
            _desNavigationController = [[ UINavigationController alloc] initWithRootViewController:des];
            [self presentViewController:_desNavigationController animated:NO completion:nil];
            
        }
            break;
        case 1001:{
            
            [button setTitleColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
            
            if (_priceNavigationController == nil) {
                PriceViewController * des = [PriceViewController shareSingle];
                des.delegate = self;
                des.titleStr = button.currentTitle;
                _priceNavigationController = [[ UINavigationController alloc] initWithRootViewController:des];
            }
            PriceViewController * des = [PriceViewController shareSingle];
            des.delegate = self;
            des.titleStr = button.currentTitle;
            
            [self presentViewController:_priceNavigationController animated:NO completion:nil];
        }
            break;
        case 1002:{
            
             [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateNormal];
            
            if (_travelNavigationController == nil) {
                TravelDayViewController * des = [TravelDayViewController shareSingle];
                des.delegate = self;
                des.titleStr = button.currentTitle;
                _travelNavigationController = [[ UINavigationController alloc] initWithRootViewController:des];
            }
            TravelDayViewController * des = [TravelDayViewController shareSingle];
            des.delegate = self;
            des.titleStr = button.currentTitle;
            
            [self presentViewController:_travelNavigationController animated:NO completion:nil];
        }
            break;
        case 1003:{
            
             [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateNormal];
            if (_timeNavigationController == nil) {
                TimeViewController * des = [TimeViewController shareSingle];
                des.delegate = self;
                des.titleStr = button.currentTitle;
                _timeNavigationController = [[ UINavigationController alloc] initWithRootViewController:des];
            }
                TimeViewController * des = [TimeViewController shareSingle];
                des.delegate = self;
                des.titleStr = button.currentTitle;
            
            [self presentViewController:_timeNavigationController animated:NO completion:nil];
            
        }
            
        default:
            break;
    }
    
}

#pragma mark 
#pragma mark - 创建上方scrollview
-(void)createScroll{
    
    NSDictionary * dic = [self.dictionary objectForKey:@"data"];
    NSArray * arr = [dic objectForKey:@"topicList"];
    NSDictionary * baokuan = [dic objectForKey:@"baokuan"];
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 114, 320, 180)];
    [_scroll setContentOffset:CGPointMake(0, 0)];
    [_scroll setContentSize:CGSizeMake(320*([arr count]+1), 180)];

    _scroll.delegate = self;
    [_scroll setPagingEnabled:YES];
    
    [_table setTableHeaderView:_scroll];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 150, 320, 20)];
    [_pageControl setNumberOfPages:[arr count]+1];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [_table addSubview:_pageControl];
    
    TouchImage * aImage = [[TouchImage alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    [aImage setImageWithURL:[NSURL URLWithString:[baokuan objectForKey:@"pic"]]];
    [aImage addTarget:self action:@selector(gotoBaokuan)];
    [_scroll addSubview:aImage];
    
    for (int i = 0; i < [arr count]; i++) {
        
        NSDictionary * imageDic = [arr objectAtIndex:i];
        NSString * string = [imageDic objectForKey:@"pic"];
        NSURL * url = [NSURL URLWithString:string];
        
        TouchImage *image = [[TouchImage alloc] initWithFrame:CGRectMake(320+320*i, 0, 320, 180)];
        [image setUserInteractionEnabled:YES];
        [image setImageWithURL:url];
        image.tag = i+100;
        [image addTarget:self action:@selector(nextController:)];
        [_scroll addSubview:image];
    
        //scrollView自动滚动
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:5];
        
    }
}

#pragma mark
#pragma mark -------------------第一张图片点击事件
-(void)gotoBaokuan{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 3;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark
#pragma mark ---------------pagecontroll
-(void)pageAction:(id)sender
{
    [_scroll setContentOffset:CGPointMake(320*_pageControl.currentPage, 0)];
}

-(void)fanhui{
    [self connect];
}
#pragma mark
#pragma mark ---------------------后五张图片点击事件
-(void)nextController:(id)sender{
    
    UIImageView *image = (UIImageView *)sender;
    switch (image.tag) {
        case 100:{
            WebViewController * web = [[WebViewController alloc] init];
            web.delegate = self;
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * arr = [dic objectForKey:@"topicList"];
            NSDictionary * dicc = [arr objectAtIndex:0];
            NSString * str = [dicc objectForKey:@"url"];
            web.string = str;
            
            UINavigationController *na = [[UINavigationController alloc ] initWithRootViewController:web];
            
            [self presentViewController:na animated:NO completion:nil];
        }
        case 101:{
            
            WebViewController * web = [[WebViewController alloc] init];
            web.delegate = self;
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * arr = [dic objectForKey:@"topicList"];
            NSDictionary * dicc = [arr objectAtIndex:1];
            NSString * str = [dicc objectForKey:@"url"];
            web.string = str;
            
            
            UINavigationController *na = [[UINavigationController alloc ] initWithRootViewController:web];
            
            [self presentViewController:na animated:NO completion:nil];
            
            
        }
            break;
        case 102:{
            
            WebViewController * web = [[WebViewController alloc] init];
            web.delegate = self;
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * arr = [dic objectForKey:@"topicList"];
            NSDictionary * dicc = [arr objectAtIndex:2];
            NSString * str = [dicc objectForKey:@"url"];
            web.string = str;
            
            UINavigationController *na = [[UINavigationController alloc ] initWithRootViewController:web];
            
            [self presentViewController:na animated:NO completion:nil];
        }
            
            break;
            
        case 103:{
            
            WebViewController * web = [[WebViewController alloc] init];
            web.delegate = self;
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * arr = [dic objectForKey:@"topicList"];
            NSDictionary * dicc = [arr objectAtIndex:3];
            NSString * str = [dicc objectForKey:@"url"];
            web.string = str;
            
            UINavigationController *na = [[UINavigationController alloc ] initWithRootViewController:web];
            
            [self presentViewController:na animated:NO completion:nil];
        }
            
            break;
        case 104:{
            
            WebViewController * web = [[WebViewController alloc] init];
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * arr = [dic objectForKey:@"topicList"];
            NSDictionary * dicc = [arr objectAtIndex:4];
            NSString * str = [dicc objectForKey:@"url"];
            web.string = str;
            
            UINavigationController *na = [[UINavigationController alloc ] initWithRootViewController:web];
            
            [self presentViewController:na animated:NO completion:nil];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 
#pragma mark -scrollview自动滚动方法
- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scroll.contentOffset.x + _scroll.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:10];
}
- (void)moveToTargetPosition:(CGFloat)targetX
{
    if (targetX >= _scroll.contentSize.width) {
        targetX = 0;
    }
    
    [_scroll setContentOffset:CGPointMake(targetX, 0) animated:NO] ;
    _pageControl.currentPage = (int)(_scroll.contentOffset.x / _scroll.frame.size.width);
}

#pragma mark
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
}

#pragma mark
#pragma mark - 滑动视图网络请求
-(void)connect{
    
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
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kScrollUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.dictionary addEntriesFromDictionary:dic];
        [self createScroll];
        
    }];

}

#pragma mark 
#pragma mark - 内容展示
-(void)createMaxOut{
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-164) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [_table setRowHeight:100];
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self hiddenLine:_table];
    
    [self.view addSubview:_table];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_separatorIndex > -1) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.refreshArray count] == 0) {
    
        NSMutableArray * arr = [self.lineDic objectForKey:@"data"];
        return [arr count];
        
    }else{
        if (_separatorIndex > -1) {
            if (section == 0) {
                return _separatorIndex;
            } else {
                return _refreshArray.count - _separatorIndex;
            }
        }
        return [_refreshArray count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    FirstTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];

    }

    NSDictionary *dic = nil;
    if (_separatorIndex > -1 && indexPath.section > 0) {
        dic = _refreshArray[_separatorIndex + indexPath.row];
    } else {
        dic = _refreshArray[indexPath.row];
    }
    NSString * thumb = [dic objectForKey:@"thumbPath"];
    NSURL * url = [NSURL URLWithString:thumb];
    if ([thumb isEqualToString:@""]) {
        [cell.image setImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
    }else{
    [cell.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
    }
    [cell.fromLable setText:[dic objectForKey:@"fromcity"]];
    [cell.toLable setText:[dic objectForKey:@"tocity"]];
    [cell.detailLable setText:[dic objectForKey:@"titleDescribe"]];
    
    NSNumber * number = [dic objectForKey:@"price"];
    NSString * priceStr = [number stringValue];
    [cell.priceLable setText:priceStr];
    
    NSNumber * num = [dic objectForKey:@"basePrice"];
    NSString *string = [num stringValue];
    if ([string isEqualToString:@"0"])
    {
        [cell.basePrice setText:@""];
        [cell.baseImage setImage:[UIImage imageNamed:@"123"]];
    }
    else
    {
        [cell.basePrice setText:string];
        [cell.baseImage setImage:[UIImage imageNamed:@"横线"]];
    }
    
    if ([[dic objectForKey:@"travelType"] isEqualToString:@"随团游"])
    {
        [cell.genImage setImage:[UIImage imageNamed:@"跟团游"]];
    }
    else
    {
        [cell.genImage setImage:[UIImage imageNamed:@"自由行"]];
    }
    
    if ([[dic objectForKey:@"hot"]isEqualToString:@"2"]) {
        [cell.hotImage setImage:[UIImage imageNamed:@"hot"]];
    }else{
        [cell.hotImage setImage:[UIImage imageNamed:@"100"]];
    }
    
    NSString *dayStr = [dic objectForKey:@"daysShow"];
    dayStr = [dayStr stringByReplacingOccurrencesOfString:@"天" withString:@""];
    NSString * fuhao =  @"★";
    NSString * stars = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"hotelStar"],fuhao];
    [cell.textLable setText:dayStr];
    [cell.hotLable setText:[dic objectForKey:@"hotelStar"]];
    
    if ([[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [cell.flyImage setHidden:YES];
       
    }else{
        
        [cell.flyImage setHidden:NO];
        [cell.hotLable setText:stars];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"] && ![[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [cell.flyImage setFrame:CGRectMake(133, 70, 20, 20)];
        [cell.hotLable setFrame:CGRectMake(148, 80, 15, 10)];
        [cell.hotLable setText:stars];
        [cell.stayImage setHidden:YES];
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]){
        
        [cell.stayImage setHidden:NO];
        [cell.flyImage setFrame:CGRectMake(166, 70, 20, 20)];

        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]&& ![[dic objectForKey:@"hotelStar"]isEqualToString:@""])
    {
        [cell.hotLable setText:stars];
        [cell.hotLable setFrame:CGRectMake(178, 80, 15, 10)];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"]&& [[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [cell.stayImage setHidden:YES];
        [cell.flyImage setHidden:YES];
    }

    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    }
    if (_value==YES) {
        return 0;
    }
    if (_separatorIndex >-1 && [[[_refreshArray firstObject]objectForKey:@"rn"] integerValue]!=1)
    {
        return 94;
    }
    
    
    return 24;
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }

    if (_separatorIndex >-1 && [[[_refreshArray firstObject]objectForKey:@"rn"] integerValue]!=1) {
        UIView * aView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 94)];
        [aView setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]];
        UIButton * image = [[UIButton alloc]initWithFrame:CGRectMake(50 ,0,200, 70)];
        [image setBackgroundImage:[UIImage imageNamed:@"无匹配"] forState:UIControlStateNormal];
        [aView addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 24)];
        label.textColor = [UIColor blackColor];
        [label setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"    其他参考行程";
        [aView addSubview:label];
        return aView;
    }
    
    if (_value==YES) {
        return nil;
    }
    
    
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
        header.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200, 20)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"其他参考行程";
        [header addSubview:label];
        return header;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _detailNumber = 1;
    
    NSDictionary *dic = nil;
    if (_separatorIndex > -1 && indexPath.section > 0) {
        dic = _refreshArray[_separatorIndex + indexPath.row];
    } else {
        dic = _refreshArray[indexPath.row];
    }
    NSString *lineId = [dic objectForKey:@"lineId"];
    
    DetailViewController * detail = [[DetailViewController alloc]init];
    detail.lineNumber = lineId;
    UINavigationController * na= [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:na animated:NO completion:nil];
    
    
}

#pragma mark -
#pragma mark 上拉加载,下来刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _table;
    footer.delegate = self;
  
    _footer = footer;
}
#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]){
        // 刷新数据
        // 进入刷新状态就会回调这个Block
        
        _i=0;
        _a=0;
    
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.fromString,@"dic",self.fromCityId,@"idStr",self.idString,@"id",self.toCityName,@"string",self.dayString,@"day",self.timeString,@"time", nil];
        
            NSNotification * notification = [NSNotification notificationWithName:@"qzy" object:nil userInfo:dic];
            [self receiveMessage:notification];
        
    }
    
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
    [_table setContentOffset:CGPointMake(_table.contentOffset.x, _table.contentOffset.y+50)];
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
