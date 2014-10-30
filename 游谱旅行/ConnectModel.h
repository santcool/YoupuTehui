//
//  AMZConnectModel.h
//  UI_News_Fresh_Friut
//
//  Created by 王迹 on 14-5-9.
//  Copyright (c) 2014年 AnMenZu. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取服务器时间
extern NSString *const kServerTimeUrl;
//域名前缀
extern NSString *const kPrefixUrl;
//登录接口
extern NSString *const kLoginUrl;
//注册接口
extern NSString *const kSignUpUrl;
//出发城市列表
extern NSString * const kMainConnectUrl;
//过滤条件
extern NSString *const kFilterUrl;
//首页轮播图片
extern NSString *const kScrollUrl;
//首页线路接口
extern NSString *const kLineUrl;
//线路详情接口
extern NSString *const kDetailUrl;
//线路推荐列表
extern NSString *const  kRecommendUrl;
//我的定制列表
extern NSString *const kCustomUrl;
//定制信息详情
extern NSString *const kMadeDetailUrl;
//定制条件列表
extern NSString *const kFilterCaseListUrl;
//保存定制信息
extern NSString *const kSaveUrl;
//删除定制信息
extern NSString *const kDeleteUrl;
//定制展示列表
extern NSString *const kShowUrl;
//今日爆款详情
extern NSString *const kMaxOutUrl;
//爆款列表
extern NSString *const kMaxListUrl;
//注册时验证邮箱是否存在
extern NSString *const kEmailExistUrl;
//绑定联合登陆用户
extern NSString *const kBindQQAndSinaUrl;
//联合登陆
extern NSString *const kQQLoginUrl;
//验证手机号发送验证码
extern NSString *const kForgetUrl;
//验证短信校验码
extern NSString *const kValidateUrl;
//用户头像更新
extern NSString *const kIconUrl;
//用户信息
extern NSString *const kUserInfoUrl;
//修改用户信息
extern NSString *const kReviseUrl;
//添加收藏
extern NSString *const kCollectUrl;
//收藏列表
extern NSString *const kCollectListUrl;
//删除收藏
extern NSString *const kDeleteCollectUrl;
//忘记密码
extern NSString *const kForgetPassEmail;
//重置密码
extern NSString *const kReSetPassUrl;
//意见反馈
extern NSString *const kFeedBackUrl;
//定制上的数字
extern NSString *const kNumberUrl;
//推送列表
extern NSString *const kPushUrl;
//新爆款
extern NSString *const kNewMaxUrl;

//网络GET请求方式
extern NSString *const kConnectGetType;
//网络POST请求方式
extern NSString *const kConnectPostType;


typedef void(^FinishedBlock)();

@interface ConnectModel : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (nonatomic, copy) FinishedBlock finishedBlock;

@property (nonatomic, retain) NSMutableData * receiveData;

+(void)connectWithParmaters:(NSDictionary *)parmaters url:(NSString *)urlstr style:(NSString *)style finished:(void(^)(id result))block;
+ (void)uploadUserIcon:(NSDictionary *)parmaters icon:(NSData *)iconData url:(NSString *)urlstr finished:(void(^)(id result))block;
-(void)startConnect:(NSDictionary *)dic url:(NSString *)urlstr style:(NSString *)style;


@end
