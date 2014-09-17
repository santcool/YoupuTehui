//
//  AMZConnectModel.m
//  UI_News_Fresh_Friut
//
//  Created by 王迹 on 14-5-9.
//  Copyright (c) 2014年 AnMenZu. All rights reserved.
//

#import "ConnectModel.h"

NSString *const kLoginUrl = @"http://tehui.youpu.cn/api/login/?paramType=get&";

NSString *const kSignUpUrl = @"http://tehui.youpu.cn/api/regedit/?paramType=get&";

NSString *const kMainConnectUrl = @"http://tehui.youpu.cn/api/fromCityList/?paramType=get&";

NSString *const kFilterUrl = @"http://tehui.youpu.cn/api/filterCaseList/?paramType=get&";

NSString *const kScrollUrl = @"http://tehui.youpu.cn/api/indexSlideshow/?paramType=get&";

NSString *const kLineUrl = @"http://tehui.youpu.cn/api/indexLineList/?paramType=get&";

NSString *const kDetailUrl = @"http://tehui.youpu.cn/api/lineDetail/?paramType=get&";

NSString *const kRecommendUrl = @"http://tehui.youpu.cn/api/detailRecommend/?paramType=get&";

NSString *const kCustomUrl = @"http://tehui.youpu.cn/api/myOrderList/?paramType=get&";

NSString *const kMadeDetailUrl = @"http://tehui.youpu.cn/api/orderOneValue/?paramType=get&";

NSString *const kFilterCaseListUrl = @"http://tehui.youpu.cn/api/orderFilterCaseList/?paramType=get&";

NSString *const kSaveUrl = @"http://tehui.youpu.cn/api/saveOrder/?paramType=get&";

NSString *const kDeleteUrl = @"http://tehui.youpu.cn/api/deleteOrder/?paramType=get&";

NSString *const kShowUrl = @"http://tehui.youpu.cn/api/orderLineList/?paramType=get&";

NSString *const kMaxOutUrl = @"http://tehui.youpu.cn/api/baokuanDetail/?paramType=get&";

NSString *const kMaxListUrl = @"http://tehui.youpu.cn/api/baokuanList/?paramType=get&";

NSString *const kEmailExistUrl = @"http:tehui.youpu.cn/api/regeditCheckEmail/?paramType=get&";

NSString *const kBindQQAndSinaUrl = @"http:tehui.youpu.cn/api/bindUnionToUser/?paramType=get&";

NSString *const kQQLoginUrl = @"http://tehui.youpu.cn/api/unionLogin/?paramType=get&";

NSString *const kForgetUrl = @"http://tehui.youpu.cn/api/checkMobileAndSendCode/?paramType=get&";

NSString *const kValidateUrl = @"http://tehui.youpu.cn/api/checkMobileCode/?paramType=get&";

NSString *const kIconUrl = @"http://tehui.youpu.cn/api/setUserIcon/?paramType=get&";

NSString *const kUserInfoUrl = @"http://tehui.youpu.cn/api/userInfo/?paramType=get&";

NSString *const kReviseUrl = @"http://tehui.youpu.cn/api/changeUserInfo/?paramType=get&";

NSString *const kCollectUrl = @"http://tehui.youpu.cn/api/addFavorite/?paramType=get&";

NSString *const kCollectListUrl = @"http://tehui.youpu.cn/api/favoriteList/?paramType=get&";

NSString *const kDeleteCollectUrl = @"http://tehui.youpu.cn/api/removeFavorite/?paramType=get&";

NSString *const kForgetPassEmail = @"http://tehui.youpu.cn/api/forgetPassEmail/?paramType=get&";

NSString *const kReSetPassUrl = @"http://tehui.youpu.cn/api/reSetPass/?paramType=get&";

NSString *const kFeedBackUrl = @"http://tehui.youpu.cn/api/feedBack/?paramType=get&";

NSString *const kNumberUrl = @"http://tehui.youpu.cn/api/customizeCount/?paramType=get&";


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
        NSLog(@"AMZ_CONNECT_URL_STRING = %@",urlstr);
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
