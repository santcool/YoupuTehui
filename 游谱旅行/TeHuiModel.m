//
//  TeHuiModel.m
//  游谱特惠
//
//  Created by youpu on 14-10-11.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "TeHuiModel.h"

@implementation TeHuiModel

#pragma mark 
#pragma mark  --------------md5加密规则
+ (NSString *)md5:(NSString *)str
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
#pragma mark  -------------获取服务器时间
+(NSString * )getServerTime{
    
    
    __block NSString * string = nil;
     [ConnectModel connectWithParmaters:nil url:kServerTimeUrl style:kConnectGetType finished:^(id result) {
         NSData * data = result;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         string = [dic objectForKey:@"data"];
        
    }];
    return string;
    
}



@end
