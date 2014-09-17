//
//  LoginViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-13.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "EmailViewController.h"
#import "SinaEmailViewController.h"

#import "MiPushSDK.h"

#import <ShareSDK/ISSPlatformUser.h>

@interface LoginViewController ()
@end

@implementation LoginViewController

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
    [self navi];
    
    [self createAll];
    
    [self qqAndSina];
    
    
}

-(void)navi{
    
    self.title = @"登录游谱账号";
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(returnToLast)];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
}

-(void)backActon{
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)forgetMima{
    
    ForgetPassViewController * forget = [[ForgetPassViewController alloc] init];
    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:forget];
    [self presentViewController:na animated:NO completion:nil];
    
}

#pragma mark
#pragma mark -----------------用户登陆
-(void)login{
    
    if ([zhText.text isEqualToString:@""] && [mmText.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号和密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if ([zhText.text isEqualToString:@""] || [mmText.text isEqualToString:@""]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号或密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
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
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    username = [NSString stringWithFormat:@"%@=%@%@",@"username",username,@"&"];
    password = [NSString stringWithFormat:@"%@=%@%@",@"password",password,@"&"];
    phoneType = [NSString stringWithFormat:@"%@=%@%@",@"phoneType",phoneType,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",kLoginUrl,time,username,password,phoneType];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您输入的账号格式有误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您输入的账号或密码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            
            NSDictionary * memberDic = [dic objectForKey:@"data"];
            NSString * member = [memberDic objectForKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults]setObject:member forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-322,100, 30)];
    [lable setText:@"其他方式登录"];
    [lable setTextColor:[UIColor blackColor]];
    [lable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:lable];
    
    UIButton * buttons = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height-283, 80, 120)];
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
    
    UIButton * buttonss = [[UIButton alloc]initWithFrame:CGRectMake(180, self.view.frame.size.height-283, 50, 80)];
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
    
    
}

#pragma mark
#pragma mark ----------------qq联合登陆
-(void)QQLogin
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
    if (result) {

        id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeQQSpace];

        [[NSUserDefaults standardUserDefaults] setObject:[credential uid] forKey:@"credential"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * unionType = @"qq";
        NSString * unionUserId = [credential uid];
        NSString * from = @"iosApp";
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",from,timeString,unionType,unionUserId,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
        unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
        from = [NSString stringWithFormat:@"%@=%@%@",@"from",from,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",kQQLoginUrl,time,unionType,unionUserId,from];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        NSLog(@"%@",finally);
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        if ([[[dic objectForKey:@"data"] objectForKey:@"email"]isEqualToString:@""]) {
            
            EmailViewController * sign = [[EmailViewController alloc]init];
            sign.nickName = [userInfo nickname];
            sign.gender = [NSString stringWithFormat:@"%d",[userInfo gender]];
            sign.userIcon = [userInfo profileImage];
            UINavigationController * na = [[UINavigationController alloc]initWithRootViewController:sign];
            [self presentViewController:na animated:NO completion:nil];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tab.selectedIndex = 0;
            [self dismissViewControllerAnimated:YES completion:nil];
            
            }
       }];
     }
  }];
    
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
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
        unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
        from = [NSString stringWithFormat:@"%@=%@%@",@"from",from,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",kQQLoginUrl,time,unionType,unionUserId,from];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        NSLog(@"%@",finally);
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKey:@"data"]objectForKey:@"email"]isEqualToString:@""]) {
                
                SinaEmailViewController * sign = [[SinaEmailViewController alloc]init];
                sign.nickName = [userInfo nickname];
                sign.gender = [NSString stringWithFormat:@"%d",[userInfo gender]];
                sign.userIcon = [userInfo profileImage];
                sign.memberId = [[dic objectForKey:@"data"]objectForKey:@"memberId"];
                UINavigationController * na = [[UINavigationController alloc]initWithRootViewController:sign];
                [self presentViewController:na animated:NO completion:nil];
                
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}];

    

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
