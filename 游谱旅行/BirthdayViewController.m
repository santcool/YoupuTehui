//
//  BirthdayViewController.m
//  游谱旅行
//
//  Created by YueLink on 14-8-17.
//  Copyright (c) 2014年 YueLink. All rights reserved.
//

#import "BirthdayViewController.h"

@interface BirthdayViewController ()

@end

@implementation BirthdayViewController

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
    self.title = self.name;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.06]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)saveAction{
    
    [self connect];
    [self.delegate birth:_field.text];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)createTextField{
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-264, self.view.frame.size.width, 150)];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];

    self.field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [_field setBorderStyle:UITextBorderStyleRoundedRect];
    [_field setBackgroundColor:[UIColor clearColor]];
    [_field setFont:[UIFont systemFontOfSize:14]];
    _field.delegate = self;
    [_field setTextAlignment:NSTextAlignmentCenter];
    [_field setText:_birthday];
    [self.view addSubview:_field];
    
    finishButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-292, 100, 30)];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setHidden:YES];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
}
#pragma mark
#pragma mark - 完成事件
-(void)clearAll{
    
    [_datePicker setHidden:YES];
    [finishButton setHidden:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [_datePicker setHidden:NO];
    [finishButton setHidden:NO];
    return NO;
}

-(void)timeChanged:(id)sender
{
    // 获取用户通过UIDatePicker设置的日期和时间a
    NSDate *selected = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    [_field setText:destDateString];
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
-(void)connect{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * type = @"memberBrithday";
    NSString * value = _field.text;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,timeString,type,value,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    type = [NSString stringWithFormat:@"%@=%@%@",@"type",type,@"&"];
    value = [NSString stringWithFormat:@"%@=%@%@",@"value",value,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kReviseUrl,time,type,value];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
    }];
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
