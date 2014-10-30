 //
//  NavigationView.m
//  游谱旅行
//
//  Created by youpu on 14-7-23.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "NavigationView.h"
#import "AllCityViewController.h"

static NavigationView * navigation = nil;

@implementation NavigationView

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        
        navigation = [[NavigationView alloc]init];
        
    });
    return navigation;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.dictionary = [[NSMutableDictionary alloc] init];
        [self fromConnect];
        [self dingwei];
        
        [self setBackgroundColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 28, 30, 30)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        UILabel * image = [[UILabel alloc] initWithFrame:CGRectMake(98, 30, 124, 26)];
        [image setText:@"推荐特惠"];
        [image setTextColor:[UIColor whiteColor]];
        [image setTextAlignment:NSTextAlignmentCenter];
        [image setFont:[UIFont systemFontOfSize:18]];
        [self addSubview:image];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(250, 30, 80, 30)];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button setTitle:@"定位中" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [_button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_button];
        
        self.aImage = [[TouchImage alloc] initWithFrame:CGRectMake(-2, 0, 30, 30)];
        [_aImage setImage:[UIImage imageNamed:@"首页切图_13"]];
        [_button addSubview:_aImage];
    }
    return self;
}

-(void)dingwei
{
    if ([CLLocationManager locationServicesEnabled] == YES) {
        
        self.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
        }
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=1000.0f;
        //启动位置更新
        [_locationManager startUpdatingLocation];
    }else{
        
        NSArray * arr = [self.dictionary objectForKey:@"data"];
        NSDictionary *dic = [arr objectAtIndex:0];
        NSString * str = [dic objectForKey:@"areaId"];
        NSString * idStr = [dic objectForKey:@"id"];
        NSString * cityAll = [dic objectForKey:@"cityName"];
        [[NSUserDefaults standardUserDefaults] setObject:cityAll forKey:@"cityName"];
        [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"fromCityId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:str,@"dic",idStr,@"idStr", nil];
        SingleClass * single  = [SingleClass singleClass];
        [single.singleDic addEntriesFromDictionary:diction];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];

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
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.latitude =  coor.latitude;
    self.longitude = coor.longitude;
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark.locality ==NULL) {
                NSString *city = placemark.administrativeArea;
                for (int i = 0; i< city.length; i++) {
                    NSString * names = [city substringWithRange:NSMakeRange(i,1)];
                    if ([names isEqualToString:@"市"]) {
                        names = [city substringWithRange:NSMakeRange(0, i)];
                        i = city.length;
                    }
                    [_button setTitle:names forState:UIControlStateNormal];
                }
                
                NSArray * arr = [self.dictionary objectForKey:@"data"];
                for (NSDictionary * dic  in arr) {
                    if ([_button.currentTitle isEqualToString:[dic objectForKey:@"cityName"]]) {
                        NSString * str = [dic objectForKey:@"areaId"];
                        NSString * idStr = [dic objectForKey:@"id"];
                        NSString * cityAll = [dic objectForKey:@"cityName"];
                        [[NSUserDefaults standardUserDefaults] setObject:cityAll forKey:@"cityName"];
                        [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"fromCityId"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:str,@"dic",idStr,@"idStr", nil];
                        SingleClass * single  = [SingleClass singleClass];
                        [single.singleDic addEntriesFromDictionary:diction];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
                    }if (![_button.currentTitle rangeOfString:[dic objectForKey:@"cityName"]].length<0) {
                        
                        [_button setTitle:@"上海" forState:UIControlStateNormal];
                        NSString * str = @"15";
                        NSString * idStr = @"247";
                        NSString * cityAll = @"上海";
                        [[NSUserDefaults standardUserDefaults] setObject:cityAll forKey:@"cityName"];
                        [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"fromCityId"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:str,@"dic",idStr,@"idStr", nil];
                        SingleClass * single  = [SingleClass singleClass];
                        [single.singleDic addEntriesFromDictionary:diction];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
                    }
                }  
                [_aImage setImage:[UIImage imageNamed:@"定位后"]];
                if (_button.currentTitle.length==4) {
                    [_aImage setFrame:CGRectMake(-8, 0, 30, 30)];
                }if (_button.currentTitle.length==3) {
                    [_aImage setFrame:CGRectMake(-6, 0, 30, 30)];
                }
                [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                
                NSString * city = placemark.locality;
                for (int i = 0; i< city.length; i++) {
                    NSString * names = [city substringWithRange:NSMakeRange(i,1)];
                    if ([names isEqualToString:@"市"]) {
                        names = [city substringWithRange:NSMakeRange(0, i)];
                        i = city.length;
                    }
                    [_button setTitle:names forState:UIControlStateNormal];
                }
                NSArray * arr = [self.dictionary objectForKey:@"data"];
                for (NSDictionary * dic  in arr) {
                    if ([_button.currentTitle isEqualToString:[dic objectForKey:@"cityName"]]) {
                        NSString * str = [dic objectForKey:@"areaId"];
                        NSString * idStr = [dic objectForKey:@"id"];
                        NSString * cityAll = [dic objectForKey:@"cityName"];
                        [[NSUserDefaults standardUserDefaults] setObject:cityAll forKey:@"cityName"];
                        [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"fromCityId"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:str,@"dic",idStr,@"idStr", nil];
                        SingleClass * single  = [SingleClass singleClass];
                        [single.singleDic addEntriesFromDictionary:diction];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
                   
                    }if (![_button.currentTitle rangeOfString:[dic objectForKey:@"cityName"]].length<0) {
                        
                        [_button setTitle:@"上海" forState:UIControlStateNormal];
                        NSString * str = @"15";
                        NSString * idStr = @"247";
                        NSString * cityAll = @"上海";
                        [[NSUserDefaults standardUserDefaults] setObject:cityAll forKey:@"cityName"];
                        [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"fromCityId"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NSDictionary * diction = [NSDictionary dictionaryWithObjectsAndKeys:str,@"dic",idStr,@"idStr", nil];
                        SingleClass * single  = [SingleClass singleClass];
                        [single.singleDic addEntriesFromDictionary:diction];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
                    }
                    
                }

                [_aImage setImage:[UIImage imageNamed:@"定位后"]];
                if (_button.currentTitle.length==4) {
                    [_aImage setFrame:CGRectMake(-8, 0, 30, 30)];
                }if (_button.currentTitle.length==3) {
                    [_aImage setFrame:CGRectMake(-6, 0, 30, 30)];
                }
                [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }];
    // 停止位置更新
    [_locationManager stopUpdatingLocation];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
