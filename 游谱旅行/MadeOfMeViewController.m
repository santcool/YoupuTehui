//
//  MadeOfMeViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MadeOfMeViewController.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "LXActionSheet.h"

@interface MadeOfMeViewController ()
{
    BOOL _value;
    UIButton * _button;
    TouchImage * _image;
    UIView  * _view;
    MBProgressHUD * _progressHUD;
}

@property (nonatomic, strong) UIScrollView * scrollView;
@property (assign, nonatomic) NSInteger separatorIndex;
@property (assign, nonatomic) BOOL isFromAdd;

@end

@implementation MadeOfMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.madeDic = [[NSMutableDictionary alloc] init];
        self.tableViewDic = [[NSMutableArray alloc] init];
        _i =0;
        _page = 1;
        self.separatorIndex = -1;
        self.isFromAdd = NO;
        
    [[NSNotificationCenter defaultCenter] addObserverForName:@"added" object:nil queue:nil usingBlock:^(NSNotification *note) {
      self.isFromAdd = YES;
      self.madeString = [[note userInfo]objectForKey:@"location"];
        
    }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tabbarColor];
    [self createTableView];
    [self wuDingZhi];

}

-(void)wuDingZhi{
    _image = [[TouchImage alloc]initWithFrame:CGRectMake((self.view.frame.size.width-170)/2, 100, 170, 45)];
    [_image setImage:[UIImage imageNamed:@"无我的定制"]];
    [self.view addSubview:_image];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-170)/2, 150, 170, 45)];
    [_button setBackgroundImage:[UIImage imageNamed:@"橙条"] forState:UIControlStateNormal];
    [_button setTitle:@"我要定制" forState:UIControlStateNormal];
    [_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_button.titleLabel setTintColor:[UIColor whiteColor]];
    [_button addTarget:self action:@selector(makeList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"] == nil) {
        
        
        UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"登录后定制行程，快速找到适合的特惠产品" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [action setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        [action showInView:self.view];
        
    } else {

        if (_scrollView != nil) {
            [_scrollView removeFromSuperview];
        }
        [self connect];

    }
 
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [actionSheet removeFromSuperview];
    if (buttonIndex==1) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.tab.selectedIndex = appDelegate.tab.prevSelectedIndex;
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tab.prevSelectedIndex = 1;
        if (app.tab.isOrNo==1) {
            app.tab.isOrNo=1;
        }if (app.tab.isOrNo==3) {
            
            app.tab.isOrNo = 3;
        }
        LoginViewController * login = [[LoginViewController alloc]init];
        UINavigationController * na = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:na animated:NO completion:nil];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    _page=1;
    _madeString = nil;
    [_madeDic removeAllObjects];
    _tableViewDic = [NSMutableArray array];
    
}
#pragma mark
#pragma mark ----------------添加菊花
//添加菊花
-(void)addIndicator
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    [_progressHUD setMode:MBProgressHUDModeIndeterminate];
    [_progressHUD setLabelText:@"加载中..."];
    _progressHUD.delegate = self;
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

#pragma mark
#pragma mark -自定义Navigationbar
-(void)tabbarColor{
    
    self.title = @"我的定制";
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    UIColor * cc = [UIColor whiteColor];
    UIFont * font = [UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

#pragma mark
#pragma mark - 上方button title网络请求
-(void)connect{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";

    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * member = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kCustomUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,member];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];

        [self.madeDic addEntriesFromDictionary:dic];
        if ([[_madeDic objectForKey:@"data"]count]>0) {
            [_madeTableView setHidden:NO];
            [_button setHidden:YES];
            [_image setHidden:YES];
            [self createUpView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
        }else{
            [_madeTableView setHidden:YES];
            [_button setHidden:NO];
            [_image setHidden:NO];

        }
    }];
    
}

