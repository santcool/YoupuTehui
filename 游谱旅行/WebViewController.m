//
//  WebViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-28.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "WebViewController.h"
#import "DetailViewController.h"

@interface WebViewController ()
{
     UIActivityIndicatorView * _indicator;//菊花
}

@end

@implementation WebViewController

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
    
    self.title = @"信息详情";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    
    [self webview];
    
}

-(void)backActon{
    
    [self.delegate fanhui];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}

-(void)webview{
    
    [self addIndicator];
    
    UIWebView * web  =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    web.autoresizesSubviews = YES;//自动调整大小
    web.scalesPageToFit =YES;//自动对页面进行缩放以适应屏幕
    web.delegate = self;
    web.scrollView.delegate = self;
    

    NSURL * url  =[NSURL URLWithString:self.string];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *detailPrefix = @"http://tehui.youpu.cn/line/";
    NSString *requestURL = request.URL.absoluteString;
    if ([requestURL hasPrefix:detailPrefix] && [requestURL hasSuffix:@"/"]) {
        NSString *lineId = [requestURL stringByReplacingOccurrencesOfString:detailPrefix withString:@""];
        lineId = [lineId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        DetailViewController * detail = [[DetailViewController alloc] init];
        detail.lineNumber = lineId;
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:detail];
        [self presentViewController:navi animated:NO completion:nil];
        return NO;
    }
    
    return YES;
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
