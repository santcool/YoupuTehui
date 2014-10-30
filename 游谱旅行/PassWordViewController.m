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
    UIButton * finishButton;
    NSInteger _i;
}

@end

@implementation PassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _i=0;
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
    
    [zhText resignFirstResponder];
    [mmText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)saveAction{
    
    if ([zhText.text isEqualToString:@""] && [mmText.text isEqualToString:@""] && [xinmimaText.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入您的原密码和新密码" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    
    else if ([zhText.text isEqualToString:@""] || [mmText.text isEqualToString:@""] || [xinmimaText.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入您的原密码或新密码" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
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
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    oldPass = [NSString stringWithFormat:@"%@=%@%@",@"oldPass",oldPass,@"&"];
    newPass = [NSString stringWithFormat:@"%@=%@%@",@"newPass",newPass,@"&"];
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kReSetPassUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,oldPass,newPass,memberId];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"密码修改成功" delegate:self cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
 
        }else if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"2"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"您输入的原密码错误" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            [zhText setText:@""];
            [mmText setText:@""];
            [xinmimaText setText:@""];
            
        }
        
    }];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark
#pragma mark -ui展示
-(void)createAll{
    
    UILabel * zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, 30)];
    [zhanghao setText:@"原密码"];
    [zhanghao setFont:[UIFont systemFontOfSize:16]];
    [zhanghao setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8]];
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
    [mima setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8]];
    [mima setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:mima];
    
    mmText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 115, self.view.frame.size.width-40, 40)];
    mmText.layer.borderWidth = 0.5;
    mmText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    mmText.layer.cornerRadius = 5;
    mmText.layer.masksToBounds = YES;
    [mmText setSecureTextEntry:YES];
    mmText.delegate = self;
    [mmText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];

    [self.view addSubview:mmText];
    
    UILabel * xinmima = [[UILabel alloc] initWithFrame:CGRectMake(25, 160, 150, 30)];
    [xinmima setText:@"再次输入新密码"];
    [xinmima setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8]];
    [xinmima setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:xinmima];
    
    xinmimaText = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 195, self.view.frame.size.width-40, 40)];
    xinmimaText.layer.borderWidth = 0.5;
    xinmimaText.layer.borderColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5].CGColor;
    xinmimaText.layer.cornerRadius = 5;
    xinmimaText.layer.masksToBounds = YES;
    [xinmimaText setSecureTextEntry:YES];
    xinmimaText.delegate = self;
    [xinmimaText setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.03]];
    [self.view addSubview:xinmimaText];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    if (textField== mmText) {
        
        [self animateTextField: textField up: YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
        
    if (textField==mmText) {
        self.view.frame = CGRectOffset(self.view.frame, 0, 0);
    }
    if (textField==xinmimaText) {
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
    [xinmimaText resignFirstResponder];

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