-(void)makeList{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 2;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark
#pragma mark - 创建上方button 并获得title
-(void)createUpView{
    
    NSArray * array = [self.madeDic objectForKey:@"data"];
    
    self.scrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    [_scrollView setBackgroundColor:[UIColor colorWithRed:39/255.0 green:45/255.0 blue:55/255.0 alpha:0.9f]];
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(80*[array count], 50);
    [self.view  addSubview:_scrollView];
    
    if (array.count <= 4)
    {
        
        for (int i = 0; i < array.count; i ++)
        {
            NSDictionary * dic = [array objectAtIndex:i];

           UIButton * button = [[UIButton alloc ] initWithFrame:CGRectMake(i * ([[UIScreen mainScreen] bounds].size.width / [array count]), 0, [[UIScreen mainScreen] bounds].size.width / [array count], 50)];
            NSString * string = nil;
            if ([[dic objectForKey:@"toCityName"]isEqualToString:@"市"]) {
                string = [[dic objectForKey:@"toCityName"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }else{
                string = [dic objectForKey:@"toCityName"];
            }
            [button setTitle:string forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateSelected];
            button.tag = i+1000;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (button.tag ==1000)
            {
                button.selected = YES;
                
            }
            
            [_scrollView addSubview:button];
            
            UIImageView * smallImage= [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/[array count]-10, 16, 20, 20)];
            [smallImage setImage:[UIImage imageNamed:@"小树线"]];
            [button addSubview:smallImage];
        }
        
        self.downView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width/[array count], 2)];
        [self.downView setImage:[UIImage imageNamed:@"红线"]];
        [self.scrollView addSubview:_downView];
        
        UIImageView * san = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2/[array count]-10, -5, 30, 6)];
        [san setImage:[UIImage imageNamed:@"红三角"]];
        [_downView addSubview:san];
        
    }
    else
    {


        for (int i = 0; i < array.count; i ++)
        {
            NSDictionary * dic = [array objectAtIndex:i];

            UIButton * button = [[UIButton alloc ] initWithFrame:CGRectMake(i * ([[UIScreen mainScreen] bounds].size.width / 4), 0, [[UIScreen mainScreen] bounds].size.width / 4, 50)];
            NSString * string = nil;
            if ([[dic objectForKey:@"toCityName"]isEqualToString:@"市"]) {
                string = [[dic objectForKey:@"toCityName"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }else{
                string = [dic objectForKey:@"toCityName"];
            }
            [button setTitle:string forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateSelected];
            button.tag = i+1000;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (button.tag ==1000)
            {
                button.selected = YES;
                
            }
            
            [_scrollView addSubview:button];
            
            UIImageView * smallImage= [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-10, 16, 20, 20)];
            [smallImage setImage:[UIImage imageNamed:@"小树线"]];
            [button addSubview:smallImage];
        }
        self.downView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, self.view.frame.size.width/4, 2)];
        [self.downView setImage:[UIImage imageNamed:@"红线"]];
        [self.scrollView addSubview:self.downView];
        
        UIImageView * san = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2/4-10, -5, 30, 6)];
        [san setImage:[UIImage imageNamed:@"红三角"]];
        [self.downView addSubview:san];

    }
    
}
#pragma mark
#pragma mark - 上方button点击事件
-(void)buttonAction:(id)sender{
    
    _madeString = nil;
    _isFromAdd = NO;
    
    NSArray * array = [self.madeDic objectForKey:@"data"];
    UIButton * button = (UIButton *)sender;
    _i = button.tag-1000;
    _page = 1;
    [_tableViewDic removeAllObjects];
    [self tableViewConnect];
    
    for (int i = 1000; i < 1000+[array count]; i++) {
        UIButton * buttons = (UIButton *)[self.view viewWithTag:i];
        buttons.selected = NO;
    }
    
    button.selected = YES;
    
    
    //控制横条动画移动
    [UIView animateWithDuration:0.2 animations:^{
        [self.downView setFrame:CGRectMake( button.frame.origin.x, self.downView.frame.origin.y, self.downView.frame.size.width, self.downView.frame.size.height)];
    }];
    
}

