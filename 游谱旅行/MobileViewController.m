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
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"验证" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [_field resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)saveAction{
    
    if ([_field.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入手机号" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }else if (_field.text.length<11){
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入正确的手机号位数" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
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
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    mobile = [NSString stringWithFormat:@"%@=%@%@",@"mobile",mobile,@"&"];
         NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kForgetUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,mobile];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"4"]) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"号码已存在" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"到达每日发送上限,请24小时后再尝试此操作" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"系统错误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }else{
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"恭喜您,手机号尚未被使用" delegate:self cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
  
        }
        
     }];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    ValidateViewController * vvv = [[ValidateViewController alloc] init];
    vvv.phoneMobile = _field.text;
    [self.navigationController pushViewController:vvv animated:NO];
    
}

-(void)createTextField{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:lable];
    
    self.field = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    [_field setFont:[UIFont systemFontOfSize:14]];
    _field.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    _field.layer.borderWidth = 0.5;
    _field.delegate = self;
    [_field setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [_field setBackgroundColor:[UIColor whiteColor]];
    [_field setText:_nowNumber];
    [self.view addSubview:_field];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.field == textField)
    {
        if ([aString length] >11) {
            textField.text = [aString substringToIndex:11];
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"超过号码最大位数" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
            return NO;
        }
    }
    return YES;
    
    
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
