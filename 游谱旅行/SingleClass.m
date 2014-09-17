//
//  SingleClass.m
//  游谱旅行
//
//  Created by 易迅方舟 on 14-8-10.
//  Copyright (c) 2014年 易迅方舟. All rights reserved.
//

#import "SingleClass.h"

static SingleClass * single = nil;

@implementation SingleClass

+(SingleClass *)singleClass{
    
    @synchronized(self){
        
        if (!single) {
            
            single = [[SingleClass alloc] init];
            single.singleDic = [[NSMutableDictionary alloc] init];
            
        }
        
        
    }
    
    return single;
    
    
}

@end
