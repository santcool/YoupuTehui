//
//  WebViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-28.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "WebViewController.h"
#import "DetailViewController.h"

@interface WebViewController ()
{
     UIActivityIndicatorView * _indicator;//菊花
}

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self qzy];
    [self webview];
    
}

-(void)qzy{
    self.title = @"信息详情";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareTopic) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [self.delegate fanhui];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)shareTopic{

    id<ISSCAttachment> topicImage = [ShareSDK imageWithUrl:_topicImage];
    
    id<ISSContent> publishContent = [ShareSDK content:@"" defaultContent:@"默认分享内容" image:nil title:_topicTitle url:_string description:nil mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    
    //自定义QQ空间分享
    id<ISSShareActionSheetItem> qqZone = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]  icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace] clickHandler:^{
        
       
        
        [ShareSDK shareContent:[ShareSDK content:@"" defaultContent:@"" image:topicImage title:_topicTitle url:_string description:@"" mediaType:SSPublishContentMediaTypeNews] type:ShareTypeQQSpace authOptions:authOptions shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
            
            if (state == SSPublishContentStateSuccess) {
                NSLog(@"哎呀,成功啦.");
            }else if (state == SSPublishContentStateFail){
                NSLog(@"笨死啦,分享失败");
            }
            
        }];
        
    }];
    
    //自定义新浪微博分享
    id<ISSShareActionSheetItem> sina = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo] clickHandler:^{
        
        
        NSString * string = [NSString stringWithFormat:@"%@,%@",_topicTitle,_string];
        
        [ShareSDK shareContent:[ShareSDK content:string defaultContent:@"游谱特惠" image:nil title:_topicTitle url:_string description:nil mediaType:SSPublishContentMediaTypeNews] type:ShareTypeSinaWeibo authOptions:authOptions shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享成功" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
                
            }else if (state == SSPublishContentStateFail){
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享失败" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }
            
        }];
        
    }];
    
    //QQ好友分享
    id<ISSShareActionSheetItem> QQ = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQ] icon:[ShareSDK getClientIconWithType:ShareTypeQQ] clickHandler:^{
        
        [ShareSDK shareContent:[ShareSDK content:nil defaultContent:@"" image:topicImage title:_topicTitle url:_string description:@"" mediaType:SSPublishContentMediaTypeNews] type:ShareTypeQQ authOptions:authOptions statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享成功" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }else if (state == SSPublishContentStateFail){
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享失败" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }
        }];
    }];
    
    //微信朋友圈分享
    id<ISSShareActionSheetItem> weixin = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline] icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline] clickHandler:^{
        
        
        [ShareSDK shareContent:[ShareSDK content:nil defaultContent:@"" image:topicImage title:_topicTitle url:_string description:@"" mediaType:SSPublishContentMediaTypeApp] type:ShareTypeWeixiTimeline authOptions:authOptions statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享成功" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }else if (state == SSPublishContentStateFail){
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享失败" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }
        }];
    }];
    
    //微信好友分享
    id<ISSShareActionSheetItem> WXfriend = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession] icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession] clickHandler:^{
        
        [ShareSDK shareContent:[ShareSDK content:nil defaultContent:nil image:topicImage title:_topicTitle url:_string description:@"" mediaType:SSPublishContentMediaTypeNews] type:ShareTypeWeixiSession authOptions:authOptions statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
            if (state == SSPublishContentStateSuccess) {
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享成功" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }else if (state == SSPublishContentStateFail){
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享失败" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }
        }];
    }];
    //创建自定义分享列表
    NSArray * array = [ShareSDK customShareListWithType:WXfriend,weixin,sina,QQ,qqZone, nil];
    
    [ShareSDK showShareActionSheet:nil shareList:array content:publishContent statusBarTips:NO authOptions:authOptions shareOptions:[ShareSDK  defaultShareOptionsWithTitle:nil oneKeyShareList:[NSArray defaultOneKeyShareList] cameraButtonHidden:NO mentionButtonHidden:NO topicButtonHidden:NO qqButtonHidden:NO wxSessionButtonHidden:NO wxTimelineButtonHidden:NO showKeyboardOnAppear:NO shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil] result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
        
        if (state == SSPublishContentStateSuccess) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享成功" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }else if (state == SSPublishContentStateFail){
            
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"分享失败" delegate:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
        }
    }];

    
}

//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}

-(void)webview{
    
    [self addIndicator];
    
    UIWebView * web  =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    web.autoresizesSubviews = YES;//自动调整大小
    web.scalesPageToFit =YES;//自动对页面进行缩放以适应屏幕
    web.delegate = self;
    web.scrollView.delegate = self;
    

    NSURL * url  =[NSURL URLWithString:self.string];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *detailPrefix = @"http://tehui.youpu.cn/line/";
    NSString *requestURL = request.URL.absoluteString;
    if ([requestURL hasPrefix:detailPrefix] && [requestURL hasSuffix:@"/"]) {
        NSString *lineId = [requestURL stringByReplacingOccurrencesOfString:detailPrefix withString:@""];
        lineId = [lineId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        DetailViewController * detail = [[DetailViewController alloc] init];
        detail.lineNumber = lineId;
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:detail];
        [self presentViewController:navi animated:NO completion:nil];
        return NO;
    }
    
    return YES;
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
