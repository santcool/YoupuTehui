//
//  PersonalCenterViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "IndividualViewController.h"
#import "MakeListTableViewCell.h"
#import "DetailViewController.h"

@interface PersonalCenterViewController ()
{
    UIButton * _button;
    UIButton * _addButton;
    UIButton * _collectButton;
    NSInteger _k;
    TouchImage * _userPhoto;
     UILabel * _nameLable;
    MBProgressHUD * _progressHUD;

}
@property (strong, nonatomic) UIView *aView;

@end

@implementation PersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.collectArr = [[NSMutableArray alloc] init];
        self.collectDic = [[NSMutableDictionary alloc]init];
        self.makeThing = [[NSMutableDictionary alloc]init];
        self.numberArray = [NSMutableArray array];
        _i=1;
        _k=0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"]==nil) {

    }else{
        [self qzy];
        [self userMessage];
        [self madeListConnect];
        [self collectList];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [_nameLable removeFromSuperview];
    _k=1;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createImage];
    [self createView];
    [self createSet];
    [self bigTableView];
    [self editMade];
    [self createButton];
    [self addMakeMessage];
}

-(void)addMakeMessage{
    _aView = [[UIView alloc]initWithFrame:CGRectMake(0, 175, self.view.frame.size.width, 180)];
    _button = [[UIButton alloc]initWithFrame:CGRectMake(50 ,20,168, 37)];
    [_button setBackgroundImage:[UIImage imageNamed:@"无定制"] forState:UIControlStateNormal];
    [_aView addSubview:_button];
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 300, 40)];
    [_addButton.titleLabel  setTextColor:[UIColor whiteColor]];
    [_addButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_addButton setTitle:@"添加定制信息" forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(makeOneOrder) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
    [_aView addSubview:_addButton];
    [self.view addSubview:_aView];
}

//添加菊花
-(void)addIndicator
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
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

-(void)qzy{
    
    self.title = @"个人中心";
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font = [UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;

}

-(void)userMessage{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kUserInfoUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",url,time];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        _userIcons = [[dic objectForKey:@"data"]objectForKey:@"picPath"];
        
        if ([[[dic objectForKey:@"data"]objectForKey:@"nickName"]isEqualToString:@""]) {
            _userName = [[dic objectForKey:@"data"]objectForKey:@"email"];
        }else{
           _userName =[[dic objectForKey:@"data"]objectForKey:@"nickName"];
        }
        [self touxiang];
    }];
}

#pragma mark - 背景图
-(void)createImage{
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175)];
    [image setUserInteractionEnabled: YES];
    [image setImage:[UIImage imageNamed:@"背景图.jpg"]];
    [self.view addSubview:image];
    
}
-(void)touxiang{
    _userPhoto = [[TouchImage alloc]initWithFrame:CGRectMake(80, 40, 60, 60)];
    if ([_userIcons isEqualToString:@""]) {
        [_userPhoto setImage:[UIImage imageNamed:@"默认头像.jpg"]];
    }else{
    [_userPhoto setImageWithURL:[NSURL URLWithString:_userIcons]];
    }
    _userPhoto.layer.cornerRadius = 30;
    _userPhoto.layer.masksToBounds = YES;
    _userPhoto.layer.borderWidth = 2;
    _userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    [_userPhoto addTarget:self action:@selector(personAnd)];
    [image addSubview:_userPhoto];
    
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(150, 40, 150, 60)];
    [_nameLable setTextColor:[UIColor whiteColor]];
    [_nameLable setText:_userName];
    [_nameLable setFont:[UIFont systemFontOfSize:14]];
    [image addSubview:_nameLable];
    
    
}
-(void)personAnd{
    
    IndividualViewController * indiv = [[IndividualViewController alloc] init];
    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:indiv];
    [self presentViewController:na animated:NO completion:nil];
    
}

#pragma mark - button上的view
-(void)createView{
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, self.view.frame.size.width, 50)];
    [aView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
    [image addSubview:aView];
    
}

#pragma mark
#pragma mark - 创建button
-(void)createButton {
    
    NSArray * array = [NSArray arrayWithObjects:@"我的定制",@"我的收藏", nil];
    
    for (int i = 0; i < [array count] ; i++) {
        
        UIButton * button =[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2*i, 125, self.view.frame.size.width/2, 50)];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1] forState:UIControlStateSelected];
        button.tag = i+1000;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag ==1000) {
            button.selected = YES;
            UIImageView * smallImage= [[UIImageView alloc] initWithFrame:CGRectMake(150, 16, 20, 20)];
            [smallImage setImage:[UIImage imageNamed:@"小树线"]];
            [button addSubview:smallImage];
            _collectButton = [[UIButton alloc]initWithFrame:CGRectMake(50 ,210,185, 69)];
            [_collectButton setBackgroundImage:[UIImage imageNamed:@"无收藏"] forState:UIControlStateNormal];
            _collectButton.hidden = YES;
            [self.view addSubview:_collectButton];
        }
        [image addSubview:button];
    }

    
    self.downView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 173, self.view.frame.size.width/[array count], 2)];
    [self.downView setImage:[UIImage imageNamed:@"红线"]];
    [self.view addSubview:self.downView];
    
    UIImageView * san = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2/[array count]-10, -5, 30, 6)];
    [san setImage:[UIImage imageNamed:@"红三角"]];
    [self.downView addSubview:san];
    
}

