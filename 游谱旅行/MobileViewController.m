//
//  MobileViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-26.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MobileViewController.h"
#import "ValidateViewController.h"

@interface MobileViewController ()

@end

@implementation MobileViewController

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
    
    [self createTextField];

}

-(void)qzy
{
    self.title = self.phoneNumber;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.06]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"验证" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    if ([_field.text isEqualToString:@""]) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if (_field.text.length<11){
        
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号位数" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
     else{
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * mobile = self.field.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",mobile,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    mobile = [NSString stringWithFormat:@"%@=%@%@",@"mobile",mobile,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",kForgetUrl,time,mobile];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"4"]) {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"号码已存在" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]){
            
            UIAlertView * qwe =[[UIAlertView alloc]initWithTitle:@"提示" message:@"到达每日发送上限,请24小时后再尝试此操作" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [qwe show];
            
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"系统错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
        
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜您,手机号尚未被使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
  
        }
        
     }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ValidateViewController * vvv = [[ValidateViewController alloc] init];
    vvv.phoneMobile = _field.text;
    [self.navigationController pushViewController:vvv animated:NO];
    
}

-(void)createTextField{
    
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [_field setBorderStyle:UITextBorderStyleRoundedRect];
    [_field setFont:[UIFont systemFontOfSize:14]];
    _field.delegate = self;
    [_field setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [_field setText:_nowNumber];
    [self.view addSubview:_field];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.field == textField)
    {
        if ([aString length] >11) {
            textField.text = [aString substringToIndex:11];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"超过号码最大位数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
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
