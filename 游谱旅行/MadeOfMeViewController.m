//
//  MadeOfMeViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MadeOfMeViewController.h"
#import "MadeView.h"
#import "DetailViewController.h"
#import "LoginViewController.h"

@interface MadeOfMeViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
    BOOL _value;
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

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"] == nil) {
        
    } else {
        if (_scrollView != nil) {
            [_scrollView removeFromSuperview];
        }
        [self connect];
        [self tabbarColor];
        [self createTableView];
    }
    
 
}
-(void)viewWillDisappear:(BOOL)animated{
    
    _page=1;
    _madeString = nil;
    [_madeDic removeAllObjects];
    _tableViewDic = [NSMutableArray array];
    [_madeTableView removeFromSuperview];
    [_header free];
    [_footer free];
    
}
#pragma mark
#pragma mark ----------------添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0 , 114, self.view.frame.size.width, self.view.frame.size.height-114)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}


#pragma mark 
#pragma mark -自定义Navigationbar
-(void)tabbarColor{
    
    MadeView * made = [[MadeView alloc] init];
    [self.view addSubview:made];
}

#pragma mark 
#pragma mark -MD5加密规则
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
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * member = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",kCustomUrl,time,member];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];

        [self.madeDic addEntriesFromDictionary:dic];
        if ([[_madeDic objectForKey:@"data"]count]>0) {
            [self createUpView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
        }else{
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tab.selectedIndex = 2;
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    }];
    
}
#pragma mark
#pragma mark - 创建上方button 并获得title
-(void)createUpView{
    
    NSArray * array = [self.madeDic objectForKey:@"data"];
    
    self.scrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 50)];
    _scrollView.pagingEnabled = YES;
    [self.view  addSubview:_scrollView];
    
    if (array.count <= 4)
    {
        
        for (int i = 0; i < array.count; i ++)
        {
            NSDictionary * dic = [array objectAtIndex:i];

           UIButton * button = [[UIButton alloc ] initWithFrame:CGRectMake(i * ([[UIScreen mainScreen] bounds].size.width / [array count]), 0, [[UIScreen mainScreen] bounds].size.width / [array count], 50)];
            [button setTitle:[dic objectForKey:@"toCityName"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor colorWithRed:39/255.0 green:45/255.0 blue:55/255.0 alpha:0.9f]];
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

        _scrollView.contentSize = CGSizeMake(80*[array count], 50);//设置底片的大小
        for (int i = 0; i < array.count; i ++)
        {
            NSDictionary * dic = [array objectAtIndex:i];

            UIButton * button = [[UIButton alloc ] initWithFrame:CGRectMake(i * ([[UIScreen mainScreen] bounds].size.width / 4), 0, [[UIScreen mainScreen] bounds].size.width / 4, 50)];
            [button setTitle:[dic objectForKey:@"toCityName"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor colorWithRed:39/255.0 green:45/255.0 blue:55/255.0 alpha:0.9f]];
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
    
    NSArray * array = [self.madeDic objectForKey:@"data"];
    UIButton * button = (UIButton *)sender;
    switch (button.tag) {
        case 1000:
        {
             
            _i=0;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
            
        }
            break;
        case 1001:
        {
            _i=1;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];

        }
            break;
            case 1002:
        {
            _i=2;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];

        }
            break;
        case 1003:{
            
            _i=3;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects]; 
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];

        }
            break;
        case 1004:
        {
            _i=4;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];

        }
            break;
            case 1005:
        {
            _i=5;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];

        }
            break;
        case 1006:
        {
            _i=6;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
            
        }
            break;
        case 1007:
        {
            _i=7;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
            
        }
            break;
        case 1008:
        {
            _i=8;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
            
        }
            break;
        case 1009:
        {
            _i=9;
            _page=1;
            [_madeTableView removeFromSuperview];
            [_tableViewDic removeAllObjects];
            [self.view addSubview:_madeTableView];
            [self tableViewConnect];
            [_madeTableView addInfiniteScrollingWithActionHandler:^{
                [self tableViewConnect];
                [_madeTableView.infiniteScrollingView stopAnimating];
            }];
            
        }
            break;

        default:
            break;
    }

    
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
    
    if (_page ==1) {
        [self addIndicator];
    }
    
    NSArray * array = [self.madeDic objectForKey:@"data"];
    NSDictionary * dic = nil;
    
    if (_isFromAdd) {
        dic = array.lastObject;
        _isFromAdd = NO;
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
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    page = [NSString stringWithFormat:@"%@=%@%@",@"page",page,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    orderId = [NSString stringWithFormat:@"%@=%@%@",@"orderId",orderId,@"&"];
    
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@%@",kShowUrl,time,page,memberId,orderId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
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
        [_footer endRefreshing];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
    }];
    
    _madeString = nil;
    _page+=1;

}

-(void)hiddenLine:(UITableView *)tableView{
    UIView *view= [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
}
#pragma mark 
#pragma mark - 创建tableview
-(void)createTableView{
    
    self.madeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,114, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-154) style:UITableViewStylePlain];
    _madeTableView.dataSource = self;
    _madeTableView.delegate = self;
    [_madeTableView setRowHeight:100];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 24)];
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
        
        [cell.image setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumbPath"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        [cell.fromLable setText:[dic objectForKey:@"fromcity"]];
        [cell.toLable setText:[dic objectForKey:@"tocity"]];
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
    
    DetailViewController * detail = [[DetailViewController alloc]init];
    detail.lineNumber = lineId;
    UINavigationController * na= [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:na animated:NO completion:nil];
    
    
}

#pragma mark -
#pragma mark 上拉加载,下来刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _madeTableView;
    footer.delegate = self;
    
    _footer = footer;
}
#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]){

        [self tableViewConnect];
    }
    
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
    [_madeTableView setContentOffset:CGPointMake(_madeTableView.contentOffset.x, _madeTableView.contentOffset.y+50)];
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
