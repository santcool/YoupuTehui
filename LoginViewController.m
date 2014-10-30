//
//  LoginViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-13.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "EmailViewController.h"
#import "SinaEmailViewController.h"
#import "WeiXinViewController.h"

#import "MiPushSDK.h"

#import <ShareSDK/ISSPlatformUser.h>

@interface LoginViewController ()
{
     TencentOAuth * _tencentOAuth;
    NSArray *   _permissions;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWeiXinMessage:) name:@"weixin" object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navi];
    
    [self createAll];
    
    [self qqAndSina];
    
    
}

-(void)navi{
    
    self.title = @"登录游谱账号";
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(returnToLast)];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ((appDelegate.tab.selectedIndex==1 || appDelegate.tab.selectedIndex==2) && (appDelegate.tab.isOrNo==1 || appDelegate.tab.isOrNo==0)) {
        
        appDelegate.tab.selectedIndex = 0;
    }if ((appDelegate.tab.selectedIndex==1 || appDelegate.tab.selectedIndex==2) && appDelegate.tab.isOrNo==3) {
        appDelegate.tab.selectedIndex = 3;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)returnToLast{
    
    SignUpViewController * sing = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:sing animated:NO];
    
}

#pragma mark
#pragma mark -ui展示
-(void)createAll{
    
    UILabel * upLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-20, 20)];
    [upLable setText:@"登录后我们会推荐匹配度更高的行程"];
    [upLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [upLable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:upLable];
    
    UILabel * zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(30, 26, 50, 30)];
    [zhanghao setText:@"账号"];
    [zhanghao setFont:[UIFont systemFontOfSize:17]];
    [zhanghao setTextColor:[UIColor blackColor]];
    [self.view addSubview:zhanghao];
    
    UILabel * kind = [[UILabel alloc] initWithFrame:CGRectMake(65, 32, 150, 20)];
    [kind setText:@"手机号、邮箱"];
    [kind setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [kind setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:kind];
    
    zhText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 56, self.view.frame.size.width-40, 40)];
    [zhText setPlaceholder:@"填写账号"];
    zhText.layer.borderWidth = 0.5;
    zhText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    zhText.layer.cornerRadius = 5;
    zhText.layer.masksToBounds = YES;
    [zhText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    zhText.delegate = self;
    [self.view addSubview:zhText];
    
    UILabel * mima = [[UILabel alloc] initWithFrame:CGRectMake(30, 106, 50, 30)];
    [mima setText:@"密码"];
    [mima setTextColor:[UIColor blackColor]];
    [mima setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:mima];
    
    UIButton * wangji = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130, 106, 100, 30)];
    [wangji setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [wangji.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [wangji setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [wangji addTarget:self action:@selector(forgetMima) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wangji];
    
    mmText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 136, self.view.frame.size.width-40, 40)];
    [mmText setPlaceholder:@"填写密码"];
    mmText.layer.borderWidth = 0.5;
    mmText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    mmText.layer.cornerRadius = 5;
    mmText.layer.masksToBounds = YES;
    [mmText setSecureTextEntry:YES];
    [mmText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    mmText.delegate = self;
    [self.view addSubview:mmText];
    
    UIButton * login = [[UIButton alloc] initWithFrame:CGRectMake(20, 196, self.view.frame.size.width-40, 40)];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
}

-(void)forgetMima{
    
    ForgetPassViewController * forget = [[ForgetPassViewController alloc] init];
    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:forget];
    [self presentViewController:na animated:NO completion:nil];
    
}

