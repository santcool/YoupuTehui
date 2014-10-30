//
//  ValidateViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-26.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "ValidateViewController.h"
#import "IndividualViewController.h"

@interface ValidateViewController ()

@end

@implementation ValidateViewController

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
    self.title = @"验证手机号";
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [_field resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAction{
    
    if ([_field.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入验证码" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }else{
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * mobile = _phoneMobile;
    NSString * code = _field.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",code,mobile,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    mobile = [NSString stringWithFormat:@"%@=%@%@",@"mobile",mobile,@"&"];
    code = [NSString stringWithFormat:@"%@=%@%@",@"code",code,@"&"];
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kValidateUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",url,time,mobile,code];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"4"]) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"手机号已经存在" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"3"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"验证码错误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"系统错误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            
        }else{
            
            //获取当前时间戳
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.f", a];
            
            //加密规则
            NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
            NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
            NSString * type = @"mobile";
            NSString * value = _phoneMobile;
            NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,timeString,type,value,key];
            NSString * qzy = [TeHuiModel md5:QZY];
            NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
            NSString * qaz = [TeHuiModel md5:qwe];
            
            //接口拼接
            NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
            memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
            type = [NSString stringWithFormat:@"%@=%@%@",@"type",type,@"&"];
            value = [NSString stringWithFormat:@"%@=%@%@",@"value",value,@"&"];
            NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kReviseUrl];
            NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,type,value,memberId];
            
            NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
            NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
            
            [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
                    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"保存成功" delegate:self cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                    [sheet showInView:self.view];
                }
                
            }];
        }
        
    }];
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObject:_phoneMobile forKey:@"dianhua"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"qwer" object:nil userInfo:dic];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

-(void)createTextField{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lable setText:@"  请输入您收到的验证码"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
    [self.view addSubview:lable];
    
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 50)];
    [_field setBorderStyle:UITextBorderStyleRoundedRect];
    [_field setFont:[UIFont systemFontOfSize:14]];
    [_field setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:_field];
    
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
