//
//  DetailViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-31.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"
#import "detailView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApiObject.h"
#import "AddViewController.h"
#import "WXApi.h"
#import <SinaWeiboConnection/ISSSinaWeiboApp.h>
#import "DetailTableViewCell.h"
#import "LoginViewController.h"

#define TEXT_COLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

static DetailViewController *detail = nil;

@interface DetailViewController ()
{
    NSString *  _isFavorite;
    NSInteger _i;
    UIActivityIndicatorView * _indicator;//菊花
    UILabel * imageLable;
    NSInteger _k;
}

@end

@implementation DetailViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
       
        detail = [[self alloc]initWithNibName:nil bundle:nil];
    });
    return detail;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.detailDic = [[NSMutableDictionary alloc] init];
        
        self.array = [NSMutableArray array];
        
        self.expandFlagArr = [NSMutableArray array];
        
        self.imageArr = [NSMutableArray array];
        
        self.lableArr = [[NSMutableArray alloc]init];
        
        _i=0;
        _k=0;

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
  
    _k = self.isCollect;
    if (_k==0) {
        [self detailView];
    }
    if (_k==1) {
        [self isSelecting];
    }
 
    [self goodTableView];
    [self detailConncet];
 
}

-(void)viewWillDisappear:(BOOL)animated{
    _i=0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.15]];
    [self.navigationController setNavigationBarHidden:YES];
}

//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}

-(void)detailView{
    detailView * de = [[detailView alloc]init];
    [de.backImage setImage:[UIImage imageNamed:@"back"]];
    [de.button addTarget:self action:@selector(backandback) forControlEvents:UIControlEventTouchUpInside];
    [de.backImage addTarget:self action:@selector(backandback)];
    [de.image setImage:[UIImage imageNamed:@"1"]];
    [de.image addTarget:self action:@selector(shareAll)];
    [de.collectImage setImage:[UIImage imageNamed:@"收藏"]];
    [de.collectImage addTarget:self action:@selector(collectList)];
    [self.view addSubview:de];
}
-(void)isSelecting{
    
    detailView * de = [[detailView alloc]init];
    [de.backImage setImage:[UIImage imageNamed:@"back"]];
    [de.button addTarget:self action:@selector(backandback) forControlEvents:UIControlEventTouchUpInside];
    [de.backImage addTarget:self action:@selector(backandback)];
    [de.image setImage:[UIImage imageNamed:@"1"]];
    [de.image addTarget:self action:@selector(shareAll)];
    [de.collectImage setImage:[UIImage imageNamed:@"收藏成功"]];
    [de.collectImage addTarget:self action:@selector(cancleCollect)];
    [self.view addSubview:de];
}