#pragma mark - 点击事件呀
-(void)buttonAction:(id)sender{
    
    UIButton * button = (UIButton *)sender;
    switch (button.tag) {
        case 1000:
        {
            if ([[_makeThing objectForKey:@"data"]count]==0) {
                [_aView setHidden:NO];
                [_makeListTable setHidden:NO];
            }else{
                [_aView setHidden:YES];
                [_makeListTable setHidden:NO];
                
            }
            [_collectButton setHidden:YES];
            [_table setHidden:YES];
        }
            
            break;
        case 1001:
        {
            if ([[_collectDic objectForKey:@"data"]count]==0) {
                [_collectButton setHidden:NO];
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"无收藏"] forState:UIControlStateNormal];
                [_table setHidden:YES];
            }else{
                [_collectButton setHidden:YES];
                [_table setHidden:NO];
            }
        
            [_aView setHidden:YES];
            [_makeListTable setHidden:YES];
        }
            break;
            
        default:
            break;
    }
    
    for (int i = 1000; i < 1002; i++) {
        UIButton * buttons = (UIButton *)[self.view viewWithTag:i];
        buttons.selected = NO;
    }
    button.selected = YES;
    //控制横条动画移动
    [UIView animateWithDuration:0.5 animations:^{
        [self.downView setFrame:CGRectMake(button.frame.origin.x, self.downView.frame.origin.y, self.downView.frame.size.width, self.downView.frame.size.height)];
    }];
    
}

#pragma mark
#pragma mark - 设置button
-(void)createSet{
    
    TouchImage * clickImage = [[TouchImage alloc] initWithFrame:CGRectMake(280, 10, 30, 30)];
    [clickImage setImage:[UIImage imageNamed:@"设置"]];
    [clickImage addTarget:self action:@selector(touchEvent)];
    
    [image addSubview:clickImage];
}
-(void)touchEvent{
    
    IndividualViewController * indiv = [[IndividualViewController alloc] init];
    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:indiv];
    [self presentViewController:na animated:NO completion:nil];
}

#pragma mark
#pragma mark  ----------------定制列表网络请求
-(void)madeListConnect{
    
    [_numberArray removeAllObjects];
    
    [self addIndicator];
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kCustomUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,memberId];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_makeThing addEntriesFromDictionary:dic];

        if ([[_makeThing objectForKey:@"data"]count]==0) {
            if (_downView.frame.origin.x==0) {
                _aView.hidden = NO;
            }else{
                _aView.hidden = YES;
            }
            
        }else{
            _aView.hidden = YES;
        }
        [_makeListTable reloadData];
        [_progressHUD hide:YES];
        
        for (int i = 0 ; i< [[_makeThing objectForKey:@"data"] count]; i++) {
            NSString * string = [NSString stringWithFormat:@"%d",i+1];
            [_numberArray addObject:string];
        }
    }];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (hud==_progressHUD) {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
}

#pragma mark
#pragma mark ----------------------添加定制信息按钮
-(void)makeOneOrder{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 2;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark
#pragma mark ------------------ 定制详情
-(void)editMade{
    
    self.makeListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 175, self.view.frame.size.width, self.view.frame.size.height-289) style:UITableViewStylePlain];
    _makeListTable.delegate = self;
    _makeListTable.dataSource = self;
    [_makeListTable setShowsVerticalScrollIndicator:NO];
    
    if ([[[UIDevice currentDevice]systemVersion ] floatValue] >=7.0) {
        [_makeListTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self hiddenLine:_makeListTable];
    
    [_makeListTable setRowHeight:100];
    
    [self.view addSubview:_makeListTable];
    
}

-(void)collectList{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * page = [NSString stringWithFormat:@"%ld",(long)_i];
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",memberId,page,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    page = [NSString stringWithFormat:@"%@=%@%@",@"page",page,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kCollectListUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",url,time,memberId,page];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.collectDic addEntriesFromDictionary:dic];
        
        if ([[_collectDic objectForKey:@"data"]count]==0) {
           
        }else{
            
            [_collectButton setHidden:YES];
            [_table setHidden:NO];
        }
        [_table reloadData];
     
    }];
    
}
-(void)hiddenLine:(UITableView *)tableview{
    
    UIView * view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableview setTableFooterView:view];
}

