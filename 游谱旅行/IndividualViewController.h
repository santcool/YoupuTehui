//
//  IndividualViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-7.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNameViewController.h"
#import "MobileViewController.h"
#import "ValidateViewController.h"
#import "LiveViewController.h"
#import "BirthdayViewController.h"
#import "SexViewController.h"
#import "CharacterViewController.h"
#import "FavoriteViewController.h"
#import "PassWordViewController.h"
#import "GuanyuViewController.h"
#import "SuggestionViewController.h"
#import "IndividualTableViewCell.h"
#import <ShareSDK/ShareSDK.h>


@interface IndividualViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myDelegate,liveDelegate,birthDelegate,sexDelegate,characterDelegate,favoriteDelegate,UIWebViewDelegate>
{
    UIImage *picture;
    
}

@property (nonatomic, strong) NSArray * array;
@property (nonatomic, strong) NSArray * downArray;
@property (nonatomic, strong) NSArray * qitaArray;
@property (nonatomic, strong) UITableView * individualTable;
@property (nonatomic, strong) UITableView * upTableView;
@property (nonatomic, strong) UITableView * downTableView;
@property (nonatomic, strong) UIImagePickerController * imagePicker;
@property (nonatomic, strong) UIWebView * webView;

//标题
@property (nonatomic,strong) NSString * emailStr;
@property (nonatomic,strong) NSString * userIcon;
@property (nonatomic,strong) NSString * myPicture;
@property (nonatomic,strong) NSString * myName;
@property (nonatomic,strong) NSString * mobileNumber;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * birth;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * character;
@property (nonatomic,strong) NSString * favorite;
@property (nonatomic,strong) NSString * changeMima;
@property (nonatomic,strong) NSString * guanyu;
@property (nonatomic,strong) NSString * suggestion;

@property (nonatomic,strong) NSMutableDictionary * userInfoDic;



@end