#pragma mark 
#pragma mark -tableviewcell网络请求
-(void)tableViewConnect{
    
    [self addIndicator];
    
    NSArray * array = [self.madeDic objectForKey:@"data"];
    NSDictionary * dic = nil;
    
    if (_isFromAdd) {
        dic = array.lastObject;

    } else {
        dic = array[_i];
    }
    if (_madeString !=nil) {
        for (int i = 0; i< [array count]; i++) {
            
            if ([[[array objectAtIndex:i]objectForKey:@"id"]isEqualToString:_madeString]) {
                _i=i;
                dic = array[_i];
            }
        }
    }
    

    NSString * order = [dic objectForKey:@"id"];
  
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * page = [NSString stringWithFormat:@"%d",_page];
    NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * orderId = order;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,orderId,page,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    page = [NSString stringWithFormat:@"%@=%@%@",@"page",page,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    orderId = [NSString stringWithFormat:@"%@=%@%@",@"orderId",orderId,@"&"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kShowUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",url,time,page,memberId,orderId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.tableViewDic addObjectsFromArray:[dic objectForKey:@"data"]];
        
        self.separatorIndex = -1;
        [self.tableViewDic enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"rn"] integerValue] != 1) {
                self.separatorIndex = idx;
                *stop = YES;
            }
        }];
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"id"] integerValue] == [order integerValue]) {
                NSInteger count = array.count < 4 ? array.count : 4;
                CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.frame.size.width > 0 ? self.scrollView.contentSize.width - self.scrollView.frame.size.width : 0;
                CGFloat offset = MIN(self.scrollView.frame.size.width / count * idx, maxOffset);
                self.scrollView.contentOffset = CGPointMake(offset, 0);
                
                for (int i = 1000; i < 1000+[array count]; i++) {
                    UIButton * button = (UIButton *)[self.view viewWithTag:i];
                    if (i - 1000 == idx) {
                        [self.downView setFrame:CGRectMake( button.frame.origin.x, self.downView.frame.origin.y, self.downView.frame.size.width, self.downView.frame.size.height)];
                        button.selected = YES;
                    } else {
                        button.selected = NO;
                    }
                }
                *stop = YES;
            }
        }];
        
        [_madeTableView reloadData];
        [_progressHUD hide:YES];
    }];
    

    _page+=1;

}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (hud==_progressHUD) {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    
    
}

-(void)hiddenLine:(UITableView *)tableView{
    UIView *view= [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
}
#pragma mark 
#pragma mark - 创建tableview
-(void)createTableView{
    
    self.madeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-114) style:UITableViewStylePlain];
    _madeTableView.dataSource = self;
    _madeTableView.delegate = self;
    [_madeTableView setRowHeight:100];
    [_madeTableView setShowsVerticalScrollIndicator:NO];
    [self hiddenLine:_madeTableView];
    
    [self.view addSubview:_madeTableView];
    
}

