//
//  AMZConnectModel.m
//  UI_News_Fresh_Friut
//
//  Created by 王迹 on 14-5-9.
//  Copyright (c) 2014年 AnMenZu. All rights reserved.
//

#import "ConnectModel.h"

NSString *const kServerTimeUrl = @"http://192.168.31.130:9091/system/getTime";

NSString *const kPrefixUrl = @"http://tehui.youpu.cn/api/";

NSString *const kLoginUrl = @"login/?paramType=get&";

NSString *const kSignUpUrl = @"regedit/?paramType=get&";

NSString *const kMainConnectUrl = @"fromCityList/?paramType=get&";

NSString *const kFilterUrl = @"filterCaseList/?paramType=get&";

NSString *const kScrollUrl = @"indexSlideshow/?paramType=get&";

NSString *const kLineUrl = @"indexLineList/?paramType=get&";
    
NSString *const kDetailUrl = @"lineDetail/?paramType=get&";

NSString *const kRecommendUrl = @"detailRecommend/?paramType=get&";

NSString *const kCustomUrl = @"myOrderList/?paramType=get&";

NSString *const kMadeDetailUrl = @"orderOneValue/?paramType=get&";

NSString *const kFilterCaseListUrl = @"orderFilterCaseList/?paramType=get&";

NSString *const kSaveUrl = @"saveOrder/?paramType=get&";

NSString *const kDeleteUrl = @"deleteOrder/?paramType=get&";

NSString *const kShowUrl = @"orderLineList/?paramType=get&";

NSString *const kMaxOutUrl = @"baokuanDetail/?paramType=get&";

NSString *const kMaxListUrl = @"baokuanList/?paramType=get&";

NSString *const kEmailExistUrl = @"regeditCheckEmail/?paramType=get&";

NSString *const kBindQQAndSinaUrl = @"bindUnionToUser/?paramType=get&";

NSString *const kQQLoginUrl = @"unionLogin/?paramType=get&";

NSString *const kForgetUrl = @"checkMobileAndSendCode/?paramType=get&";

NSString *const kValidateUrl = @"checkMobileCode/?paramType=get&";

NSString *const kIconUrl = @"setUserIcon/?paramType=get&";

NSString *const kUserInfoUrl = @"userInfo/?paramType=get&";

NSString *const kReviseUrl = @"changeUserInfo/?paramType=get&";

NSString *const kCollectUrl = @"addFavorite/?paramType=get&";

NSString *const kCollectListUrl = @"favoriteList/?paramType=get&";

NSString *const kDeleteCollectUrl = @"removeFavorite/?paramType=get&";

NSString *const kForgetPassEmail = @"forgetPassEmail/?paramType=get&";

NSString *const kReSetPassUrl = @"reSetPass/?paramType=get&";

NSString *const kFeedBackUrl = @"feedBack/?paramType=get&";

NSString *const kNumberUrl = @"customizeCount/?paramType=get&";

NSString *const kPushUrl = @"customizeUpdateData/?paramType=get&";

NSString *const kNewMaxUrl = @"http://test.api.youpu.cn/discounttrip/getBaokuanNew/?paramType=get&";


//网络请求方式
NSString *const kConnectGetType = @"GET";
NSString *const kConnectPostType = @"POST";

@implementation ConnectModel



+(void)connectWithParmaters:(NSDictionary *)parmaters url:(NSString *)urlstr style:(NSString *)style finished:(void(^)(id result))block{
    
    ConnectModel *model = [[ConnectModel alloc] init];
    model.finishedBlock = block;
    [model startConnect:parmaters url:urlstr style:style];
    
}

+ (void)uploadUserIcon:(NSDictionary *)parmaters icon:(NSData *)iconData url:(NSString *)urlstr finished:(void(^)(id result))block {
    
    ConnectModel *model = [[ConnectModel alloc] init];
    model.finishedBlock = block;
    
    NSString *str = @"";
    
    for (NSString *key in [parmaters allKeys]) {
        if ([str length] == 0) {
            str = [NSString stringWithFormat:@"%@=%@",key,[parmaters objectForKey:key]];
        }else{
            str = [NSString stringWithFormat:@"%@&%@=%@",str,key,[parmaters objectForKey:key]];
        }
    }
    
    urlstr = [NSString stringWithFormat:@"%@%@",urlstr,str];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *formBoundary = @"AaB03x";
    //根据url初始化request
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc]initWithFormat:@"--%@", formBoundary];
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc]initWithFormat:@"%@--", MPboundary];
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n", MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"userIcon\"; filename=\"avatar.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end = [[NSString alloc]initWithFormat:@"\r\n%@", endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:iconData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@", formBoundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    [NSURLConnection connectionWithRequest:request delegate:model];
}



-(void)startConnect:(NSDictionary *)dic url:(NSString *)urlstr style:(NSString *)style{
    
    NSString *str = @"";
    
    for (NSString *key in [dic allKeys]) {
        if ([str length] == 0) {
            
            str = [NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]];
        }else{
            str = [NSString stringWithFormat:@"%@&%@=%@",str,key,[dic objectForKey:key]];
        }
    }
    
    NSData *bodyData = nil;
    
    if ([style isEqualToString:kConnectGetType]) {
        urlstr = [NSString stringWithFormat:@"%@%@",urlstr,str];
        
    }else if ([style isEqualToString:kConnectPostType]){
        
        urlstr = [NSString stringWithFormat:@"%@",urlstr];
        bodyData = [str dataUsingEncoding:NSUTF8StringEncoding];
       
    }
    
    
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:style];
    
    if ([style isEqualToString:kConnectPostType]) {
        [request setHTTPBody:bodyData];
    }
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    self.receiveData = [NSMutableData data];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_receiveData appendData:data];
    
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    self.finishedBlock(_receiveData);
    
}



@end
