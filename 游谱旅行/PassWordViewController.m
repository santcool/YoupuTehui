//
//  PassWordViewController.m
//  游谱旅行
//
//  Created by youpu on 14-9-2.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
}

@end

@implementation PassWordViewController

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
    [self createAll];
    
}

-(void)qzy
{
    self.title = self.titleName;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.06]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}
-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
-(void)saveAction{
    
    if ([zhText.text isEqualToString:@""] && [mmText.text isEqualToString:@""] && [xinmimaText.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"游谱提示您" message:@"请输入您的原密码和新密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    else if ([zhText.text isEqualToString:@""] || [mmText.text isEqualToString:@""] || [xinmimaText.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"游谱提示您" message:@"请输入原密码或新密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * oldPass = zhText.text;
    NSString * newPass = mmText.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,newPass,oldPass,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    oldPass = [NSString stringWithFormat:@"%@=%@%@",@"oldPass",oldPass,@"&"];
    newPass = [NSString stringWithFormat:@"%@=%@%@",@"newPass",newPass,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",kReSetPassUrl,time,oldPass,newPass,memberId];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"游谱提示您" message:@"密码修改成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
 
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"游谱提示您" message:@"您输入的原密码错误"   delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [zhText setText:@""];
            [mmText setText:@""];
            [xinmimaText setText:@""];
            
        }
        
    }];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark
#pragma mark -ui展示
-(void)createAll{
    
    UILabel * zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, 30)];
    [zhanghao setText:@"原密码"];
    [zhanghao setFont:[UIFont systemFontOfSize:16]];
    [zhanghao setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.8]];
    [self.view addSubview:zhanghao];
    
    zhText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 35, self.view.frame.size.width-40, 40)];
    zhText.layer.borderWidth = 0.5;
    zhText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    zhText.layer.cornerRadius = 5;
    zhText.layer.masksToBounds = YES;
    [zhText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    zhText.delegate = self;
    [self.view addSubview:zhText];
    
    UILabel * mima = [[UILabel alloc] initWithFrame:CGRectMake(25, 80, 50, 30)];
    [mima setText:@"新密码"];
    [mima setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.8]];
    [mima setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:mima];
    
    mmText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 115, self.view.frame.size.width-40, 40)];
    mmText.layer.borderWidth = 0.5;
    mmText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    mmText.layer.cornerRadius = 5;
    mmText.layer.masksToBounds = YES;
    [mmText setSecureTextEntry:YES];
    [mmText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    mmText.delegate = self;
    [self.view addSubview:mmText];
    
    UILabel * xinmima = [[UILabel alloc] initWithFrame:CGRectMake(25, 160, 150, 30)];
    [xinmima setText:@"再次输入新密码"];
    [xinmima setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.8]];
    [xinmima setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:xinmima];
    
    xinmimaText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 195, self.view.frame.size.width-40, 40)];
    xinmimaText.layer.borderWidth = 0.5;
    xinmimaText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    xinmimaText.layer.cornerRadius = 5;
    xinmimaText.layer.masksToBounds = YES;
    [xinmimaText setSecureTextEntry:YES];
    [xinmimaText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    xinmimaText.delegate = self;
    [self.view addSubview:xinmimaText];
    
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
