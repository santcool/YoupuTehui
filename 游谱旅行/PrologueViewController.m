//
//  PrologueViewController.m
//  游谱特惠
//
//  Created by youpu on 14-10-8.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "PrologueViewController.h"

@interface PrologueViewController ()
{
    UIPageControl *_control;
    UIScrollView * _scrollView;
    UIImageView *imageView;
}

@end

@implementation PrologueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prologue];
}

-(void)prologue{
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    CGFloat width = self.view.frame.size.width;
    
    
    CGFloat height = self.view.frame.size.height;
    
    [self.view addSubview:_scrollView];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tab setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];

    NSArray * array = [NSArray arrayWithObjects:@"引导页001",@"引导页002",@"引导页003", nil];
    for (int i = 0; i < [array count]; i++) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [imageView setImage:[UIImage imageNamed:[array objectAtIndex:i]]];
        [_scrollView addSubview:imageView];
    }
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(array.count*width, height);
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.delegate = self;
     
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x==self.view.frame.size.width*2) {
        self.gotoMainViewBtn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_gotoMainViewBtn addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_gotoMainViewBtn];
    }
    
}

-(void)gotoMainView{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [_scrollView setHidden:YES];
    [_control setHidden:YES];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FirstViewController *main = [[FirstViewController alloc]init];
    MadeOfMeViewController * made = [[MadeOfMeViewController alloc] init];
    AddViewController *add = [[AddViewController alloc] init];
    MaxOutViewController *max = [[MaxOutViewController alloc] init];
    PersonalCenterViewController *person = [[PersonalCenterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
    [nav setNavigationBarHidden:YES];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:made];
    UINavigationController *naviga = [[UINavigationController alloc] initWithRootViewController:add];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:max];
    UINavigationController *navigationqzy = [[UINavigationController alloc] initWithRootViewController:person];
    
    
    app.tab= [[TabBarController alloc] init];
    NSArray *arr = [NSArray arrayWithObjects:nav,navi,naviga,navigation,navigationqzy, nil];
    
    [app.tab setViewControllers:arr];
    [app.tab createButtons];
    app.tab.selectedIndex = 3;
    [app.window setRootViewController:app.tab];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
