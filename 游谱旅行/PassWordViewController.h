//
//  PassWordViewController.h
//  游谱旅行
//
//  Created by youpu on 14-9-2.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>
{
    CustomTextField * zhText;
    CustomTextField * mmText;
    CustomTextField * xinmimaText;
}

@property (nonatomic, strong) NSString * titleName;

@end