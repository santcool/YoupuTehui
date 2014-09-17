//
//  AddViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()
{
    UILabel * lable;
    NSInteger _i;
}
@property (nonatomic, strong) UINavigationController * fromNavigationController;
@property (nonatomic, strong) UINavigationController * toCityNavigationController;
@property (nonatomic, strong) UINavigationController * pirceNavigationController;
@property (nonatomic, strong) UINavigationController * travelNavigationController;
@property (nonatomic, strong) UINavigationController * severalNavigationController;
@property (nonatomic, strong) UINavigationController * togetherNavigationController;
@property (nonatomic, strong) UINavigationController * preferenceNavigationController;

@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.upArray = [NSMutableArray arrayWithObjects:@"出发城市",@"目的地",@"旅行时间",@"旅行天数",@"我的预算", nil];
        self.downArray = [NSArray arrayWithObjects:@"第几次去",@"和谁一起",@"旅行偏好", nil];

        self.numberOfMade = [[NSMutableDictionary alloc]init];
        self.orderArray = [[NSMutableArray alloc]init];
        _i=0;
        abc=2;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(acceptOrderId:) name:@"nicai" object:nil];
    
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"] == nil) {
        
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(appDelegate.tab.selectedIndex !=2){
        _i=0;
        _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
        _destinationStr = @"不限";
        _priceStr = @"不限";
        _travelStr = @"不限";
        _specialStr = nil;
        _mameStr = @"不限";
        _togetherStr = @"不限";
        _preferenceStr = @"不限";
    }
 
    [self numberMade];
    [self addAndAdd];
    [self createTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
 

}

-(void)addAndAdd{
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.05]];
    
    AddView * add = [[AddView alloc] init];
    [add.number setText:self.qzyAll];
    [add.aImage addTarget:self action:@selector(goToPerson)];
    [self.view addSubview:add];
}
#pragma mark
#pragma mark ---------------图标上的数字
-(void)numberMade{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * member = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",kNumberUrl,time,member];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [self.numberOfMade addEntriesFromDictionary:dic];
        
        self.qzyAll = [self.numberOfMade objectForKey:@"data"];
        [self addAndAdd];
        
    }];
    
}

-(void)acceptOrderId:(NSNotification *)notifi{
    
    if ([[notifi userInfo]objectForKey:@"order"] !=nil) {
        _orderIds = [[notifi userInfo]objectForKey:@"order"];
        [self orderOneValue];
    }else{
        
        _cityName = [[notifi userInfo]objectForKey:@"detailFrom"];
        _destinationStr = [[notifi userInfo]objectForKey:@"detailTo"];
        _cityId = [[notifi userInfo]objectForKey:@"detailFromCode"];
        _destinationId =[NSString stringWithFormat:@"%@%@",@"AreaId-",[[notifi userInfo]objectForKey:@"detailToCode"]];
        
    }

    
    
}
#pragma mark
#pragma mark ------------定制详情
-(void)orderOneValue{
    
    [_upTableView removeFromSuperview];
    [self createTableView];
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString * key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * orderId = _orderIds;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",memberId,orderId,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * member = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    orderId = [NSString stringWithFormat:@"%@=%@%@",@"orderId",orderId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kMadeDetailUrl,time,member,orderId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
     
        NSDictionary * dictionary  =[dic objectForKey:@"data"];
        
         _i=2;
        _cityName = [dictionary objectForKey:@"fromCityName"];
        _destinationStr = [dictionary objectForKey:@"toCityName"];
        _priceStr = [dictionary objectForKey:@"budgetName"];
        _travelStr = [dictionary objectForKey:@"daysName"];
        _specialStr =[dictionary objectForKey:@"travelDateStr"];
        _mameStr = [dictionary objectForKey:@"timesName"];
        _togetherStr = [dictionary objectForKey:@"togetherName"];
        if ([[dictionary objectForKey:@"travelTypeName"] isEqualToString:@""]) {
            _preferenceStr = @"不限";
        }else{
        _preferenceStr = [dictionary objectForKey:@"travelTypeName"];
        }
        
        _cityId = [dictionary objectForKey:@"fromCityId"];
        _destinationId =[NSString stringWithFormat:@"%@%@%@",[dictionary objectForKey:@"toCityType"],@"_",[dictionary objectForKey:@"toCityCode"]];
        _priceId =[dictionary objectForKey:@"budget"];
        _travelId = [dictionary objectForKey:@"days"];
        _mameId = [dictionary objectForKey:@"times"];
        _togetherId = [dictionary objectForKey:@"together"];
        _timeId = [dictionary objectForKey:@"travelDate"];
        _finishId = [dictionary objectForKey:@"travelDateEnd"];
        
        NSArray * array = [dictionary objectForKey:@"travelType"];
        for (int i = 0; i< [array count]; i++) {
            if ([array count]==1) {
                _preferenceId =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"travelType"] objectAtIndex:0]];
            }else{
                NSString * string = [array objectAtIndex:i];
                if (_preferenceId==nil) {
                    _preferenceId = [NSString stringWithFormat:@"%@",string];
                }else{
                    _preferenceId = [NSString stringWithFormat:@"%@%@%@",_preferenceId,@",",string];
                }
            }
        }
        
        
        [_upTableView reloadData];
    }];
}

