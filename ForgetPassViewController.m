//
//  ForgetPassViewController.m
//  游谱旅行
//
//  Created by 第七章序 on 14-8-16.
//  Copyright (c) 2014年 第七章序. All rights reserved.
//

#import "ForgetPassViewController.h"

@interface ForgetPassViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
}

@end

@implementation ForgetPassViewController

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
    [self qzyy];
    [self createTextField];
    
}

-(void)qzyy{
    
    self.title = @"忘记密码";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassWord)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

-(void)createTextField{
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lable setText:@"  请输入您的邮箱"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:lable];
    
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 50)];
    [_field setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.05]];
    [self.view addSubview:_field];
    
    CALayer *qq = [CALayer layer];
    qq.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    qq.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    [_field.layer addSublayer:qq];
    
    CALayer *downLayer = [CALayer layer];
    downLayer.frame = CGRectMake(0, 49, self.view.frame.size.width, 1);
    downLayer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    [_field.layer addSublayer:downLayer];
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

-(void)forgetPassWord{
    
    
    NSRange range = [_field.text rangeOfString:@"@"];
    
    if ([_field.text isEqualToString:@""] || range.length==0 || range.length >1) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的邮箱" delegate:nil  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
    
    [_field resignFirstResponder];
    [self addIndicator];
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * email = self.field.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",email,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    email = [NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",kForgetPassEmail,time,email];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
            [_indicator stopAnimating];
            [_indicator removeFromSuperview];
           
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重置密码成功,新密码已经发送到您的邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"系统错误" delegate:nil  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
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
