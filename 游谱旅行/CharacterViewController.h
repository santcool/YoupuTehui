//
//  Character ViewController.h
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol characterDelegate;

@interface CharacterViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) NSString * character;

@property (nonatomic, strong) UITextView * field;;

@property (nonatomic, weak) id<characterDelegate> delegate;

@property (nonatomic, strong) NSString * characterNow;

@end

@protocol characterDelegate <NSObject>

-(void)character:(NSString *)charecter;

@end