#pragma mark 
#pragma mark    -去个人中心
-(void)goToPerson
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 4;
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark
#pragma mark -协议传值(name)
-(void)fromName:(NSString *)fromName{
    self.cityName = fromName;
    [_upTableView reloadData];

    
}
-(void)severalName:(NSString *)str
{
    self.mameStr = str;
    [_upTableView reloadData];

}
-(void)with:(NSString *)str
{
    self.togetherStr = str;
    [_upTableView reloadData];
  
}
-(void)preference:(NSArray *)str
{
    _preferenceStr =nil;
    for (int i = 0; i < [str count]; i++) {
        NSString * string = [str objectAtIndex:i];
        if (self.preferenceStr ==nil) {
            self.preferenceStr = [NSString stringWithFormat:@"%@",string];
        }else{
        self.preferenceStr = [NSString stringWithFormat:@"%@%@%@",self.preferenceStr,@",",string];
        }
    }
    [_upTableView reloadData];

}
-(void)price:(NSString *)price
{
    if ([price isEqualToString:@"不限价格"]) {
        price = @"不限";
    }
    self.priceStr = price;
    [_upTableView reloadData];

}
-(void)destination:(NSString *)region
{
    if ([region isEqualToString:@"不限目的地"]) {
         region = @"不限";
    }
    self.destinationStr = region;
    [_upTableView reloadData];

}
-(void)travel:(NSString *)travel
{
    if ([travel isEqualToString:@"不限天数"]) {
        travel = @"不限";
    }
    self.travelStr = travel;
    [_upTableView reloadData];
 
}
-(void)time:(NSString *)startTime arrive:(NSString *)finishTime exit:(BOOL)exit{
    
    self.timeId = startTime;
    self.finishId = finishTime;
    self.specialStr = [NSString stringWithFormat:@"%@%@%@",self.timeId,@"至",self.finishId];
    abc = exit;
    [_upTableView reloadData];
}
-(void)whatever:(NSString *)string exit:(BOOL)exit{
    
    self.timeStr = string;
    abc = exit;
    self.timeId = @"0";
    self.finishId = @"0";

    [_upTableView reloadData];
}
#pragma mark
#pragma mark -协议传值(Id)
-(void)tocityId:(NSString *)tocity{
    self.destinationId = tocity;
}
-(void)priceId:(NSString *)priceId{
    self.priceId = priceId;
}
-(void)travelId:(NSString *)travelId{
    self.travelId = travelId;
    
}
-(void)severalId:(NSString *)several{
    self.mameId = several;
}
-(void)withId:(NSString *)withId{
    self.togetherId = withId;
}
-(void)preferenceId:(NSArray *)preferenceId{
  
    _preferenceId =nil;
    for (int i = 0; i < [preferenceId count]; i++) {
        NSString * string = [preferenceId objectAtIndex:i];
        if (_preferenceId==nil) {
            _preferenceId = [NSString stringWithFormat:@"%@",string];
        }else{
            _preferenceId = [NSString stringWithFormat:@"%@%@%@",_preferenceId,@",",string];
        }
        
    }
    
    
}
-(void)fromCity:(NSString *)fromCity{
    
    self.cityId = fromCity;
}

