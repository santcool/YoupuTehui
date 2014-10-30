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
    MBProgressHUD * _progressHUD;
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
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassWord)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

-(void)forgetPassWord{
    
    
    NSRange range = [_field.text rangeOfString:@"@"];
    
    if ([_field.text isEqualToString:@""] || range.length==0 || range.length >1) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入正确的邮箱" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
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
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    email = [NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kForgetPassEmail];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,email];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
            [_progressHUD hide:YES];
            [_progressHUD removeFromSuperViewOnHide];

            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"重置密码成功,新密码已经发送到您的邮箱" delegate:self cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"系统错误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }
    }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_field resignFirstResponder];
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
