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
        
        [self setBackgroundColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:70/255.0 alpha:1]];
        [self setFrame:CGRectMake(0, 0, 320, 64)];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(98, 30, 124, 26)];
        [image setImage:[UIImage imageNamed:@"顶部logo"]];
        [self addSubview:image];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(250, 30, 80, 30)];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button setTitle:@"城市" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [self addSubview:_button];
        
        _aImage = [[TouchImage alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_aImage setImage:[UIImage imageNamed:@"首页切图_13"]];
        [_button addSubview:_aImage];
    }
    return self;
}

-(void)dingwei
{
    if ([CLLocationManager locationServicesEnabled] == YES) {
        
        _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=1000.0f;
        //启动位置更新
        [_locationManager startUpdatingLocation];
    }
    
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
        
        [self dingwei];
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.latitude =  coor.latitude;
    self.longitude = coor.longitude;
    NSLog(@"%f",self.latitude);
    NSLog(@"%f",self.longitude);
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark.locality ==NULL) {
                NSString *city = placemark.administrativeArea;
                NSString *cityName = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                [_button setTitle:cityName forState:UIControlStateNormal];
                
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
                    }
                }  
                [_aImage setImage:[UIImage imageNamed:@"定位后"]];
                [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                
                NSString * city = placemark.locality;
                NSString * cityName = [city stringByReplacingOccurrencesOfString:@"省" withString:@""];
                [_button setTitle:cityName forState:UIControlStateNormal];
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
                   
                    }
                }

                [_aImage setImage:[UIImage imageNamed:@"定位后"]];
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
