//
//  MaxOutViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-22.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "MaxOutViewController.h"
#import "DetailViewController.h"
#import "WebViewController.h"
#import "MaxTableViewCell.h"
#import "ExplodeViewController.h"
#import "MaxOutView.h"

#define TEXT_COLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

@interface MaxOutViewController ()
{
    UILabel * _headerView;
    MBProgressHUD * _progressHUD;
}

@end

@implementation MaxOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.maxOutArr = [NSMutableArray array];
        self.maxOutDic = [NSMutableDictionary dictionary];
        self.dictionary = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self qzy];
    
    [self bigTableView];
    
    [self connect];
    
}

-(void)qzy{

    [self.view setBackgroundColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1]];
    self.navigationController.navigationBarHidden = YES;
    MaxOutView * max= [[MaxOutView alloc]init];
    [self.view addSubview:max];
    
}

-(void)addIndicator
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    [_progressHUD setMode:MBProgressHUDModeIndeterminate];
    [_progressHUD setLabelText:@"加载中..."];
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

-(void)connect{
    
    [self addIndicator];
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * QZY = [NSString stringWithFormat:@"%@%@",timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kNewMaxUrl,time];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_maxOutDic addEntriesFromDictionary:[dic objectForKey:@"data"]];
        [_maxOutTable reloadData];
        _progressHUD.hidden = YES;
        [_progressHUD removeFromSuperViewOnHide];
        [self headerView];
        
    }];
    
}

-(void)headerView{
    
    UIImageView * header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 335)];
    [header setUserInteractionEnabled:YES];
    
    UILabel * upLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    [upLable setBackgroundColor:[UIColor whiteColor]];
    [header addSubview:upLable];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 25)];
    [lable setText:@"今日专题"];
    [lable setTextColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]];
    [lable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:14]];
    [header addSubview:lable];
    
    UILabel * behindLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, 200, 25)];
    [behindLable setText:@"每天都有精彩旅行相关信息"];
    [behindLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [behindLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
    [header addSubview:behindLable];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(270, 3, 30, 30)];
    [button setImage:[UIImage imageNamed:@"爆款icon_03"] forState:UIControlStateNormal];
    [header addSubview:button];
    
    TouchImage * headerImage=  [[TouchImage alloc]initWithFrame:CGRectMake(0, 35, header.frame.size.width, 300)];
    NSString * string = [[_maxOutDic objectForKey:@"baokuanHeader"] objectForKey:@"pic"];
    [headerImage addTarget:self action:@selector(topicWeb)];
    [headerImage setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
    [header addSubview:headerImage];
    
    [_maxOutTable setTableHeaderView:header];

}
-(void)topicWeb{
    
    WebViewController * web = [[WebViewController alloc]init];
    web.string = [[_maxOutDic objectForKey:@"baokuanHeader"] objectForKey:@"url"];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:web];
    [self presentViewController:na animated:NO completion:nil];
}