-(void)bigTableView{
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 175, self.view.frame.size.width, self.view.frame.size.height-289) style:UITableViewStylePlain];
    _table.delegate =self;
    _table.dataSource = self;
    [_table setShowsVerticalScrollIndicator:NO];

    [_table setRowHeight:100];
    
    if ([[[UIDevice currentDevice]systemVersion ] floatValue] >=7.0) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self hiddenLine:_table];
    [self.view addSubview:_table];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        if (tableView==_table) {
            
        NSMutableArray * array = [_collectDic objectForKey:@"data"];
        NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
        NSString * line= [dictionary objectForKey:@"lineId"];
        
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
        NSString * lineId= line;
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",lineId,memberId,timeString,key];
        NSString * qzy = [TeHuiModel md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [TeHuiModel md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
        lineId = [NSString stringWithFormat:@"%@=%@%@",@"lineId",lineId,@"&"];
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kDeleteCollectUrl];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",url,time,memberId,lineId];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
                
                [array removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
                [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                [_table reloadData];
                if (array.count==0) {
                    [_collectButton setHidden:NO];
                    [_collectButton setBackgroundImage:[UIImage imageNamed:@"无收藏"] forState:UIControlStateNormal];
                }
            }
            
        }];
            
    }else{
        
        NSMutableArray * array = [_makeThing objectForKey:@"data"];
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";

        NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
        NSString * orderId = [[[_makeThing objectForKey:@"data"]objectAtIndex:indexPath.row ] objectForKey:@"id"];
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@",memberId,orderId,timeString,key];
        NSString * qzy = [TeHuiModel md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [TeHuiModel md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
        orderId = [NSString stringWithFormat:@"%@=%@%@",@"orderId",orderId,@"&"];
        NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kDeleteUrl];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",url,time,memberId,orderId];
        
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
        
        [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([[[dic objectForKey:@"code"] stringValue]isEqualToString:@"0"]) {
                
                [array removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
                [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                [_makeListTable reloadData];
                if (array.count==0) {
                    [_aView setHidden:NO];
                }
            }
            
        }];
        

    }
        
  }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==_table) {
            return [[self.collectDic objectForKey:@"data"] count];
    }else{
        
        return [[_makeThing objectForKey:@"data"]count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_table) {
        static NSString * cellIden = @"cell";
        FirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil) {
            cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        }
        NSArray * arr = [_collectDic objectForKey:@"data"];
        NSDictionary * dic = [arr objectAtIndex:indexPath.row];
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
        if ([string isEqualToString:@"0"])
        {
            [cell.basePrice setText:@""];
            [cell.baseImage setImage:[UIImage imageNamed:@"123"]];
        }
        else
        {
            [cell.basePrice setText:string];
        }
        
        if ([[dic objectForKey:@"travelType"] isEqualToString:@"跟团游"])
        {
            
            [cell.genImage setImage:[UIImage imageNamed:@"跟团游"]];
            
        }
        if ([[dic objectForKey:@"travelType"] isEqualToString:@"自由行"])
        {
            
            [cell.genImage setImage:[UIImage imageNamed:@"自由行"]];
        }
        
        NSString *dayStr = [dic objectForKey:@"daysShow"];
        dayStr = [dayStr stringByReplacingOccurrencesOfString:@"天" withString:@""];
        
        [cell.textLable setText:dayStr];
        [cell.hotLable setText:[dic objectForKey:@"hotelStar"]];
        
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
        return cell;
        
    }else{
        
        static NSString * cellIdenty = @"cell";
        MakeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
        if (cell == nil) {
            cell = [[MakeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
        }
        
        NSArray * array = [_makeThing objectForKey:@"data"];
        NSDictionary * dic = [array objectAtIndex:indexPath.row];
        
        [cell.cityName setText:[dic objectForKey:@"toCityName"]];
        [cell.specificLable setText:[dic objectForKey:@"travelDateValue"]];
        if ([[dic objectForKey:@"daysValue"] isEqualToString:@""]) {
            [cell.daysLable setText:@"不限"];
        }else{
        [cell.daysLable setText:[dic objectForKey:@"daysValue"]];
        }
        if ([[dic objectForKey:@"budgetValue"]isEqualToString:@""]) {
            [cell.budgetLable setText:@"不限"];
        }else{
        [cell.budgetLable setText:[dic objectForKey:@"budgetValue"]];
        }
 
        [cell.numberImage setTitle:[_numberArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [cell.numberImage.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.numberImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.numberImage setBackgroundImage:[UIImage imageNamed:@"排序底色"] forState:UIControlStateNormal];
        return cell;
        
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_table)
    {
        [tableView deselectRowAtIndexPath:indexPath  animated:NO];
        DetailViewController * detail = [[DetailViewController alloc]init];
        detail.lineNumber = [[[_collectDic objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"lineId"];
        detail.isCollect = 1;
        UINavigationController * na = [[UINavigationController alloc]initWithRootViewController:detail];
        [self presentViewController:na animated:NO completion:nil];
    }
    if (tableView==_makeListTable)
    {
        [tableView deselectRowAtIndexPath:indexPath  animated:NO];
        NSString * orderId =[[[_makeThing objectForKey:@"data"]objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:orderId,@"order", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nicai" object:nil userInfo:dic];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.tab.selectedIndex = 2;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