#pragma mark
#pragma mark -----------------用户登陆
-(void)login{
    
    if ([zhText.text isEqualToString:@""] && [mmText.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入账号和密码" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }else if ([zhText.text isEqualToString:@""] || [mmText.text isEqualToString:@""]){
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入账号或密码" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }else{
    
        if([zhText.text rangeOfString:@" "].location !=NSNotFound){
            zhText.text = [zhText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    SingleClass * single = [SingleClass singleClass];
    single.userName = zhText.text;
    single.passWord = mmText.text;
 
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * username = single.userName;
    NSString * password = single.passWord;
    NSString * phoneType = @"ios";
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",password,phoneType,timeString,username,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    username = [NSString stringWithFormat:@"%@=%@%@",@"username",username,@"&"];
    password = [NSString stringWithFormat:@"%@=%@%@",@"password",password,@"&"];
    phoneType = [NSString stringWithFormat:@"%@=%@%@",@"phoneType",phoneType,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kLoginUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,username,password,phoneType];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"您输入的账号格式有误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"您输入的账号或密码错误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }else{
            
            NSDictionary * memberDic = [dic objectForKey:@"data"];
            NSString * member = [memberDic objectForKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults]setObject:member forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[EaseMob sharedInstance].chatManager registerNewAccount:member password:@"111111" error:nil];
            [[EaseMob sharedInstance].chatManager loginWithUsername:member password:@"111111" error:nil];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
 
            [self dismissViewControllerAnimated:NO completion:nil];
            
        }
    }];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark -联合登陆
-(void)qqAndSina{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 256,100, 30)];
    [lable setText:@"其他方式登录"];
    [lable setTextColor:[UIColor blackColor]];
    [lable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:lable];
    
    UIButton * buttons = [[UIButton alloc]initWithFrame:CGRectMake(10, 296, 80, 120)];
    [buttons addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttons];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(26, 0, 30, 30)];
    [button setUserInteractionEnabled:YES];
    [button addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"qqicon"] forState:UIControlStateNormal];
    [buttons addSubview:button];
    
    UILabel * qqLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 39, 50, 20)];
    [qqLable setText:@"QQ"];
    [qqLable setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
    [qqLable setFont:[UIFont systemFontOfSize:14]];
    [buttons addSubview:qqLable];
    
    UIButton * buttonss = [[UIButton alloc]initWithFrame:CGRectMake(230, 296, 50, 80)];
    [buttonss addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonss];
    
    UIButton * sinaButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 30, 30)];
    [sinaButton setUserInteractionEnabled:YES];
    [sinaButton addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [sinaButton setImage:[UIImage imageNamed:@"新浪微博icon"] forState:UIControlStateNormal];

    [buttonss addSubview:sinaButton];
    
    UILabel *sinaLable =[[UILabel alloc] initWithFrame:CGRectMake(13, 39, 80, 20)];
    [sinaLable setText:@"新浪微博"];
    [sinaLable setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
    [sinaLable setFont:[UIFont systemFontOfSize:14]];
    [buttonss addSubview:sinaLable];
    
    UIButton * weixin = [[UIButton alloc]initWithFrame:CGRectMake(120, 296, 50, 80)];
    [buttonss addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixin];
    
    UIButton * weixinImage = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 30, 30)];
    [weixinImage setUserInteractionEnabled:YES];
    [weixinImage addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [weixinImage setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
    
    [weixin addSubview:weixinImage];
    
    UILabel *weixinText =[[UILabel alloc] initWithFrame:CGRectMake(28, 39, 80, 20)];
    [weixinText setText:@"微信"];
    [weixinText setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
    [weixinText setFont:[UIFont systemFontOfSize:14]];
    [weixin addSubview:weixinText];
    
}

#pragma mark
#pragma mark ----------------qq联合登陆
-(void)QQLogin
{
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"101118214" andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];
    
}
#pragma mark
#pragma mark ---------------登陆成功回调方法
-(void)tencentDidLogin{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];

    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * unionType = @"qq";
    NSString * unionUserId = [_tencentOAuth openId];
    NSString * from = @"iosApp";
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",from,timeString,unionType,unionUserId,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];

    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
    unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
    from = [NSString stringWithFormat:@"%@=%@%@",@"from",from,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kQQLoginUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,unionType,unionUserId,from];

    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];

    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"data"] objectForKey:@"email"]isEqualToString:@""]) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[_tencentOAuth openId] forKey:@"credential"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            EmailViewController * sign = [[EmailViewController alloc]init];
            sign.nickName = [[dic objectForKey:@"data"] objectForKey:@"nickName"];
            sign.gender = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"] objectForKey:@"gender"]];
            sign.userIcon = [[dic objectForKey:@"data"] objectForKey:@"picPath"];
            [self.navigationController pushViewController:sign animated:NO];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[EaseMob sharedInstance].chatManager registerNewAccount:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
            [[EaseMob sharedInstance].chatManager loginWithUsername:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }

    }];

}
-(void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"notLogin");
    
}
-(void)tencentDidNotNetWork{
   
}

