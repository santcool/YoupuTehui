//
//  NavigationView.h
//  游谱旅行
//
//  Created by youpu on 14-7-23.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLGeocoder.h>

@interface NavigationView : UIView<CLLocationManagerDelegate>{
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,strong) UIControl * control;

@property (nonatomic,strong) NSMutableDictionary * dictionary;

@property (nonatomic,strong) UIButton * button;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,strong) TouchImage * aImage;
@property (nonatomic,strong) UIButton * backButton;

+(id)shareSingle;
-(void)dingwei;

@end





