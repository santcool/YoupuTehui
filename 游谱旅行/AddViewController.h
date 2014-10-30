//
//  AddViewController.h
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddView.h"
#import "AddTableViewCell.h"
#import "ToCityViewController.h"
#import "PirceViewController.h"
#import "TravelDaysViewController.h"
#import "MonthsViewController.h"
#import "SeveralViewController.h"
#import "WithViewController.h"
#import "PreferenceViewController.h"
#import "LoginViewController.h"
#import "PersonalCenterViewController.h"
#import "FromCityViewController.h"

@interface AddViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,fromCityDelegate,SeveralDelegate,withDelegate,PreferenceDelegate,toCityDelegate,PirceDelegate,TravelsDelegate,MonthsDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    BOOL abc;
}

@property (nonatomic, strong) NSMutableArray * upArray;
@property (nonatomic, strong) NSArray * downArray;
@property (nonatomic, strong) UITableView * upTableView;

@property (nonatomic, strong) NSMutableDictionary * numberOfMade;
@property (nonatomic, strong) NSString * qzyAll;//传那个数字

@property (nonatomic, strong) NSString * mameStr;
@property (nonatomic, strong) NSString * togetherStr;
@property (nonatomic, strong) NSString * preferenceStr;
@property (nonatomic, strong) NSString * priceStr;
@property (nonatomic, strong) NSString * destinationStr;
@property (nonatomic, strong) NSString * travelStr;
@property (nonatomic, strong) NSString * timeStr;
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * left;
@property (nonatomic, strong) NSString * right;

@property (nonatomic, strong) NSString * mameId;
@property (nonatomic, strong) NSString * togetherId;
@property (nonatomic, strong) NSString * preferenceId;
@property (nonatomic, strong) NSString * priceId;
@property (nonatomic, strong) NSString * destinationId;
@property (nonatomic, strong) NSString * travelId;
@property (nonatomic, strong) NSString * timeId;
@property (nonatomic, strong) NSString * finishId;
@property (nonatomic, strong) NSString * specialStr;
@property (nonatomic, strong) NSString * cityId;

@property (nonatomic, strong) NSString * orderIds;
@property (nonatomic, strong) NSMutableArray * orderArray;

@end