-(void)tencentDidLogout{
    
}
#pragma mark
#pragma mark -----------------------微信登陆(构造SendAuthReq结构体,向微信终端发送这个结构体)
-(void)weixinLogin{
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"741" ;
    [WXApi sendReq:req];
}

#pragma mark 
#pragma mark -----------------------通过(WXApiDelegate协议方法)成功获取code后回传,进而获取用户唯一标识.
-(void)getWeiXinMessage:(NSNotification *)noti{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx794b9db8253ca0a1",@"6ad5ceda00de0bc44cecdeca959e9b42",[[noti userInfo] objectForKey:@"codeQ"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.openId = [dic objectForKey:@"openid"];
                self.token = [dic objectForKey:@"access_token"];
                NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.token,self.openId];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            
                            self.nickName = [dic objectForKey:@"nickname"];
                            self.myImage = [dic objectForKey:@"headimgurl"];
                            
                            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                            NSTimeInterval a=[dat timeIntervalSince1970];
                            NSString *timeString = [NSString stringWithFormat:@"%.f", a];
                            
                            //加密规则
                            NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
                            NSString * unionType = @"weixin";
                            NSString * unionUserId = _openId;
                            NSString * from = @"iosApp";
                            NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",from,timeString,unionType,unionUserId,key];
                            NSString * qzy = [TeHuiModel md5:QZY];
                            NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
                            NSString * qaz = [TeHuiModel md5:qwe];
                            
                            //接口拼接
                            NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
                            unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
                            unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
                            from = [NSString stringWithFormat:@"%@=%@%@",@"from",from,@"&"];
                            NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kQQLoginUrl];
                            NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,unionType,unionUserId,from];
                            
                            NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
                            NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
                            
                            [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
                                
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                                if ([[[dic objectForKey:@"data"] objectForKey:@"email"]isEqualToString:@""]) {
                                    
                                    [[NSUserDefaults standardUserDefaults]setObject:_openId forKey:@"credential"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    
                                    WeiXinViewController * sign = [[WeiXinViewController alloc]init];
                                    sign.nickName =_nickName;
                                    sign.gender = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"] objectForKey:@"gender"]];
                                    sign.userIcon =_myImage;
                                    [self.navigationController pushViewController:sign animated:NO];
                                    
                                }else{
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    [[EaseMob sharedInstance].chatManager registerNewAccount:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
                                    [[EaseMob sharedInstance].chatManager loginWithUsername:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
                                    
                                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                    appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    
                                }
                                
                            }];
                        }
                    });
                    
                });
            }
        });
    });
}

#pragma mark
#pragma mark ----------------新浪联合登陆
-(void)sinaLogin{
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
    if (result) {
        
     id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
      
        [[NSUserDefaults standardUserDefaults] setObject:[credential uid] forKey:@"credential"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * unionType = @"sina";
        NSString * unionUserId = [credential uid];
        NSString * from = @"iosApp";
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",from,timeString,unionType,unionUserId,key];
        NSString * qzy = [TeHuiModel md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [TeHuiModel md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
        unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
        from = [NSString stringWithFormat:@"%@=%@%@",@"from",from,@"&"];
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kQQLoginUrl];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,unionType,unionUserId,from];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKey:@"data"]objectForKey:@"email"]isEqualToString:@""]) {
                
                SinaEmailViewController * sign = [[SinaEmailViewController alloc]init];
                sign.nickName = [userInfo nickname];
                sign.gender = [NSString stringWithFormat:@"%d",[userInfo gender]];
                sign.userIcon = [userInfo profileImage];
                sign.memberId = [[dic objectForKey:@"data"]objectForKey:@"memberId"];
                [self.navigationController pushViewController:sign animated:NO];
                
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[EaseMob sharedInstance].chatManager registerNewAccount:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
                [[EaseMob sharedInstance].chatManager loginWithUsername:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else{
        NSLog(@"%@",[error errorDescription]);
    }
}];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [zhText resignFirstResponder];
    [mmText resignFirstResponder];
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