-(void)bigTableView{
    
    self.maxOutTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, self.view.frame.size.height-114) style:UITableViewStyleGrouped];
    _maxOutTable.dataSource = self;
    _maxOutTable.delegate = self;
    [_maxOutTable setRowHeight:335];
    [_maxOutTable setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.005]];
    [_maxOutTable setShowsVerticalScrollIndicator:NO];
    [_maxOutTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_maxOutTable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil) {
        return 5;
        
    }else{
        
        return 6;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSDictionary * newDic = [_maxOutDic objectForKey:@"baokuan"];
    NSArray * array = [[newDic objectForKey:@"6"] objectForKey:@"listData"];
    NSArray * sevenArr = [[newDic objectForKey:@"7"] objectForKey:@"listData"];
    NSArray * eightArr = [[newDic objectForKey:@"8"] objectForKey:@"listData"];
    NSArray * nineArr = [[newDic objectForKey:@"9"]objectForKey:@"listData"];
    
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil)
    {
        if (section==0) {
            return array.count;
        }if (section==1) {
            return sevenArr.count;
        }if (section==2) {
            return eightArr.count;
        }if (section==3) {
            return nineArr.count;
        }
     
    }
    else
    {
        if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]!=nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]!=nil)
        {
            if (section==0)
            {
                return 2;
            }

       }
       else
       {
            if (section==0)
            {
                return 1;
            }

            
       }
        if (section==1) {
            return array.count;
        }if (section==2) {
            return sevenArr.count;
        }if (section==3) {
            return eightArr.count;
        }if (section==4) {
            return nineArr.count;
        }
    
   }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil)
    {
        return 0.0001;
    }
    else
    {
       if (section==0)
       {
        
        return 35;
       }
       else
       {
        
        return 0.0001;
       }
   }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil){
        return nil;
    }else{
        
        if (section==0) {
            UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
            [footView setBackgroundColor:[UIColor whiteColor]];
            UILabel * guessLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 25)];
            [guessLable setText:@"猜你喜欢"];
            [guessLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:14]];
            [guessLable setTextColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
            [footView addSubview:guessLable];
            UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, 20)];
            [lable setText:@"全球旅游目的地及特卖路线推荐"];
            [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [lable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footView addSubview:lable];
            return footView;
        }else{
            
            return nil;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil){
        return 50;
    }else{
        
        if (section==0) {
            return 55;
        }else{
            
            return 50;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil){
        
        if (section==0) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]];
            [footLable setBackgroundColor:[UIColor clearColor]];
            
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            NSString * dateString = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listDate"];
            NSString * date = [dateString substringToIndex:4];
            NSString * months = [dateString substringWithRange:NSMakeRange(5, 2)];
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, 35, 20)];
            [year setText:date];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:10]];
            [dateLable addSubview:year];
            UILabel * month = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 30)];
            [month setText:months];
            [month setTextAlignment:NSTextAlignmentCenter];
            [month setTextColor:[UIColor whiteColor]];
            [month setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            [dateLable addSubview:month];
            [footLable addSubview:dateLable];
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 100, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont systemFontOfSize:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==1) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 20)];
            [year setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listDate"]];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:16]];
            [dateLable addSubview:year];
            [footLable addSubview:dateLable];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==2) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            NSString * dateString = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listDate"];
            NSString * date = [dateString substringToIndex:4];
            NSString * months = [dateString substringWithRange:NSMakeRange(5, 2)];
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, 35, 20)];
            [year setText:date];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:10]];
            [dateLable addSubview:year];
            UILabel * month = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 30)];
            [month setText:months];
            [month setTextAlignment:NSTextAlignmentCenter];
            [month setTextColor:[UIColor whiteColor]];
            [month setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            [dateLable addSubview:month];
            [footLable addSubview:dateLable];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==3) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 20)];
            [year setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listDate"]];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:16]];
            [dateLable addSubview:year];
            [footLable addSubview:dateLable];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==4) {
            UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [lable setText:@"--- The End ---"];
            [lable setTextColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1]];
            [lable setFont:[UIFont systemFontOfSize:14]];
            [lable setTextAlignment:NSTextAlignmentCenter];
            return lable;
        }

        
    }else{
        
        if (section==0) {
            _headerView =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
            [_headerView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.15]];
            [_headerView setBackgroundColor:[UIColor clearColor]];
            
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            [_headerView addSubview:dateLable];
            
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(3, 4, 30, 30)];
            [image setImage:[UIImage imageNamed:@"爆款icon_01"]];
            [dateLable addSubview:image];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 100, 20)];
            [maxLable setText:[[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"listName"]];
            [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [_headerView addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 27, 200, 20)];
            [donwLable setText:[[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont systemFontOfSize:12]];
            [_headerView addSubview:donwLable];
            return _headerView;
        }
        if (section==1) {
            
            NSString * dateString = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listDate"];
            NSString * date = [dateString substringToIndex:4];
            NSString * months = [dateString substringWithRange:NSMakeRange(5, 2)];
            
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]];
            [footLable setBackgroundColor:[UIColor clearColor]];
            
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, 35, 20)];
            [year setText:date];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:10]];
            [dateLable addSubview:year];
            UILabel * month = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 30)];
            [month setText:months];
            [month setTextAlignment:NSTextAlignmentCenter];
            [month setTextColor:[UIColor whiteColor]];
            [month setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            [dateLable addSubview:month];
            [footLable addSubview:dateLable];
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 100, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont systemFontOfSize:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==2) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 20)];
            [year setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listDate"]];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:16]];
            [dateLable addSubview:year];
            [footLable addSubview:dateLable];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==3) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            NSString * dateString = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listDate"];
            NSString * date = [dateString substringToIndex:4];
            NSString * months = [dateString substringWithRange:NSMakeRange(5, 2)];
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, 35, 20)];
            [year setText:date];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:10]];
            [dateLable addSubview:year];
            UILabel * month = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 30)];
            [month setText:months];
            [month setTextAlignment:NSTextAlignmentCenter];
            [month setTextColor:[UIColor whiteColor]];
            [month setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            [dateLable addSubview:month];
            [footLable addSubview:dateLable];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==4) {
            UILabel * footLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [footLable setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
            UILabel * dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 35)];
            dateLable.layer.cornerRadius = 5;
            dateLable.layer.masksToBounds = YES;
            [dateLable setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3]];
            
            
            UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 35, 20)];
            [year setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listDate"]];
            [year setTextAlignment:NSTextAlignmentCenter];
            [year setTextColor:[UIColor whiteColor]];
            [year setFont:[UIFont systemFontOfSize:16]];
            [dateLable addSubview:year];
            [footLable addSubview:dateLable];
            
            
            UILabel * maxLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 20)];
            [maxLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listName"]];
            [maxLable setTextColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
            [maxLable setFont:[UIFont systemFontOfSize:14]];
            [footLable addSubview:maxLable];
            UILabel * donwLable= [[UILabel alloc]initWithFrame:CGRectMake(40, 24, 200, 20)];
            [donwLable setText:[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listDescript"]];
            [donwLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
            [donwLable setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
            [footLable addSubview:donwLable];
            return footLable;
        }
        if (section==5) {
            UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            [lable setText:@"--- The End ---"];
            [lable setTextColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1]];
            [lable setFont:[UIFont systemFontOfSize:14]];
            [lable setTextAlignment:NSTextAlignmentCenter];
            return lable;
        }
    }
    return nil;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIden = @"cell";
    MaxTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[MaxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    NSInteger six =[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"]count]-1;
    NSInteger seven =[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"]count]-1;
    NSInteger eight =[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"]count]-1;
    NSInteger nine =[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"]count]-1;
    
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil){
        if (indexPath.section==0) {
            
            if ((indexPath.section==0 &&indexPath.row==six)||(indexPath.section==1 &&indexPath.row==seven)||(indexPath.section==2 && indexPath.row==eight)||(indexPath.section==3 && indexPath.row==nine)) {
                [cell.paddingLable setHidden:YES];
                cell.downLayerCity.hidden = YES;
                
            }else{
                [cell.paddingLable setHidden:NO];
            }
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"title"]isEqualToString:@"美国-洛杉矶、拉斯维加斯"]) {
                [cell.header setText:@"美国-洛杉矶"];
                [cell.behindLable setFrame:CGRectMake(90, 8, 200, 20)];
            }else{
                [cell.header setText:[dic objectForKey:@"title"]];
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        if (indexPath.section==1) {
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.header setText:[dic objectForKey:@"title"]];
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        if (indexPath.section==2) {
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            [cell.header setText:[dic objectForKey:@"title"]];
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        if (indexPath.section==3) {
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            [cell.header setText:[dic objectForKey:@"title"]];
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }

    }else{

        if ((indexPath.section==1 &&indexPath.row==six)||(indexPath.section==3 &&indexPath.row==eight)||(indexPath.section==2 && indexPath.row==seven)||(indexPath.section==4 && indexPath.row==nine)) {
            [cell.paddingLable setHidden:YES];
            cell.downLayerCity.hidden = YES;
            
        }else{
            [cell.paddingLable setHidden:NO];
        }
        if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]!=nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]!=nil){
            if (indexPath.section==0 && indexPath.row==0) {
                [cell.header setText:@"价格最低"];
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
                [cell.behindLable setText:@"可以选择更多的特惠价格产品"];
                NSDictionary * dic = [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"];
                [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"middlePath"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
                [cell.lable setText:[dic objectForKey:@"price"]];
                [cell.titleDes setText:[dic objectForKey:@"titleDescribe"]];
            } if (indexPath.section==0&&indexPath.row==1) {
                [cell.header setText:@"销量最好"];
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
                [cell.behindLable setText:@"我们会有更多销量最好的产品推荐"];
                NSDictionary * dic = [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"];
                [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"middlePath"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
                [cell.lable setText:[dic objectForKey:@"price"]];
                [cell.titleDes setText:[dic objectForKey:@"titleDescribe"]];
            }
        }
        if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil) {
            if (indexPath.section==0&&indexPath.row==0) {
                [cell.header setText:@"销量最好"];
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
                [cell.behindLable setText:@"我们会有更多销量最好的产品推荐"];
                NSDictionary * dic = [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"];
                [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"middlePath"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
                [cell.lable setText:[dic objectForKey:@"price"]];
                [cell.titleDes setText:[dic objectForKey:@"titleDescribe"]];
            }
            if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil) {
                if (indexPath.section==0 && indexPath.row==0) {
                    [cell.header setText:@"价格最低"];
                    [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
                    [cell.behindLable setText:@"可以选择更多的特惠价格产品"];
                    NSDictionary * dic = [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"];
                    [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"middlePath"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
                    [cell.lable setText:[dic objectForKey:@"price"]];
                    [cell.titleDes setText:[dic objectForKey:@"titleDescribe"]];
                }

            }

        }
        if (indexPath.section==1) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"title"]isEqualToString:@"美国-洛杉矶、拉斯维加斯"]) {
                [cell.header setText:@"美国-洛杉矶"];
                [cell.behindLable setFrame:CGRectMake(90, 8, 200, 20)];
            }else{
                [cell.header setText:[dic objectForKey:@"title"]];
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        if (indexPath.section==2) {
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.header setText:[dic objectForKey:@"title"]];
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        if (indexPath.section==3) {
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            [cell.header setText:[dic objectForKey:@"title"]];
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        if (indexPath.section==4) {
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"];
            NSDictionary * dic =[array objectAtIndex:indexPath.row];
            [cell.header setText:[dic objectForKey:@"title"]];
            NSString * title = [dic objectForKey:@"title"];
            if (title.length==2) {
                [cell.behindLable setFrame:CGRectMake(45, 8, 240, 20)];
            }if (title.length==3) {
                [cell.behindLable setFrame:CGRectMake(60, 8, 240, 20)];
            }if (title.length==4) {
                [cell.behindLable setFrame:CGRectMake(70, 8, 240, 20)];
            }if (title.length==8) {
                [cell.header setFrame:CGRectMake(10, 5, 120, 25)];
                [cell.behindLable setFrame:CGRectMake(130, 8, 200, 20)];
            }
            [cell.behindLable setText:[dic objectForKey:@"description"]];
            [cell.lable setText:[dic objectForKey:@"price"]];
            [cell.titleDes setText:[dic objectForKey:@"lineTitleDescribe"]];
            [cell.cityImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"linePic"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
        }
        

    }

    if (!(indexPath.section==0 && indexPath.row==1)) {
        cell.arrowheadImage.hidden = NO;
        [cell.arrowLable addTarget:self action:@selector(toMainList:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.arrowheadImage.hidden = YES;
        [cell.arrowLable removeTarget:self action:@selector(toMainList:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil){
        if (indexPath.section==0) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
        if (indexPath.section==1) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
        if (indexPath.section==2) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
        if (indexPath.section==3) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }

    }else{
        if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]!=nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]!=nil){
            if (indexPath.section==0 && indexPath.row==0) {
                DetailViewController * detail = [[DetailViewController alloc]init];
                detail.lineNumber = [[[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"] objectForKey:@"dataId"];
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:detail];
                [self presentViewController:na animated:NO completion:nil];
            }
            if (indexPath.section==0 && indexPath.row==1) {
                DetailViewController * detail = [[DetailViewController alloc]init];
                detail.lineNumber = [[[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"] objectForKey:@"dataId"];
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:detail];
                [self presentViewController:na animated:NO completion:nil];
            }

        }
        if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil) {
            if (indexPath.section==0 && indexPath.row==0) {
                DetailViewController * detail = [[DetailViewController alloc]init];
                detail.lineNumber = [[[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"] objectForKey:@"dataId"];
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:detail];
                [self presentViewController:na animated:NO completion:nil];
            }if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil) {
                if (indexPath.section==0 && indexPath.row==0) {
                    DetailViewController * detail = [[DetailViewController alloc]init];
                    detail.lineNumber = [[[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"] objectForKey:@"dataId"];
                    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:detail];
                    [self presentViewController:na animated:NO completion:nil];
                }
            }

    }
    
        if (indexPath.section==1) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
        if (indexPath.section==2) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
        if (indexPath.section==3) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
        if (indexPath.section==4) {
            DetailViewController * detail = [[DetailViewController alloc]init];
            detail.lineNumber = [[[[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"]objectAtIndex:indexPath.row] objectForKey:@"dataId"];
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:detail];
            [self presentViewController:navi animated:NO completion:nil];
        }
}
}

-(void)toMainList:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    MaxTableViewCell  *cell;
    
    cell = (MaxTableViewCell *)button.superview;
    NSLog(@"%d,%d",[_maxOutTable indexPathForCell:cell].section,[_maxOutTable indexPathForCell:cell].row);
    
    if([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]==nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]==nil){
        if ([_maxOutTable indexPathForCell:cell].section==0) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (urlToCity !=nil) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }else{
                
    
            }
        }
        if ([_maxOutTable indexPathForCell:cell].section==1) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
        if ([_maxOutTable indexPathForCell:cell].section==2) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
        if ([_maxOutTable indexPathForCell:cell].section==3) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
    }else{
        
        if ([[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"minPrice"]!=nil && [[_maxOutDic objectForKey:@"baokuanTop"] objectForKey:@"bestSell"]!=nil) {
            if ([_maxOutTable indexPathForCell:cell].section==0 && [_maxOutTable indexPathForCell:cell].row==0) {
                
                ExplodeViewController * explode = [[ExplodeViewController alloc]init];
                UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:explode];
                [self presentViewController:navi animated:NO completion:nil];
            }
        }

        if ([_maxOutTable indexPathForCell:cell].section==1) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"6"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }else{
                
                WebViewController * web = [[WebViewController alloc]init];
                web.string = [dic objectForKey:@"titleUrl"];
                [self presentViewController:web animated:NO completion:nil];
            }
        }
        if ([_maxOutTable indexPathForCell:cell].section==2) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"7"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
        if ([_maxOutTable indexPathForCell:cell].section==3) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"8"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
        if ([_maxOutTable indexPathForCell:cell].section==4) {
            
            NSArray * array = [[[_maxOutDic objectForKey:@"baokuan"] objectForKey:@"9"] objectForKey:@"listData"];
            NSDictionary * dic = [array objectAtIndex:[_maxOutTable indexPathForCell:cell].row];
            NSString * urlToCity = [dic objectForKey:@"urlToCity"];
            if (![urlToCity isEqualToString:@""]) {
                
                NSInteger i = 1;
                NSInteger j = 1;
                NSString * string = [NSString stringWithFormat:@"%d",i];
                NSString * strings = [NSString stringWithFormat:@"%d",j];
                UIColor * color = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                NSString * buttonTitle = [dic objectForKey:@"urlToCityName"];
                NSString * chufa = nil;
                NSString * chufaId =[dic objectForKey:@"urlTravelDate"];
                UIColor * chufaColor =nil;
                if ([[dic objectForKey:@"urlTravelDate"]isEqualToString:@"0"]) {
                    chufa = @"出发时间";
                    chufaColor = [UIColor whiteColor];
                }else{
                    chufa = [dic objectForKey:@"urlTravelDateName"];
                    chufaColor =[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
                }
                NSDictionary * dic = @{@"strings":urlToCity,@"removeOrNo":string,@"buttonColor":color,@"buttonTitle":buttonTitle, @"jIsEqualTo":strings,@"chufa":chufa,@"chufaColor":chufaColor,@"chufaId":chufaId};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:dic];
                
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.tab.selectedIndex = 0;
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
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
