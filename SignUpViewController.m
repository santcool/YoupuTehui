//
//  SignUpViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-13.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    
}

-(void)navi{
    
    self.title = @"注册游谱账号";
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(returnToLast)];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}

-(void)returnToLast{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)createAll{
    
    UILabel * upLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-20, 20)];
    [upLable setText:@"登录后我们会推荐匹配度更高的行程"];
    [upLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [upLable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:upLable];
    
    UILabel * zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-542, 100, 30)];
    [zhanghao setText:@"账号"];
    [zhanghao setFont:[UIFont systemFontOfSize:17]];
    [zhanghao setTextColor:[UIColor blackColor]];
    [self.view addSubview:zhanghao];
    
    self.zhText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-512, self.view.frame.size.width-40, 40)];
    [_zhText setPlaceholder:@"填写邮箱"];
    _zhText.layer.borderWidth = 0.5;
    _zhText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    _zhText.layer.cornerRadius = 5;
    _zhText.layer.masksToBounds = YES;
    _zhText.delegate = self;
    [_zhText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    [self.view addSubview:_zhText];
    
    UILabel * mima = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-462, 50, 30)];
    [mima setText:@"密码"];
    [mima setTextColor:[UIColor blackColor]];
    [mima setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:mima];
    
    self.yxText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-432, self.view.frame.size.width-40, 40)];
    [_yxText setPlaceholder:@"6-14位,建议数字、字母、符号组合"];
    _yxText.layer.borderWidth = 0.5;
    _yxText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    _yxText.layer.cornerRadius = 5;
    _yxText.layer.masksToBounds = YES;
    _yxText.delegate = self;
    [_yxText setSecureTextEntry:YES];
    [_yxText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    [self.view addSubview:_yxText];
    
    UIButton * login = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-362, self.view.frame.size.width-40, 40)];
    [login setTitle:@"注册" forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
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


-(void)signUp{
    
    if ([_zhText.text isEqualToString:@""] && [_yxText.text isEqualToString:@""]) {
        
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱和密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }else if ([_zhText.text isEqualToString:@""] || [_yxText.text isEqualToString:@""]){
        
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱或密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        
    }else{
        
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * email = _zhText.text;
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@",email,timeString,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        email = [NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",kEmailExistUrl,time,email];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        NSLog(@"%@",finally);
        
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    if ([[[dic objectForKey:@"code"] stringValue] isEqualToString:@"2"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"邮箱已存在" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        _zhText.text = @"";
        _yxText.text = @"";
        
    }else{
        
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        SingleClass * single = [SingleClass singleClass];
        single.userName = _zhText.text;
        single.passWord = _yxText.text;
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * username = single.userName;
        NSString * password = single.passWord;
        NSString * from = @"iosApp";
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",from,password,timeString,username,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        username = [NSString stringWithFormat:@"%@=%@%@",@"username",username,@"&"];
        password = [NSString stringWithFormat:@"%@=%@%@",@"password",password,@"&"];
        from = [NSString stringWithFormat:@"%@=%@%@",@"from",from,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",kSignUpUrl,time,username,password,from];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        NSLog(@"%@",finally);
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKey:@"code"]stringValue]isEqualToString:@"0"]) {
                UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self    cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alter show];
                NSDictionary * yang = [dic objectForKey:@"data"];
                NSString * member = [yang objectForKey:@"memberId"];
                [[NSUserDefaults standardUserDefaults] setObject:member forKey:@"memberId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
     
   
        }];

        }
    }];
  }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
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