#pragma mark
#pragma mark ----------------- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_separatorIndex > -1) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_separatorIndex > -1) {
        if (section == 0) {
            return _separatorIndex;
        } else {
            return _tableViewDic.count - _separatorIndex;
        }
    }
    return [self.tableViewDic count];
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    }
    if (_separatorIndex >-1 && [[[_tableViewDic firstObject]objectForKey:@"rn"] integerValue]!=1)
    {
        return 94;
    }

    return 24;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    if (_separatorIndex >-1 && [[[_tableViewDic firstObject]objectForKey:@"rn"] integerValue]!=1) {
        UIView * aView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 94)];
        [aView setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]];
        UIButton * image = [[UIButton alloc]initWithFrame:CGRectMake(50 ,0,200, 70)];
        [image setBackgroundImage:[UIImage imageNamed:@"无匹配"] forState:UIControlStateNormal];
        [aView addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 24)];
        label.textColor = [UIColor blackColor];
        [label setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"    其他参考行程";
        [aView addSubview:label];
        return aView;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
    header.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200, 20)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"其他参考行程";
    [header addSubview:label];
    return header;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    FirstTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    if ([_tableViewDic count]!=0) {
        
        NSDictionary *dic = nil;
        if (_separatorIndex > -1 && indexPath.section > 0) {
            dic = _tableViewDic[_separatorIndex + indexPath.row];
        } else {
            dic = _tableViewDic[indexPath.row];
        }
        
        NSString * thumb = [dic objectForKey:@"thumbPath"];
        NSURL * url = [NSURL URLWithString:thumb];
        if ([thumb isEqualToString:@""]) {
            [cell.image setImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }else{
            [cell.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }

        if ([[dic objectForKey:@"fromcity"]length]==2) {
            [cell.fromLable setFrame:CGRectMake(100, 15, 40, 20)];
            [cell.toLable setFrame:CGRectMake(150, 15, 200, 20)];
            [cell.LineImage setFrame:CGRectMake(130, 15, 20, 20)];
        }else{
            [cell.fromLable setFrame:CGRectMake(100, 15, 60, 20)];
            [cell.toLable setFrame:CGRectMake(170, 15, 140, 20)];
            [cell.LineImage setFrame:CGRectMake(150, 15, 20, 20)];
        }
        NSString * tocityStr = [dic objectForKey:@"tocity"];
        NSString * tocityString = nil;
        if (tocityStr.length>=13) {
            tocityString = [tocityStr substringToIndex:11];
            [cell.toLable setText:tocityString];
        }else{
            
            [cell.toLable setText:[dic objectForKey:@"tocity"]];
        }
        [cell.fromLable setText:[dic objectForKey:@"fromcity"]];
        [cell.detailLable setText:[dic objectForKey:@"titleDescribe"]];
        
        NSNumber * number = [dic objectForKey:@"price"];
        NSString * priceStr = [number stringValue];
        [cell.priceLable setText:priceStr];
        
        NSNumber * num = [dic objectForKey:@"basePrice"];
        NSString *string = [num stringValue];
        if ([string isEqualToString:@"0"]) {
            
            [cell.basePrice setText:@""];
            [cell.baseImage setImage:[UIImage imageNamed:@"123"]];
            
        }else{
            
            [cell.basePrice setText:string];
        }
        
        if ([[dic objectForKey:@"travelType"] isEqualToString:@"随团游"]) {
            
            [cell.genImage setImage:[UIImage imageNamed:@"跟团游"]];
            
        }if ([[dic objectForKey:@"travelType"] isEqualToString:@"自由行"])
            
            
            [cell.genImage setImage:[UIImage imageNamed:@"自由行"]];
        
        NSString *dayStr = [dic objectForKey:@"daysShow"];
        dayStr = [dayStr stringByReplacingOccurrencesOfString:@"天" withString:@""];
        
        NSString * fuhao =  @"★";
        NSString * stars = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"hotelStar"],fuhao];
        [cell.textLable setText:dayStr];
        [cell.hotLable setText:[dic objectForKey:@"hotelStar"]];
        
        if ([[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
            [cell.flyImage setHidden:YES];
            
        }else{
            
            [cell.flyImage setHidden:NO];
            [cell.hotLable setText:stars];
            
        }
        if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"] && ![[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
            [cell.flyImage setFrame:CGRectMake(133, 70, 20, 20)];
            [cell.hotLable setFrame:CGRectMake(148, 80, 15, 10)];
            [cell.hotLable setText:stars];
            [cell.stayImage setHidden:YES];
        }
        if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]){
            
            [cell.stayImage setHidden:NO];
            [cell.flyImage setFrame:CGRectMake(166, 70, 20, 20)];
            
            
        }
        if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]&& ![[dic objectForKey:@"hotelStar"]isEqualToString:@""])
        {
            [cell.hotLable setText:stars];
            [cell.hotLable setFrame:CGRectMake(178, 80, 15, 10)];
            
        }
        if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"]&& [[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
            [cell.stayImage setHidden:YES];
            [cell.flyImage setHidden:YES];
        }
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = nil;
    if (_separatorIndex > -1 && indexPath.section > 0) {
        dic = _tableViewDic[_separatorIndex + indexPath.row];
    } else {
        dic = _tableViewDic[indexPath.row];
    }
    NSString * lineId = [dic objectForKey:@"lineId"];
    NSString *isFavorite = [dic objectForKey:@"isFavorite"];
    BOOL isFavoriteOrNo = [isFavorite boolValue];
    
    DetailViewController * detail = [[DetailViewController alloc]init];
    if (isFavoriteOrNo ==true) {
        detail.isCollect =1;
    }else{
        detail.isCollect = 0;
    }
    detail.lineNumber = lineId;
    UINavigationController * na= [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:na animated:NO completion:nil];
    
    
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
