//
//  SingleClass.h
//  游谱旅行
//
//  Created by 易迅方舟 on 14-8-10.
//  Copyright (c) 2014年 易迅方舟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleClass : NSObject

@property (nonatomic, strong) NSMutableDictionary * singleDic;

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * passWord;

@property (nonatomic, strong) UINavigationController * detailNavigation;

+(SingleClass *)singleClass;

@end
