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
    MBProgressHUD * _progressHUD;
    UILabel * mima;
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
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"credential"];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//添加菊花
-(void)addIndicator
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    [_progressHUD setMode:MBProgressHUDModeIndeterminate];
    [_progressHUD setLabelText:@"加载中..."];
    [_progressHUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}
-(void) myProgressTask{
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress -=0.01f;
        _progressHUD.progress = progress;
        usleep(50000);
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
    zhText.delegate = self;
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
    
     mima = [[UILabel alloc] initWithFrame:CGRectMake(30, 106, 50, 30)];
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
    mmText.delegate = self;
    [mmText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    [self.view addSubview:mmText];
    login = [[UIButton alloc] initWithFrame:CGRectMake(20, 196, self.view.frame.size.width-40, 40)];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginHaha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
}

-(void)loginHaha{
    
    if ([mmText.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入密码" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
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
    if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"输入密码有误,请重新输入" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
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
        NSString * qzy = [TeHuiModel md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [TeHuiModel md5:qwe];
        
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
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kBindQQAndSinaUrl];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",url,time,email,unionType,unionUserId,userIcon,nickname,gender];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKeyedSubscript:@"code"]stringValue]isEqualToString:@"0"]) {
                [zhText resignFirstResponder];
                [mmText resignFirstResponder];
                [self addIndicator];
                [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[EaseMob sharedInstance].chatManager registerNewAccount:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
                [[EaseMob sharedInstance].chatManager loginWithUsername:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
                [self dismissViewControllerAnimated:YES completion:nil];
                [_progressHUD hide:YES];
                [_progressHUD removeFromSuperViewOnHide];
            }
        }];
    }
    }];
    
}

-(void)signEmail{
    
    NSRange range = [zhText.text rangeOfString:@"@"];
    if ([zhText.text isEqualToString:@""] || range.length==0 ||range.length>1) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入邮箱" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }else{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * email = zhText.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",email,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    email =[NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kEmailExistUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,email];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
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
        NSString * qzy = [TeHuiModel md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [TeHuiModel md5:qwe];
        
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
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kBindQQAndSinaUrl];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",url,time,email,unionType,unionUserId,userIcon,nickName,gender];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"]stringValue]isEqualToString:@"0"]) {
            
            [self addIndicator];
            
            [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"]objectForKey:@"memberId"] forKey:@"memberId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[EaseMob sharedInstance].chatManager registerNewAccount:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
            [[EaseMob sharedInstance].chatManager loginWithUsername:[[dic objectForKey:@"data"]objectForKey:@"memberId"] password:@"111111" error:nil];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
            [self dismissViewControllerAnimated:YES completion:nil];
            [_progressHUD hide:YES];
            [_progressHUD removeFromSuperViewOnHide];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==mmText ) {
        
        [self animateTextField: textField up: YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField==mmText) {
        
        [self animateTextField: textField up: NO];
        
    }
    
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
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
