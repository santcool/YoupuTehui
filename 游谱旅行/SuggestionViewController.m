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
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}
-(void)backActon{
    
    [_field resignFirstResponder];
    [_emailField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)saveAction{
    
    NSRange range = [_emailField.text rangeOfString:@"@"];
    if (range.location == NSNotFound) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入正确的邮箱格式" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    else if ([_emailField.text isEqualToString:@""] || [_field.text isEqualToString:@""]) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请输入邮箱或者您的意见" delegate:nil cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
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
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    NSString * strings = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    email = [NSString stringWithFormat:@"%@=%@%@",@"email",email,@"&"];
    value = [NSString stringWithFormat:@"%@=%@%@",@"value",strings,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kFeedBackUrl];
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@%@%@",url,value,email,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([[[dic objectForKey:@"code"] stringValue ]isEqualToString:@"0"]) {
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"意见提交成功" delegate:self cancelButtonTitle:@"提示" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }
    }];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
      [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)createTextField{
    
    UILabel * lable  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lable setText:@" 请留下您宝贵的意见"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:lable];
    
    self.field = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 90)];
    [_field setFont:[UIFont systemFontOfSize:12]];
    _field.layer.borderWidth = 0.5;
    _field.layer.borderColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    [_field setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:_field];
    
    UILabel * qing = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 40)];
    [qing setText:@" 请输入您的邮箱"];
    [qing setFont:[UIFont systemFontOfSize:14]];
    [qing setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [self.view addSubview:qing];
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 40)];
    [_emailField setFont:[UIFont systemFontOfSize:12]];
    [_emailField setBackgroundColor:[UIColor whiteColor]];
    _emailField.layer.borderWidth = 0.5;
    _emailField.layer.borderColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    [_emailField setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    _emailField.delegate = self;
    [self.view addSubview:_emailField];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
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
    [_field resignFirstResponder];
    [_emailField resignFirstResponder];
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
