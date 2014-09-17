//
//  SinaEmailViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-31.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "SinaEmailViewController.h"

@interface SinaEmailViewController ()
{
     UIActivityIndicatorView * _indicator;//菊花
}

@end

@implementation SinaEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self navi];
    [self createAll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)navi{
    
    self.title = @"邮箱验证";
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
}

-(void)backActon{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"credential"];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}


#pragma mark
#pragma mark  ---------------文本
-(void)createAll{
    
    [login removeFromSuperview];
    UILabel * upLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-20, 20)];
    [upLable setText:@"登录后我们会推荐匹配度更高的行程"];
    [upLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [upLable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:upLable];
    
    UILabel * zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(30, 26, 50, 30)];
    [zhanghao setText:@"邮箱"];
    [zhanghao setFont:[UIFont systemFontOfSize:17]];
    [zhanghao setTextColor:[UIColor blackColor]];
    [self.view addSubview:zhanghao];
    
    zhText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 56, self.view.frame.size.width-40, 40)];
    [zhText setPlaceholder:@"填写邮箱"];
    zhText.layer.borderWidth = 0.5;
    zhText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    zhText.layer.cornerRadius = 5;
    zhText.layer.masksToBounds = YES;
    [zhText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    [self.view addSubview:zhText];
    
    yanzheng = [[UIButton alloc] initWithFrame:CGRectMake(20, 116, self.view.frame.size.width-40, 40)];
    [yanzheng setTitle:@"验证" forState:UIControlStateNormal];
    [yanzheng setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
    [yanzheng setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanzheng addTarget:self action:@selector(signEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yanzheng];
}
-(void)mimaTextField{
    
    [yanzheng removeFromSuperview];
    
    UILabel * mima = [[UILabel alloc] initWithFrame:CGRectMake(30, 106, 50, 30)];
    [mima setText:@"密码"];
    [mima setTextColor:[UIColor blackColor]];
    [mima setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:mima];
    
    mmText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 136, self.view.frame.size.width-40, 40)];
    [mmText setPlaceholder:@"填写密码"];
    mmText.layer.borderWidth = 0.5;
    mmText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    mmText.layer.cornerRadius = 5;
    mmText.layer.masksToBounds = YES;
    [mmText setSecureTextEntry:YES];
    [mmText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    [self.view addSubview:mmText];
    login = [[UIButton alloc] initWithFrame:CGRectMake(20, 196, self.view.frame.size.width-40, 40)];
    [login setTitle:@"登陆" forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginHaha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
}

-(void)loginHaha{
    
    if ([mmText.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
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
    NSString *phoneType = @"ios";
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
    NSLog(@"%@",dic);
    if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入密码有误,请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        mmText.text =@"";
    }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"])
    {
        [zhText resignFirstResponder];
        [mmText resignFirstResponder];
        [self addIndicator];
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        if ([_nickName isEqualToString:@""]) {
            _nickName = @"0";
        }if ([_userIcon isEqualToString:@""]) {
            _userIcon = @"0";
        }
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * email = zhText.text;
        NSString * unionType = @"sina";
        NSString * unionUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"credential"];
        NSString * nickname = _nickName;
        NSString * gender = _gender;
        NSString * userIcon = _userIcon;
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",email,gender,nickname,timeString,unionType,unionUserId,userIcon,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        NSString *  strings = [_nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *outputStr = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)_userIcon,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
        NSString * stringss = outputStr;
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        email =[NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
        unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
        unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
        nickname = [NSString stringWithFormat:@"%@=%@%@",@"nickName",strings,@"&"];
        gender = [NSString stringWithFormat:@"%@=%@%@",@"gender",gender,@"&"];
        userIcon = [NSString stringWithFormat:@"%@=%@%@",@"userIcon",stringss,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",kBindQQAndSinaUrl,time,email,unionType,unionUserId,userIcon,nickname,gender];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        NSLog(@"%@",finally);
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKeyedSubscript:@"code"]stringValue]isEqualToString:@"0"]) {
                
                [zhText resignFirstResponder];
                [mmText resignFirstResponder];
                [self addIndicator];
                [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:YES completion:nil];
                [_indicator stopAnimating];
                [_indicator removeFromSuperview];
            }
        }];
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

-(void)signEmail{
    
    NSRange range = [zhText.text rangeOfString:@"@"];
    if ([zhText.text isEqualToString:@""] || range.length==0 ||range.length>1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"￼请输入邮箱" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * email = zhText.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",email,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    email =[NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",kEmailExistUrl,time,email];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    
    if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
        
        [zhText resignFirstResponder];
        [self addIndicator];
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        if ([_nickName isEqualToString:@""]) {
            _nickName =@"0";
        }if ([_userIcon isEqualToString:@""]) {
            _userIcon = @"0";
        }
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * email = zhText.text;
        NSString * unionType = @"sina";
        NSString * unionUserId =[[NSUserDefaults standardUserDefaults] objectForKey:@"credential"];
        NSString * nickName = _nickName;
        NSString * gender = _gender;
        NSString * userIcon = _userIcon;
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",email,gender,nickName,timeString,unionType,unionUserId,userIcon,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        NSString *  strings = [_nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *outputStr = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)_userIcon,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
        NSString * stringss = outputStr;
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        email =[NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
        unionType = [NSString stringWithFormat:@"%@=%@%@",@"unionType",unionType,@"&"];
        unionUserId = [NSString stringWithFormat:@"%@=%@%@",@"unionUserId",unionUserId,@"&"];
        nickName = [NSString stringWithFormat:@"%@=%@%@",@"nickName",strings,@"&"];
        gender = [NSString stringWithFormat:@"%@=%@%@",@"gender",gender,@"&"];
        userIcon = [NSString stringWithFormat:@"%@=%@%@",@"userIcon",stringss,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",kBindQQAndSinaUrl,time,email,unionType,unionUserId,userIcon,nickName,gender];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        NSLog(@"%@",finally);
        
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"]stringValue]isEqualToString:@"0"]) {
            
            [self addIndicator];
            
            [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tab.selectedIndex = 0;
            [self dismissViewControllerAnimated:YES completion:nil];
            [_indicator stopAnimating];
            [_indicator removeFromSuperview];
        }
    }];
        
    }
    else
    {
        [self mimaTextField];
    }
    
}];
    
}
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