#pragma mark
#pragma mark - 隐藏tableview多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark
#pragma mark -MD5加密规则
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
#pragma mark - 完成定制事件
-(void)finishMade{

    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];

    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * orderId = nil;
    if (_orderIds==nil) {
        orderId = @"0";
    }else{
        orderId = _orderIds;
    }
    if (_cityId==nil) {
        _cityId = [[NSUserDefaults standardUserDefaults]objectForKey:@"fromCityId"];
    }if (_mameId==nil) {
        self.mameId = @"0";
    }if (_togetherId==nil) {
        self.togetherId = @"0";
    }if (_preferenceId==nil) {
        self.preferenceId = @"0";
    }if (_priceId ==nil) {
        self.priceId = @"0";
    }if (_destinationId==nil) {
        self.destinationId = @"0";
    }if (_travelId==nil) {
        self.travelId = @"0";
    }if (_timeId==nil) {
        _timeId=@"0";
    }if (_finishId==nil) {
        _finishId = @"0";
    }
    NSString * fromCity = self.cityId;
    NSString * toCity = self.destinationId;
    NSString * pirce = self.priceId;
    NSString * travelDays = self.travelId;
    NSString * travelDate = self.timeId;
    NSString * travelDateEnd = self.finishId;
    NSString * times = self.mameId;
    NSString * together = self.togetherId;
    NSString * travelType = self.preferenceId;
    
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",fromCity,memberId,orderId,pirce,times,timeString,toCity,together,travelDate,travelDateEnd,travelDays,travelType,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    orderId = [NSString stringWithFormat:@"%@=%@%@",@"orderId",orderId,@"&"];
    travelDate = [NSString stringWithFormat:@"%@=%@%@",@"travelDate",self.timeId,@"&"];
    travelDateEnd = [NSString stringWithFormat:@"%@=%@%@",@"travelDateEnd",self.finishId,@"&"];
    fromCity = [NSString stringWithFormat:@"%@=%@%@",@"fromCity",self.cityId,@"&"];
    pirce = [NSString stringWithFormat:@"%@=%@%@",@"pirce",self.priceId,@"&"];
    toCity = [NSString stringWithFormat:@"%@=%@%@",@"toCity",self.destinationId,@"&"];
    travelDays = [NSString stringWithFormat:@"%@=%@%@",@"travelDays",self.travelId,@"&"];
    times = [NSString stringWithFormat:@"%@=%@%@",@"times",times,@"&"];
    together = [NSString stringWithFormat:@"%@=%@%@",@"together",together,@"&"];
    travelType = [NSString stringWithFormat:@"%@=%@%@",@"travelType",travelType,@"&"];
    
    
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",kSaveUrl,time,travelDate,fromCity,pirce,toCity,travelDays,times,travelDateEnd,together,travelType,memberId,orderId];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);

[ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    
    if ([[[dic objectForKey:@"code"] stringValue] isEqualToString:@"0"]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"游谱提示您" message:@"添加定制成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        NSDictionary * order = [dic objectForKey:@"data"];
        NSString * orderId = [order objectForKey:@"orderId"];
        NSLog(@"%@",orderId);


    }else if ([[[dic objectForKey:@"code"] stringValue] isEqualToString:@"3"]){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定制条件重复" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }

    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
    _destinationStr = @"不限";
    _priceStr = @"不限";
    _travelStr = @"不限";
    _specialStr = @"不限";
    _mameStr = @"不限";
    _togetherStr = @"不限";
    _preferenceStr = @"不限";
    
    if (_orderIds==nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"added" object:nil];
    }else{
        
        NSDictionary * dic = [NSDictionary dictionaryWithObject:_orderIds forKey:@"location"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"added" object:nil userInfo:dic];
    }
    _orderIds = nil;

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 1;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark
#pragma mark -tableview相关
-(void)createTableView{
    
    self.upTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108) style:UITableViewStylePlain];
    _upTableView.dataSource = self;
    _upTableView.delegate = self;
    [self setExtraCellLineHidden:_upTableView];
    [self.view addSubview:_upTableView];

    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >=7.0) {
        [_upTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return [_upArray count];
    }else if(section==1){
        return [_downArray count];
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 20;
    }else if (section==1){
        return 40;
    }else{
        return 60;
    }

    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        UILabel *lables = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [lables setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
        lables.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        lables.layer.borderWidth = 0.8;
        return lables;
        
    }else if (section==1){
        lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [lable setText:@"  如需免费行程信息请填写如下内容"];
        [lable setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.05]];
        [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
        [lable setFont:[UIFont systemFontOfSize:14]];
        return lable;
    }else{
        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        [view setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
        [button setTitle:@"完成定制" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finishMade) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIden = @"cell";
    AddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
  
    }
    
    if (indexPath.section==0) {
        [cell.textLabel setText:[self.upArray objectAtIndex:indexPath.row]];
        if (indexPath.row ==0) {
            if (_cityName==nil) {
                [cell.lable setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"]];
            }else{
            [cell.lable setText:_cityName];
            }
        }
        else if (indexPath.row == 1) {
            if (_destinationStr==nil) {
                [cell.lable setText:@"不限"];
            }else{
                [cell.lable setText:_destinationStr];
            }
        }else if (indexPath.row == 2){
            if (_specialStr==nil) {
                [cell.lable setText:@"不限"];
            }
            if (_i==2) {
             
                [cell.lable setText:_specialStr];
            
            }
            if (_i==1) {
                [cell.lable setText:@"不限"];
            }
            
            
            if (abc == YES &&_i==1)
            {
                [cell.lable setText:_specialStr];
               
                
            }
            if (abc== NO && _i==1) {
                NSString *qqq = [self.timeStr stringByReplacingOccurrencesOfString:@"时间" withString:@""];
                [cell.lable setText:qqq];
              
            }
     
        }else if (indexPath.row == 3){
            if (self.travelStr ==nil) {
                [cell.lable setText:@"不限"];
            }else{
                [cell.lable setText:self.travelStr];
            }
        }else{
            if (self.priceStr == nil) {
                [cell.lable setText:@"不限"];
            }else{
                
                [cell.lable setText:self.priceStr];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if(indexPath.section==1){
        
        [cell.textLabel setText:[self.downArray objectAtIndex:indexPath.row]];
        if (indexPath.row == 0) {
            if (_mameStr ==nil) {
                [cell.lable setText:@"不限"];
            }else{
            [cell.lable setText:self.mameStr];
            }
        }else if (indexPath.row == 1){
            if (_togetherStr ==nil) {
                [cell.lable setText:@"不限"];
            }else{
            [cell.lable setText:self.togetherStr];
            }
        }else{
            if (_preferenceStr==nil && _i==0) {
                [cell.lable setText:@"不限"];
                
            }else if(_preferenceStr ==nil && _i==1){
            [cell.lable setText:@"不限"];
            }else{
                [cell.lable setText:_preferenceStr];
            }
        }
        
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                _i=1;
                FromCityViewController * from = [[FromCityViewController alloc]init];
                from.delegate = self;
                from.fromcityStr = _cityName ?: [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
                _fromNavigationController = [[UINavigationController alloc] initWithRootViewController:from];
                [self presentViewController:_fromNavigationController animated:NO completion:nil];
            }
            case 1:
            {
                _i=1;
               
                toCityViewController * des = [[toCityViewController alloc]init];
                des.delegate = self;
                des.toCityStr = _destinationStr;
                _toCityNavigationController= [[UINavigationController alloc] initWithRootViewController:des];
                [self presentViewController:_toCityNavigationController animated:NO completion:nil];
            }
                break;
            case 2:
            {
                _i=1;
                MonthsViewController * time = [[MonthsViewController alloc] init];
                time.delegate = self;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:time];
                [self presentViewController:na animated:NO completion:nil];
            }
                
                break;
            case 3:
            {
                _i=1;
             
                TravelDaysViewController * travle = [[TravelDaysViewController alloc]init];
                travle.delegate = self;
                travle.dayStr = _travelStr;
                _travelNavigationController = [[UINavigationController alloc] initWithRootViewController:travle];
                [self presentViewController:_travelNavigationController animated:NO completion:nil];
                
            }
                break;
            case 4:
            {
                _i=1;
            
                PirceViewController * pri = [[PirceViewController alloc]init];
                pri.delegate = self;
                pri.priceStr = _priceStr;
                _pirceNavigationController = [[UINavigationController alloc] initWithRootViewController:pri];
                [self presentViewController:_pirceNavigationController animated:NO completion:nil];
                
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section==1){
        
        switch (indexPath.row) {
            case 0:
            {
                _i=1;
                SeveralViewController * seve = [[SeveralViewController alloc]init];
                seve.delegate = self;
                seve.severalStr = _mameStr;
                _severalNavigationController= [[UINavigationController alloc] initWithRootViewController:seve];
                [self presentViewController:_severalNavigationController animated:NO completion:nil];
            }
                break;
            case 1:
            {
                _i=1;
                WithViewController * with = [[WithViewController alloc]init];
                with.delegate = self;
                with.withStr = _togetherStr;
                _togetherNavigationController = [[UINavigationController alloc] initWithRootViewController:with];
                [self presentViewController:_togetherNavigationController animated:NO completion:nil];
            }
                break;
            case 2:
            {
                _i=1;
                PreferenceViewController * pre = [[PreferenceViewController alloc] init];
                pre.delegate = self;
                _preferenceNavigationController= [[UINavigationController alloc] initWithRootViewController:pre];
                [self presentViewController:_preferenceNavigationController animated:NO completion:nil];
            }
                
            default:
                break;
        }
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
