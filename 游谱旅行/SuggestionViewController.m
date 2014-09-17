//
//  SuggestionViewController.m
//  游谱旅行
//
//  Created by youpu on 14-9-2.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
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
    
    NSRange range = [_emailField.text rangeOfString:@"@"];
    if (range.location == NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱格式" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if ([_emailField.text isEqualToString:@""] || [_field.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱或者您的意见" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else{
        
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";

    NSString * email = _emailField.text;
    NSString * value = _field.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",email,timeString,value,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    NSString * strings = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    email = [NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
    value = [NSString stringWithFormat:@"%@=%@%@",@"value",strings,@"&"];
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@%@%@",kFeedBackUrl,value,email,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"] stringValue ]isEqualToString:@"0"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见提交成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
      [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)createTextField{
    
    UILabel * lable  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lable setText:@" 请留下您宝贵的意见"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:lable];
    
    self.field = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 120)];
    [_field setFont:[UIFont systemFontOfSize:12]];
    _field.layer.borderWidth = 1;
    _field.layer.borderColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    [_field setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    _field.delegate = self;
    [self.view addSubview:_field];
    
    UILabel * qing = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 40)];
    [qing setText:@" 请输入您的邮箱"];
    [qing setFont:[UIFont systemFontOfSize:14]];
    [qing setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:qing];
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    [_emailField setFont:[UIFont systemFontOfSize:12]];
    [_emailField setBackgroundColor:[UIColor whiteColor]];
    _emailField.layer.borderWidth = 1;
    _emailField.layer.borderColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    [_emailField setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:_emailField];
    
    CALayer * lableLay = [CALayer layer];
    lableLay.frame = CGRectMake(0, 269, self.view.frame.size.width, 1);
    lableLay.backgroundColor =[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    [_emailField.layer addSublayer:lableLay];
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