-(void)backandback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)shareAll{
    
    NSDictionary * dic = [self.detailDic objectForKey:@"data"];
    NSString * strings = [dic objectForKey:@"title"];
    NSString * price = [dic objectForKey:@"price"];
    NSString * front = [NSString stringWithFormat:@"%@ %@%@",@"【￥",price,@"起 "];
    NSString * behind = [NSString stringWithFormat:@"%@%@",strings,@"】"];
    NSString * last = [NSString stringWithFormat:@"%@%@",front,behind];
    NSString * url = [dic objectForKey:@"fromUrl"];
    NSString * imageUrl = [dic objectForKey:@"thumbPath"];
    id<ISSCAttachment> shareImage = [ShareSDK imageWithUrl:imageUrl];
    NSString * titleDes = [dic objectForKey:@"titleDescribe"];
 
    id<ISSContent> publishContent = [ShareSDK content:last defaultContent:@"默认分享内容" image:shareImage title:strings url:url description:titleDes mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    
    NSString * tehui = @"http://tehui.youpu.cn/line/";
    NSString * tehuiDetail = [NSString stringWithFormat:@"%@%@%@",tehui,_lineNumber,@"/"];
    
    //自定义QQ空间分享
    id<ISSShareActionSheetItem> qqZone = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]  icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace] clickHandler:^{
        
        NSString * fromCity = [dic objectForKey:@"fromCity"];
        NSString * toCity = [dic objectForKey:@"toCity"];
        NSString * fromTo = [NSString stringWithFormat:@"%@%@%@",fromCity,@"-",toCity];
        NSString * titleDes = [dic objectForKey:@"titleDescribe"];
        NSString * thumb = [dic objectForKey:@"thumbPath"];
        
        id<ISSCAttachment> shareImage = [ShareSDK imageWithUrl:thumb];
        
        [ShareSDK shareContent:[ShareSDK content:fromTo defaultContent:@"" image:shareImage title:fromTo url:tehuiDetail description:titleDes mediaType:SSPublishContentMediaTypeNews] type:ShareTypeQQSpace authOptions:authOptions shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
            
            if (state == SSPublishContentStateSuccess) {
                NSLog(@"哎呀,成功啦.");
            }else if (state == SSPublishContentStateFail){
                NSLog(@"笨死啦,分享失败");
            }
            
        }];
        
    }];
    
    //自定义新浪微博分享
    id<ISSShareActionSheetItem> sina = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo] clickHandler:^{
        
        //准备需要分享的内容
        NSDictionary * dic = [self.detailDic objectForKey:@"data"];
        NSString * string = [dic objectForKey:@"title"];
        NSString * price = [dic objectForKey:@"price"];
        NSString * front = [NSString stringWithFormat:@"%@ %@%@",@"【￥",price,@"起 "];
        NSString * behind = [NSString stringWithFormat:@"%@%@",string,@"】 ,"];
        NSString * last = [NSString stringWithFormat:@"%@%@",front,behind];
        NSString * first = [NSString stringWithFormat:@"%@",@"我在@游谱特惠 发现了一条超值特价, "];
        NSString * finally = [NSString stringWithFormat:@"%@%@",first,last];
        NSString * haha = [NSString stringWithFormat:@"%@",@"点击这里帮我看看值不值? >> "];
        NSString * haUrl = [NSString stringWithFormat:@"%@%@",haha,url];
        
        NSString * sina = [NSString stringWithFormat:@"%@%@",finally,haUrl];
        
        [ShareSDK shareContent:[ShareSDK content:sina defaultContent:@"看看啥" image:nil title:@"自由行" url:tehuiDetail description:@"别错过了哟" mediaType:SSPublishContentMediaTypeNews] type:ShareTypeSinaWeibo authOptions:authOptions shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else if (state == SSPublishContentStateFail){
                NSLog(@"笨死啦,分享失败");
            }
            
        }];
        
    }];
    
    //QQ好友分享
    id<ISSShareActionSheetItem> QQ = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQ] icon:[ShareSDK getClientIconWithType:ShareTypeQQ] clickHandler:^{
        
        NSString * fromCity = [dic objectForKey:@"fromCity"];
        NSString * toCity = [dic objectForKey:@"toCity"];
        NSString * fromTo = [NSString stringWithFormat:@"%@%@%@",fromCity,@"-",toCity];
        NSString * titleDes = [dic objectForKey:@"titleDescribe"];
        NSString * thumb = [dic objectForKey:@"thumbPath"];
        id<ISSCAttachment> shareImage = [ShareSDK imageWithUrl:thumb];
        
        [ShareSDK shareContent:[ShareSDK content:titleDes defaultContent:@"" image:shareImage title:fromTo url:tehuiDetail description:@"" mediaType:SSPublishContentMediaTypeNews] type:ShareTypeQQ authOptions:authOptions statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                NSLog(@"success");
            }else if (state == SSPublishContentStateFail){
                NSLog(@"qzy提示你:分享无效,请重试");
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"qzy" message:@"请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",     nil];
                [alert show];
            }
        }];
    }];
    
    //微信朋友圈分享
    id<ISSShareActionSheetItem> weixin = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline] icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline] clickHandler:^{
        
        NSString * title = [dic objectForKey:@"title"];
        NSString * titleDes = [dic objectForKey:@"titleDescribe"];
        NSString * imageUrl = [dic objectForKey:@"thumbPath"];
        id<ISSCAttachment> bigImage = [ShareSDK imageWithUrl:imageUrl];
        
        [ShareSDK shareContent:[ShareSDK content:title defaultContent:@"" image:bigImage title:titleDes url:tehuiDetail description:@"" mediaType:SSPublishContentMediaTypeApp] type:ShareTypeWeixiTimeline authOptions:authOptions statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",     nil];
                [alert show];
            }else if (state == SSPublishContentStateFail){
                NSLog(@"qzy提示你:分享无效,请重试");
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"qzy" message:@"请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",     nil];
                [alert show];
            }
        }];
    }];
    
    //微信好友分享
    id<ISSShareActionSheetItem> WXfriend = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession] icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession] clickHandler:^{
        
        NSString * fromCity = [dic objectForKey:@"fromCity"];
        NSString * toCity = [dic objectForKey:@"toCity"];
        NSString * fromTo = [NSString stringWithFormat:@"%@%@%@",fromCity,@"-",toCity];
        NSString * titleDes = [dic objectForKey:@"titleDescribe"];
        NSString * thumb = [dic objectForKey:@"thumbPath"];
        
        id<ISSCAttachment> shareImage =[ShareSDK imageWithUrl:thumb];

        
        
        [ShareSDK shareContent:[ShareSDK content:titleDes defaultContent:@"来自游谱特惠" image:shareImage title:fromTo url:tehuiDetail description:@"" mediaType:SSPublishContentMediaTypeNews] type:ShareTypeWeixiSession authOptions:authOptions statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                NSLog(@"success");
            }else if (state == SSPublishContentStateFail){
                NSLog(@"qzy提示你:分享无效,请重试");
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"qzy" message:@"请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }];
    }];

    
    //创建自定义分享列表
    NSArray * array = [ShareSDK customShareListWithType:WXfriend,weixin,sina,QQ,qqZone, nil];
    
    [ShareSDK showShareActionSheet:nil shareList:array content:publishContent statusBarTips:NO authOptions:authOptions shareOptions:[ShareSDK  defaultShareOptionsWithTitle:nil oneKeyShareList:[NSArray defaultOneKeyShareList] cameraButtonHidden:NO mentionButtonHidden:NO topicButtonHidden:NO qqButtonHidden:NO wxSessionButtonHidden:NO wxTimelineButtonHidden:NO showKeyboardOnAppear:NO shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil] result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
        
        if (state == SSPublishContentStateSuccess) {
            NSLog(@"哈哈哈,成功啦");
        }else if (state == SSPublishContentStateFail){
            
            NSLog(@"哎 失败");
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您的网络不给力%>_<%" message:@"网络不给力啊，我们没能帮您分享，网络信号好的时候再来试试吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [alert show];
            
        }
    }];
}

