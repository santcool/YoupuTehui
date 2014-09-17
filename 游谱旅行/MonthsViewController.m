//
//  MonthsViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MonthsViewController.h"

@interface MonthsViewController ()

@end

@implementation MonthsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.timeDic = [[NSMutableDictionary alloc] init];
        
        self.exit = NO;
        _i = 0;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.05]];
    
    [self createLable];
    
    [self createTextField];
    
    
}



-(void)setNavigationBar{
    
    self.title = @"出行时间";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
}

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)createLable{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lable setText:@"    选择您出发的时间"];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [lable setFont:[UIFont systemFontOfSize:12]];
    
    CALayer *lay =[CALayer layer];
    lay.frame = CGRectMake(0, 40, lable.frame.size.width, 1);
    lay.backgroundColor =[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor;
    [lable.layer addSublayer:lay];
    
    [self.view addSubview:lable];
    
}

-(void)createTextField{
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-264, self.view.frame.size.width, 150)];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
    [_datePicker setHidden:YES];
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    
    NSDate *selected = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    UILabel * bigLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.view.frame.size.width, 40)];
    [bigLable setUserInteractionEnabled:YES];
    CALayer * upLay = [CALayer layer];
    upLay.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    upLay.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
    [bigLable.layer addSublayer:upLay];
    CALayer * downLay = [CALayer layer];
    downLay.frame = CGRectMake(0, 40, self.view.frame.size.width, 1);
    downLay.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
    [bigLable.layer addSublayer:downLay];
    [self.view addSubview:bigLable];
    
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 140, 40)];
    [_field setPlaceholder:@"选择出发时间"];
    [_field setBackgroundColor:[UIColor clearColor]];
    [_field setFont:[UIFont systemFontOfSize:14]];
    _field.delegate = self;
    [_field setTextAlignment:NSTextAlignmentCenter];
    [_field setText:destDateString];
    [bigLable addSubview:_field];
    
    UILabel *Lable = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 20, 20)];
    [Lable setText:@"至"];
    [Lable setTextColor:[UIColor blackColor]];
    [Lable setFont:[UIFont systemFontOfSize:18]];
    [bigLable addSubview:Lable];
    
    self.fields = [[UITextField alloc] initWithFrame:CGRectMake(175, 0, 140, 40)];
    [_fields setPlaceholder:@"选择结束时间"];
    [_fields setBackgroundColor:[UIColor clearColor]];
    [_fields setFont:[UIFont systemFontOfSize:14]];
    _fields.delegate = self;
    [_fields setTextAlignment:NSTextAlignmentCenter];
    [_fields setText:destDateString];
    [bigLable addSubview:_fields];
    
    timeButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 106, self.view.frame.size.width/2-10, 40)];
    timeButton.layer.borderWidth =1;
    timeButton.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    timeButton.layer.cornerRadius = 10;
    timeButton.layer.masksToBounds = YES;
    [timeButton setTitle:@"不限时间" forState:UIControlStateNormal];
    [timeButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [timeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [timeButton addTarget:self action:@selector(whatever) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 106,self.view.frame.size.width/2-10 , 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"橙条"] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(chuanzhi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    finishButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-292, 100, 30)];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setHidden:YES];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField==self.field) {
        
        _datePicker.tag = 0;
        [_datePicker setHidden:NO];
        [finishButton setHidden:NO];
    }else{
        
        _datePicker.tag = 1;
        [_datePicker setHidden:NO];
        [finishButton setHidden:NO];
    }
    
    
    return NO;
}

#pragma mark
#pragma mark - datepicker改变值

-(void)timeChanged:(id)sender
{
    if ([sender isKindOfClass:[UIDatePicker class]]) {
        NSInteger tag = [(UIDatePicker *)sender tag];
        
        UITextField *currentField = tag == 0 ? self.field : self.fields;
        // 获取用户通过UIDatePicker设置的日期和时间a
        NSDate *selected = [_datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 为日期格式器设置格式字符串
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        // 使用日期格式器格式化日期、时间
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        [currentField setText:destDateString];
    }
}

#pragma mark
#pragma mark - 完成事件
-(void)clearAll{
    
    [_datePicker setHidden:YES];
    [finishButton setHidden:YES];
}

#pragma mark
#pragma mark -协议传值
-(void)whatever{
    
    [self.delegate whatever:timeButton.titleLabel.text exit:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)chuanzhi{
    
    [self.delegate time:self.field.text arrive:self.fields.text exit:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
