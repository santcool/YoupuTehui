//
//  GuanyuViewController.m
//  游谱旅行
//
//  Created by youpu on 14-9-2.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "GuanyuViewController.h"

@interface GuanyuViewController ()

@end

@implementation GuanyuViewController

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
    
    [self bigView];
    
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
    
}

-(void)backActon
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)bigView{

    UIWebView * web  =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [web scalesPageToFit];
    [web setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    web.delegate = self;
    web.scrollView.delegate = self;
    
    NSURL * url  =[NSURL URLWithString:@"http://tehui.youpu.cn/topic/201408/2014082600047.html"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    
    
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