#pragma mark
#pragma mark -------------------添加收藏
-(void)collectList{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"]==nil) {
        
        LoginViewController * login = [[LoginViewController alloc]init];
        UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:na animated:NO completion:nil];

    }else{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * lineID = _lineNumber;
    NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",lineID,memberId,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    lineID = [NSString stringWithFormat:@"%@=%@%@",@"lineId",lineID,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kCollectUrl,time,lineID,memberId];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
            UIAlertView * laert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [laert show];
            detailView * de = [[detailView alloc]init];;
            [de.collectImage setImage:[UIImage imageNamed:@"收藏成功"]];
            [de.collectImage addTarget:self action:@selector(cancleCollect)];
            [de.backImage setImage:[UIImage imageNamed:@"back"]];
            [de.backImage addTarget:self action:@selector(backandback)];
            [de.image setImage:[UIImage imageNamed:@"1"]];
            [de.image addTarget:self action:@selector(shareAll)];
            [self.view addSubview:de];
            _k=1;
        }
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]){
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏该线路" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
    }];
        
    }
}

#pragma mark
#pragma mark -------------------取消收藏
-(void)cancleCollect{
 
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * lineID = _lineNumber;
    NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",lineID,memberId,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    lineID = [NSString stringWithFormat:@"%@=%@%@",@"lineId",lineID,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kDeleteCollectUrl,time,lineID,memberId];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
            detailView * de = [[detailView alloc]init];
            [de.collectImage setImage:[UIImage imageNamed:@"收藏"]];
            [de.collectImage addTarget:self action:@selector(collectList)];
            [de.backImage setImage:[UIImage imageNamed:@"back"]];
            [de.backImage addTarget:self action:@selector(backandback)];
            [de.image setImage:[UIImage imageNamed:@"1"]];
            [de.image addTarget:self action:@selector(shareAll)];
            [self.view addSubview:de];
            _k=0;
        }
    }];
    
}


- (NSString *)md5:(NSString *)str
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
#pragma mark -------------------网络请求
-(void)detailConncet{
   
    [self addIndicator];
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * lindId = self.lineNumber;
    NSString * memberId = nil;
    if (memberId==nil) {
        memberId = @"1";
    }else{
        memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    }
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",lindId,memberId,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    lindId = [NSString stringWithFormat:@"%@=%@%@",@"lineId",self.lineNumber,@"&"];
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kDetailUrl,time];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@%@",lastUrl,lindId,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.detailDic addEntriesFromDictionary:dic];
        _isFavorite =[[_detailDic objectForKey:@"data"]objectForKey:@"isFavorite"];
        BOOL haha = [_isFavorite boolValue];
        if (_k==0) {
            if (haha==false) {
                [self detailView];
            }else{
                [self isSelecting];
            }
            
        }
        [self createImageView];
        [self createBook];
        [self loadLabelArray];
        [self.bigTableView reloadData];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
      
    }];

}

- (void)loadLabelArray {
    
    NSDictionary * dic =[self.detailDic objectForKey:@"data"];
    NSString * string = [dic objectForKey:@"services"];
    NSString * strings = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    
    NSString * bring = [dic objectForKey:@"BrightSpot"];
    NSString * bright = [bring stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    
    NSString * air = [dic objectForKey:@"Flightinfo"];
    NSString * airPort = [air stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    
    
    NSString *HotleName =[dic objectForKey:@"HotleName"];
    NSString * hotelMessage =[NSString stringWithFormat:@"%@%@", @"酒店信息:",HotleName];
    NSString * hotelname = @"";
    if ([[dic objectForKey:@"HotleName"]isEqualToString:@""]) {
        hotelMessage =@"";
    }else{
        hotelname = [hotelMessage stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    }
    
    NSString *HotleMiaoshu = [dic objectForKey:@"HotleMiaoshu"];
    NSString * hotelMs = [NSString stringWithFormat:@"%@%@",@"酒店介绍:",HotleMiaoshu];
    NSString * hotelMiaoShu = @"";
    if ([HotleMiaoshu isEqualToString:@""]) {
        hotelMs = @"";
    }else{
        hotelMiaoShu = [hotelMs stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
    }
    NSString * hotelNA = @"";
    if (![hotelMessage isEqualToString:@""] && ![hotelMs isEqualToString:@""]) {
        hotelNA = [NSString stringWithFormat:@"%@%@%@",hotelname,@"\r\n\r\n",hotelMiaoShu];
    }
    
    NSString *HotleAddress =[dic objectForKey:@"HotleAddress"];
    NSString * hotelAdd = [NSString stringWithFormat:@"%@%@",@"酒店地址:", HotleAddress];
    NSString * hotelAddress = @"";
    if ([[dic objectForKey:@"HotleAddress"]isEqualToString:@""]) {
        hotelAdd = @"";
    }else{
        hotelAddress = [hotelAdd stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    }
    NSString * hotelAll = @"";
    if (![hotelNA isEqualToString:@""] && ![hotelAddress isEqualToString:@""]) {
        hotelAll = [NSString stringWithFormat:@"%@%@%@",hotelNA,@"\r\n\r\n",hotelAddress];
    }

    NSString * line = [dic objectForKey:@"Schedule"];
    NSString * lines =[line stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    
    NSString *notes = [dic objectForKey:@"Notes"];
    NSString * notess = [notes stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    NSString *visa = [dic objectForKey:@"Visa"];
    NSString *costNo = [dic objectForKey:@"CostNo"];
    NSString *CostNO = [costNo stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    
    [_array removeAllObjects];
    [_lableArr removeAllObjects];
    [_imageArr removeAllObjects];
    UIImage * image = [UIImage imageNamed:@"费用"];
    UIImage * aImage = [UIImage imageNamed:@"亮点"];
    UIImage * bImage = [UIImage imageNamed:@"机票"];
    UIImage * cImage = [UIImage imageNamed:@"酒店"];
    UIImage * dImage = [UIImage imageNamed:@"线路"];
    UIImage * eImage = [UIImage imageNamed:@"签证"];
    UIImage * fImage = [UIImage imageNamed:@"预定须知"];
    UIImage * gImage = [UIImage imageNamed:@"费用不含"];
    
    if (! [strings isEqualToString:@""]) {
        [_lableArr addObject:strings];
        [_array addObject:@"费用包含"];
        [_imageArr addObject:image];
    }
    if (! [bright isEqualToString:@""]) {
        [_lableArr addObject:bright];
        [_array addObject:@"亮点描述"];
        [_imageArr addObject:aImage];
    }
    if (! [airPort isEqualToString:@""]) {
        [_lableArr addObject:airPort];
        [_array addObject:@"机票包含"];
        [_imageArr addObject:bImage];
    }
    if(![HotleName isEqualToString:@""] ||![HotleMiaoshu isEqualToString:@""]||![HotleAddress isEqualToString:@""]){

        NSString * all = [NSString stringWithFormat:@"%@%@%@",(HotleName?hotelname:@""),(HotleMiaoshu?hotelMiaoShu:@""),(HotleAddress?hotelAddress:@"")];
        
//        [_lableArr addObject:hotelAll];
        [_lableArr addObject:all];
        [_array addObject:@"酒店包含"];
        [_imageArr addObject:cImage];
    }
    if (! [lines isEqualToString:@""]) {
        [_lableArr addObject:lines];
        [_array addObject:@"行程介绍"];
        [_imageArr addObject:dImage];
    }
    if (![notes isEqualToString:@""]) {
        [_lableArr addObject:notess];
        [_array addObject:@"预订须知"];
        [_imageArr addObject:eImage];
    }
    if (![visa isEqualToString:@""]) {
        [_lableArr addObject:visa];
        [_array addObject:@"签证信息"];
        [_imageArr addObject:fImage];
    }
    if (![costNo isEqualToString:@""]) {
        [_lableArr addObject:CostNO];
        [_array addObject:@"费用不含"];
        [_imageArr addObject:gImage];
    }
    
    [_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if (idx == 0) {
            [_expandFlagArr addObject:@YES];
       // }
//        else {
//            [_expandFlagArr addObject:@NO];
//        }
    }];
}

#pragma mark
#pragma mark ------------------创建上方view
-(void)createImageView{
    
    NSDictionary * dic =[self.detailDic objectForKey:@"data"];
    NSString * thumb = [dic objectForKey:@"thumbPath"];
    
    imageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 620)];
    [imageLable setUserInteractionEnabled:YES];
    [imageLable setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.15]];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, imageLable.frame.size.width, 300)];
    if ([thumb isEqualToString:@""]) {
        [image setImage:[UIImage imageNamed:@"noImageDetail.jpg"]];
        
    }else{
        [image setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@"noImageDetail.jpg"]];
    }
  
    [imageLable addSubview:image];
    
    UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.frame.size.width, 60)];
    [view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6]];
    
    UILabel *upLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 270, 20)];
    NSString * titString = [dic objectForKey:@"titleDescribe"];
    [upLable setText:titString];
    [upLable setTextAlignment:NSTextAlignmentCenter];
    upLable.numberOfLines = 0;
    [upLable setLineBreakMode:NSLineBreakByWordWrapping];
    [upLable setFont:[UIFont systemFontOfSize:16]];
    [upLable sizeToFit];
    [upLable setTextColor:[UIColor whiteColor]];
    
    NSDictionary *attributeTitle = @{NSFontAttributeName: [UIFont systemFontOfSize: 16]};
    CGSize requiredSizeTitle = [titString boundingRectWithSize:CGSizeMake(270, 0) options:
                                NSStringDrawingTruncatesLastVisibleLine |
                                NSStringDrawingUsesLineFragmentOrigin |
                                NSStringDrawingUsesFontLeading
                                                            attributes:attributeTitle context:nil].size;
    if (requiredSizeTitle.height<=20) {
        [view setFrame:CGRectMake(0, 0, image.frame.size.width, 40)];
    }else{
       [view setFrame:CGRectMake(0, 0, image.frame.size.width, 70)];
    }
    [view addSubview:upLable];
    [image addSubview:view];
    
    UIView * smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, image.frame.size.width, 40)];
    [smallView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6]];
    [image addSubview:smallView];
    
    UIImageView * money = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 15, 15)];
    [money setImage:[UIImage imageNamed:@"钱币icon"]];
    [smallView addSubview:money];
    
    UILabel * priceLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 100, 30)];
    [priceLable setFont:[UIFont systemFontOfSize:24]];
    [priceLable setTextColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1]];
    [priceLable setText:[[dic objectForKey:@"price"] stringValue]];
    [smallView addSubview:priceLable];
    
    UILabel * baseLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 9, 40, 13)];
    [baseLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
    [baseLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    if ([[[dic objectForKey:@"basePrice"] stringValue] isEqualToString:@"0"]) {
        [baseLable setText:@""];
    }else{
        [baseLable setText:[[dic objectForKey:@"basePrice"] stringValue]];
    }
    [smallView addSubview:baseLable];
    
    
    UILabel * leaveLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 22, 70, 15)];
    [leaveLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [leaveLable setTextColor:[UIColor whiteColor]];
    NSString * leaveStr = [dic objectForKey:@"bit"];
    if ([leaveStr intValue]<10) {
        
        NSString * leaveString = [NSString stringWithFormat:@"%@%@%@",@"剩余",leaveStr,@"席"];
        //显示不同颜色字体的lable
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:leaveString];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, 1)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(3, 1)];
        leaveLable.attributedText = attributed;
        
    }else if([leaveStr intValue]>=10 && [leaveStr intValue]<100){
        NSString * leaveString = [NSString stringWithFormat:@"%@%@%@",@"剩余",leaveStr,@"席"];
        //显示不同颜色字体的lable
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:leaveString];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(4, 1)];
        leaveLable.attributedText = attributed;
    }else{
        
        NSString * leaveString = [NSString stringWithFormat:@"%@%@%@",@"剩余",leaveStr,@"席"];
        //显示不同颜色字体的lable
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:leaveString];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, 3)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(5, 1)];
        leaveLable.attributedText = attributed;
    }
    
    [smallView addSubview:leaveLable];
    
    
    UIImageView * stayImage = [[UIImageView alloc] initWithFrame:CGRectMake(215, 14, 20, 20)];
    [stayImage setImage:[UIImage imageNamed:@"详情页icon@2x_06"]];
    [smallView addSubview:stayImage];
    WhiteLableText * stayLable = [[WhiteLableText alloc] initWithFrame:CGRectMake(228, 24, 30, 10)];
    NSString * stayStr = [dic objectForKey:@"daysShow"];
    NSString *stayString = [stayStr stringByReplacingOccurrencesOfString:@"天" withString:@""];
    [stayLable setText:stayString];
    [stayLable setFont:[UIFont systemFontOfSize:8]];
    [stayLable setTextColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1]];
    [smallView addSubview:stayLable];
    
    UIImageView * hotImage = [[UIImageView alloc] initWithFrame:CGRectMake(273, 14, 20, 20)];
    [hotImage setImage:[UIImage imageNamed:@"详情页icon@2x_12"]];
    [smallView addSubview:hotImage];
    WhiteLableText * hotLable = [[WhiteLableText alloc] initWithFrame:CGRectMake(287, 19, 30, 10)];
    [hotLable setFont:[UIFont systemFontOfSize:8]];
    NSString * fuhao =  @"★";
    NSString * stars = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"hotelStar"],fuhao];
    [hotLable setTextColor:[UIColor colorWithRed:255/255.0 green:199/255.0 blue:38/255.0 alpha:1]];
    [smallView addSubview:hotLable];
    
    UIImageView * zhiImage = [[UIImageView alloc] initWithFrame:CGRectMake(244, 14, 20, 20)];
    [zhiImage setImage:[UIImage imageNamed:@"详情页icon@2x_14"]];
    [smallView addSubview:zhiImage];
    
    if ([[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [hotImage setHidden:YES];
        
    }else{
        
        [hotImage setHidden:NO];
        [hotLable setText:stars];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"] && ![[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [hotImage setFrame:CGRectMake(244, 14, 20, 20)];
        [hotLable setFrame:CGRectMake(258, 19, 20, 20)];
        [hotLable setText:stars];
        [zhiImage setHidden:YES];
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]){
        
        [zhiImage setHidden:NO];
        [hotImage setFrame:CGRectMake(273, 14, 20, 20)];
        [hotLable setFrame:CGRectMake(287, 19, 20, 20)];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]&& ![[dic objectForKey:@"hotelStar"]isEqualToString:@""])
    {
        [hotImage setHidden:NO];
        [hotLable setText:stars];
        [hotLable setFrame:CGRectMake(287, 19, 20, 20)];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"]&& [[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [hotImage setHidden:YES];
        [hotLable setText:@""];
        [zhiImage setHidden:YES];
    }
    
    
    //view下面的lable控件
    UILabel * downLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, imageLable.frame.size.width, 280)];
    [downLable setUserInteractionEnabled:YES];
    [downLable setBackgroundColor:[UIColor whiteColor]];
    [imageLable addSubview:downLable];

    UILabel * fromLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 20)];
    [fromLable setText:@"始发地:"];
    [fromLable setTextColor:TEXT_COLOR];
    [fromLable setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:fromLable];
    
    UILabel * cityLable = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 100, 20)];
    [cityLable setText:[dic objectForKey:@"fromCity"]];
    [cityLable setTextColor:TEXT_COLOR];
    [cityLable setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:cityLable];
    
    UILabel * tocityLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 50, 20)];
    [tocityLable setText:@"目的地:"];
    [tocityLable setTextColor:TEXT_COLOR];
    [tocityLable setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:tocityLable];
    
    UILabel * toCity = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 255, 20)];
    [toCity setText:[dic objectForKey:@"toCity"]];
    [toCity setTextColor:TEXT_COLOR];
    [toCity setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:toCity];
    
    UILabel * travelLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 70, 20)];
    [travelLable setText:@"出发时间:"];
    [travelLable setTextColor:TEXT_COLOR];
    [travelLable setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:travelLable];
    
    UILabel * travelTime = [[UILabel alloc] initWithFrame:CGRectNull];
    NSString *travel = [dic objectForKey:@"travelDepTimeShow"];
    NSString * deleteBr = [travel stringByReplacingOccurrencesOfString:@"<br>"  withString:@"\r\n"];
    [travelTime setText:deleteBr];
    travelTime.numberOfLines = 0;
    [travelTime setLineBreakMode:NSLineBreakByWordWrapping];
    [travelTime setTextColor:TEXT_COLOR];
    [travelTime setFont:[UIFont systemFontOfSize:14]];
    
    UILabel * cooperate = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, 70, 20)];
    [cooperate setText:@"合作伙伴:"];
    [cooperate setTextColor:TEXT_COLOR];
    [cooperate setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:cooperate];
    
    //添加在线预定button
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(170, 125, 80, 20)];
    [button setTitle:@"在线预订" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [button addTarget:self action:@selector(callCooperate) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [downLable addSubview:button];
    
    UILabel * coopLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 125, 100, 20)];
    if ([[dic objectForKey:@"dataFrom"] isEqualToString:@"中青旅遨游网"]) {
        button.hidden=YES;
    }else{
        button.hidden = NO;
    }
    [coopLable setText:[dic objectForKey:@"dataFrom"]];
    [coopLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [coopLable setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:coopLable];
    
    UILabel * dianhua = [[UILabel alloc]initWithFrame:CGRectMake(15, 148, 70, 20)];
    [dianhua setText:@"咨询电话:"];
    [dianhua setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [dianhua setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:dianhua];
    
    NSString * allPhone =[[dic objectForKey:@"dataFromPhone"] stringByReplacingOccurrencesOfString:@"," withString:@"转"];
    UIButton * dadianhua  = [[UIButton alloc] initWithFrame:CGRectMake(80, 148, 120, 20)];
    [dadianhua setTitle:allPhone forState:UIControlStateNormal];
    [dadianhua setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [dadianhua addTarget:self action:@selector(callOthers) forControlEvents:UIControlEventTouchUpInside];
    [dadianhua.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [downLable addSubview:dadianhua];
    
    NSRange range = [travel rangeOfString:@"<"];
    NSString * brString = travel;
    for (int i = 0 ; i < brString.length; i++) {
//        if (brString.length<=78) {
//            NSString *qzy = [brString substringWithRange:NSMakeRange(i, 1)];
//            if ([qzy isEqualToString:@"<"]) {
//                _i++;
//            }
//        }
         if (brString.length<=200){
            NSString *qzy = [brString substringWithRange:NSMakeRange(i, 1)];
            if ([qzy isEqualToString:@"<"]) {
                _i++;
            }
        }
        
    }

    if (range.location== NSNotFound) {
        [imageLable setFrame:CGRectMake(0, 10, _bigTableView.frame.size.width, 460)];
         [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 140)];
        if (travelTime.text.length<=30) {
        [travelTime setFrame:CGRectMake(79, 55, 205, 20)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 80, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 80, 100, 20)];
        [button setFrame:CGRectMake(170, 80, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 103, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 104, 120, 20)];
        }else{
        [travelTime setFrame:CGRectMake(79, 55, 205, 40)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 100, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 100, 100, 20)];
        [button setFrame:CGRectMake(170, 100, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 123, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 124, 120, 20)];
        }
        
    }else if (range.length>0 && _i==1){
        [imageLable setFrame:CGRectMake(0, 10, _bigTableView.frame.size.width, 480)];
         [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 160)];
        if (travelTime.text.length<=49) {
            [travelTime setFrame:CGRectMake(79, 54, 205, 40)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 100, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 100, 100, 20)];
            [button setFrame:CGRectMake(170, 100, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 123, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 124, 120, 20)];
        }else{
        [travelTime setFrame:CGRectMake(79, 52, 205, 60)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 110, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 110, 100, 20)];
        [button setFrame:CGRectMake(170, 110, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 133, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 134, 120, 20)];
        }
    }else if (range.length>0 && _i==2){
        [imageLable setFrame:CGRectMake(0, 10, _bigTableView.frame.size.width, 500)];
         [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 180)];
        if (travelTime.text.length<=55) {
            [travelTime setFrame:CGRectMake(79, 52, 205,60)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 120, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 120, 100, 20)];
            [button setFrame:CGRectMake(170, 120, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 143, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 145, 120, 20)];
        }else{
            [travelTime setFrame:CGRectMake(79, 55, 205,70)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 130, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 130, 100, 20)];
            [button setFrame:CGRectMake(170, 130, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 153, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 155, 120, 20)];
        }
    }else if(range.length>0 && _i==3){
        [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 520)];
        [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 200)];
        if (travelTime.text.length <=100) {
            [travelTime setFrame:CGRectMake(79, 50, 205, 80)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 137, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 137, 100, 20)];
            [button setFrame:CGRectMake(170, 137, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 160, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 162, 120, 20)];
        }
        else if(travelTime.text.length <=109 &&travelTime.text.length >=100){
            
            [travelTime setFrame:CGRectMake(79, 35, 205, 130)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 160, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 160, 100, 20)];
            [button setFrame:CGRectMake(170, 160, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 178, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 180, 120, 20)];
        
        }else if (travelTime.text.length <=130 &&travelTime.text.length >=109){
            [travelTime setFrame:CGRectMake(79, 42, 205, 130)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 160, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 160, 100, 20)];
            [button setFrame:CGRectMake(170, 160, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 178, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 180, 120, 20)];
        }
        else{
            
            [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 550)];
            [_bigTableView setTableHeaderView:imageLable];
            [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 230)];
            [travelTime setFrame:CGRectMake(79, 35, 205, 160)];
            [downLable addSubview:travelTime];
            [cooperate setFrame:CGRectMake(15, 180, 70, 20)];
            [coopLable setFrame:CGRectMake(80, 180, 100, 20)];
            [button setFrame:CGRectMake(170, 180, 80, 20)];
            [dianhua setFrame:CGRectMake(15, 203, 70, 20)];
            [dadianhua setFrame:CGRectMake(80, 205, 120, 20)];
            
        }
        
    }else if (range.length>0 && _i==4){
        [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 530)];
        [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 210)];
        [travelTime setFrame:CGRectMake(79, 50, 205, 100)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 147, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 147, 100, 20)];
        [button setFrame:CGRectMake(170, 147, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 170, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 172, 120, 20)];
    }else if (range.length>0 && _i==5){
        [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 550)];
        [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 230)];
        [travelTime setFrame:CGRectMake(79, 47, 205, 120)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 167, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 167, 100, 20)];
        [button setFrame:CGRectMake(170, 167, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 190, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 192, 120, 20)];
    }else if (range.length>0 && _i==6){
        [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 560)];
        [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 240)];
        [travelTime setFrame:CGRectMake(79, 45, 205, 140)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 187, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 187, 100, 20)];
        [button setFrame:CGRectMake(170, 187, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 207, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 209, 120, 20)];
    }else if (range.length>0 && _i==7){
        [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 580)];
        [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 260)];
        [travelTime setFrame:CGRectMake(79, 44, 205, 160)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 200, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 200, 100, 20)];
        [button setFrame:CGRectMake(170, 200, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 220, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 222, 120, 20)];
    }else if(range.length>0 && _i==8){
        [imageLable setFrame:CGRectMake(0, 0, _bigTableView.frame.size.width, 600)];
        [_bigTableView setTableHeaderView:imageLable];
        [downLable setFrame:CGRectMake(0, 310, imageLable.frame.size.width, 280)];
        [travelTime setFrame:CGRectMake(79, 45, 205, 180)];
        [downLable addSubview:travelTime];
        [cooperate setFrame:CGRectMake(15, 220, 70, 20)];
        [coopLable setFrame:CGRectMake(80, 220, 100, 20)];
        [button setFrame:CGRectMake(170, 220, 80, 20)];
        [dianhua setFrame:CGRectMake(15, 240, 70, 20)];
        [dadianhua setFrame:CGRectMake(80, 242, 120, 20)];
        
    }
    
}

-(void)callOthers{
    
    NSDictionary * dic =[self.detailDic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tel"];
    NSString *telStr = [NSString stringWithFormat:@"%@%@",@"tel://",str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}

#pragma mark
#pragma mark ------------------------- 预订按钮点击时间
-(void)callCooperate{
    
    NSDictionary * dic =[self.detailDic objectForKey:@"data"];
    
    WebViewController * web = [[WebViewController alloc] init];
    web.string = [dic objectForKey:@"fromUrl"];
    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:web];
    
    [self presentViewController:na animated:NO completion:nil];
    
}
-(void)hiddenLine:(UITableView *)tableView{
    
    UIView * view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
    
}

#pragma mark
#pragma mark -------------------------tableview
-(void)goodTableView{
    
    self.bigTableView = [[UITableView alloc] initWithFrame:CGRectMake( 10, 64, self.view.frame.size.width-20, self.view.frame.size.height-103) style:UITableViewStylePlain];
    _bigTableView.delegate = self;
    _bigTableView.dataSource = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >=7.0) {
        [_bigTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [_bigTableView setTableHeaderView:imageLable];
    [_bigTableView setShowsVerticalScrollIndicator:NO];//上下方向的滚动条

    [_bigTableView setSeparatorColor:[UIColor clearColor]];
    [self hiddenLine:_bigTableView];
    [self.view addSubview:_bigTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lableArr.count > 0) {
        if ([_expandFlagArr[indexPath.section] boolValue]) {
            NSString *text = self.lableArr[indexPath.section];
            CGSize fitSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            return 44 + fitSize.height + 10;
        } else {
            return 44;
        }
    }return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.lableArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIden = @"cell";
    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    [cell.frontImage setImage:[self.imageArr objectAtIndex:indexPath.section]];
    [cell.lable setText:[self.array objectAtIndex:indexPath.section]];
    if (self.lableArr.count > 0) {
        if ([_expandFlagArr[indexPath.section] boolValue]) {
            NSString *text = self.lableArr[indexPath.section];
            CGSize fitSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            cell.contentLabel.text = text;
            CGRect frame = cell.contentLabel.frame;
            frame.size.height = fitSize.height + 1;
            cell.contentLabel.frame = frame;
            cell.contentLabel.hidden = NO;
            [cell.jtImage setImage:[UIImage imageNamed:@"向上"]];
        
        } else {
            cell.contentLabel.hidden = YES;
            [cell.jtImage setImage:[UIImage imageNamed:@"向下"]];

        }
        
      
    }
    
    CALayer * lableLay = [CALayer layer];
    lableLay.frame =CGRectMake(0, 43, cell.frame.size.width, 0.7);
    lableLay.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    [cell.layer addSublayer:lableLay];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _expandFlagArr[indexPath.section] = @(! [_expandFlagArr[indexPath.section] boolValue]);
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
             withRowAnimation:UITableViewRowAnimationNone];
    if ([_expandFlagArr[indexPath.section] boolValue]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
    }

}

#pragma mark 
#pragma mark -下方电话咨询,预约定制图片
-(void)createBook{
    
    UIView * aView =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    [aView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
    [self.view addSubview:aView];

    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 151, 34)];
    [image setImage:[UIImage imageNamed:@"灰条"]];
    [image setUserInteractionEnabled:YES];
    [aView addSubview:image];
    
    UIButton * makeButton  =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 151, 34)];
    [makeButton addTarget:self action:@selector(goToMade) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:makeButton];
    
    UILabel * makeLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 71, 24)];
    [makeLable  setText:@"预约定制"];
    [makeLable setFont:[UIFont systemFontOfSize:16]];
    [makeLable setTextColor:[UIColor whiteColor]];
    [makeButton addSubview:makeLable];
    
    UIImageView * images = [[UIImageView alloc] initWithFrame:CGRectMake(25, 2, 30, 30)];
    [images setImage:[UIImage imageNamed:@"预约"]];
    [image addSubview:images];
    
    UIImageView * aImage = [[UIImageView alloc] initWithFrame:CGRectMake(163, 4, 151, 34)];
    [aImage setImage:[UIImage imageNamed:@"橙条"]];
    [aImage setUserInteractionEnabled:YES];
    [aView addSubview:aImage];
    
    
    UIButton * phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 151, 34)];
    [phoneButton addTarget:self action:@selector(callYou) forControlEvents:UIControlEventTouchUpInside];
    [aImage addSubview:phoneButton];
    
    UILabel * phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 71, 24)];
    [phoneLable  setText:@"电话咨询"];
    [phoneLable setFont:[UIFont systemFontOfSize:16]];
    [phoneLable setTextColor:[UIColor whiteColor]];
    [phoneButton addSubview:phoneLable];
    
    UIImageView * bookImage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 2, 30, 30)];
    [bookImage setImage:[UIImage imageNamed:@"白电话"]];
    [aImage addSubview:bookImage];
}
//去定制
-(void)goToMade{

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"memberId"]==nil) {
        LoginViewController * login =[[LoginViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:navi animated:NO completion:nil];
        
    }else{
        

        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_detailDic objectForKey:@"data"] objectForKey:@"fromCity"],@"detailFrom",[[_detailDic objectForKey:@"data"] objectForKey:@"toCity"],@"detailTo",[[_detailDic objectForKey:@"data"] objectForKey:@"fromCityCode"],@"detailFromCode",[[_detailDic objectForKey:@"data"] objectForKey:@"areaId"],@"detailToCode", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nicai" object:nil userInfo:dic];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.tab.selectedIndex = 2;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//图片点击事件
-(void)callYou{
    
    NSDictionary * dic =[self.detailDic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tel"];
    NSString *telStr = [NSString stringWithFormat:@"%@%@",@"tel://",str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
