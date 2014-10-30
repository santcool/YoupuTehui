//
//  ExplodeViewController.m
//  游谱特惠
//
//  Created by youpu on 14-10-17.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "ExplodeViewController.h"

@interface ExplodeViewController ()

@end

@implementation ExplodeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.maxOutArr = [[NSMutableArray alloc] init];
        
        self.everyArr = [[NSMutableArray alloc]init];
        
        self.maxOutDic = [[NSMutableDictionary alloc] init];
        
        _i=1;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self color];
    [self bigTableView];
    [self connect];
    [self maxList];
    [self serverTime];
    
    [_maxOutTable addInfiniteScrollingWithActionHandler:^{
        [self maxList];
        [_maxOutTable.infiniteScrollingView stopAnimating];
    }];
    
}
-(void)color{
    
    self.title = @"今日爆款";
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

-(void)backActon{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//添加菊花
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
-(void)serverTime{
    
    [ConnectModel connectWithParmaters:nil url:kServerTimeUrl style:kConnectGetType finished:^(id result) {
        NSDictionary * dic=  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = [dic objectForKey:@"data"];
        _serverTime = [array objectAtIndex:0];
        
    }];
}
#pragma mark
#pragma mark - 上方图片所有内容网络请求
-(void)connect{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    //    NSInteger  unnecessary = [_serverTime integerValue]- [timeString integerValue];
    //        if (unnecessary>0) {
    //            timeString = [NSString stringWithFormat:@"%d",[timeString integerValue]+unnecessary];
    //        }else{
    //            timeString = [NSString stringWithFormat:@"%d",[timeString integerValue]-unnecessary];
    //        }
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * QZY = [NSString stringWithFormat:@"%@%@",timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kMaxOutUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",url,time];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [self.maxOutDic addEntriesFromDictionary:dic];
        [self createImageView];
        
    }];
    
}

-(void)createImageView{
    
    NSDictionary * dic =[self.maxOutDic objectForKey:@"data"];
    
    imageLable = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    [imageLable setAlpha:1];
    [imageLable setUserInteractionEnabled:YES];
    [_maxOutTable setTableHeaderView:imageLable];
    
    TouchImage * image = [[TouchImage alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 160)];
    [image setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumbPath"]]placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
    [image addTarget:self action:@selector(webViewhaha)];
    [imageLable addSubview:image];
    
    UIView * smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 109, 300, 51)];
    [smallView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7]];
    [image addSubview:smallView];
    
    UIImageView * money = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 15, 15)];
    [money setImage:[UIImage imageNamed:@"钱币icon"]];
    [smallView addSubview:money];
    
    UILabel * priceLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 6, 70, 30)];
    [priceLable setFont:[UIFont systemFontOfSize:24]];
    [priceLable setTextColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    [priceLable setText:[[dic objectForKey:@"price"] stringValue]];
    [smallView addSubview:priceLable];
    
    UILabel * baseLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 60, 10)];
    [baseLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [baseLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    if ([[[dic objectForKey:@"basePrice"] stringValue] isEqualToString:@"0"]) {
        [baseLable setText:@""];
    }else{
        [baseLable setText:[[dic objectForKey:@"basePrice"] stringValue]];
    }
    [smallView addSubview:baseLable];
    
    UILabel * leaveLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 100, 15)];
    [leaveLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    NSString * leaveStr = [dic objectForKey:@"bit"];
    
    if ([leaveStr intValue]<10) {
        
        NSString * leaveString = [NSString stringWithFormat:@"%@%@%@",@"剩余",leaveStr,@"席"];
        //显示不同颜色字体的lable
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:leaveString];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, 1)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(3, 1)];
        leaveLable.attributedText = attributed;
        
    }else if([leaveStr intValue]>=10 && [leaveStr intValue]<100){
        NSString * leaveString = [NSString stringWithFormat:@"%@%@%@",@"剩余",leaveStr,@"席"];
        //显示不同颜色字体的lable
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:leaveString];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(4, 1)];
        leaveLable.attributedText = attributed;
    }else{
        
        NSString * leaveString = [NSString stringWithFormat:@"%@%@%@",@"剩余",leaveStr,@"席"];
        //显示不同颜色字体的lable
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:leaveString];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, 3)];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(5, 1)];
        leaveLable.attributedText = attributed;
    }
    
    [smallView addSubview:leaveLable];
    
    UIImageView * stayImage = [[UIImageView alloc] initWithFrame:CGRectMake(205, 12, 20, 20)];
    [stayImage setImage:[UIImage imageNamed:@"详情页icon@2x_06"]];
    [smallView addSubview:stayImage];
    WhiteLableText * stayLable = [[WhiteLableText alloc] initWithFrame:CGRectMake(217, 22, 35, 10)];
    NSString * stayStr = [dic objectForKey:@"days"];
    NSString *stayString = [stayStr stringByReplacingOccurrencesOfString:@"天" withString:@""];
    [stayLable setText:stayString];
    [stayLable setFont:[UIFont systemFontOfSize:8]];
    [stayLable setTextColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1]];
    [smallView addSubview:stayLable];
    
    UIImageView * hotImage = [[UIImageView alloc] initWithFrame:CGRectMake(265, 12, 20, 20)];
    [hotImage setImage:[UIImage imageNamed:@"详情页icon@2x_12"]];
    [smallView addSubview:hotImage];
    WhiteLableText * hotLable = [[WhiteLableText alloc] initWithFrame:CGRectMake(277, 18, 30, 10)];
    NSString * hotStr = [dic objectForKey:@"hotelStar"];
    [hotLable setText:hotStr];
    [hotLable setFont:[UIFont systemFontOfSize:8]];
    [hotLable setTextColor:[UIColor colorWithRed:255/255.0 green:199/255.0 blue:38/255.0 alpha:1]];
    [smallView addSubview:hotLable];
    
    UIImageView * zhiImage = [[UIImageView alloc] initWithFrame:CGRectMake(235, 12, 20, 20)];
    [zhiImage setImage:[UIImage imageNamed:@"详情页icon@2x_14"]];
    [smallView addSubview:zhiImage];
    NSString * fuhao =  @"★";
    NSString * stars = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"hotelStar"],fuhao];
    
    if ([[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [hotImage setHidden:YES];
        
    }else{
        
        [hotImage setHidden:NO];
        [hotLable setText:stars];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"] && ![[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [hotImage setFrame:CGRectMake(235, 12, 20, 20)];
        [hotLable setFrame:CGRectMake(247, 18, 20, 20)];
        [hotLable setText:stars];
        [zhiImage setHidden:YES];
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]){
        
        [zhiImage setHidden:NO];
        [hotImage setFrame:CGRectMake(265, 12, 20, 20)];
        [hotLable setFrame:CGRectMake(277, 18, 20, 20)];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"1"]&& ![[dic objectForKey:@"hotelStar"]isEqualToString:@""])
    {
        [hotImage setHidden:NO];
        [hotLable setText:stars];
        [hotLable setFrame:CGRectMake(277, 18, 20, 20)];
        
    }
    if ([[dic objectForKey:@"isDirect"]isEqualToString:@"0"]&& [[dic objectForKey:@"hotelStar"]isEqualToString:@""]) {
        [hotImage setHidden:YES];
        [zhiImage setHidden:YES];
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 45)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [imageLable addSubview:view];
    
    UILabel *upLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-30, 45)];
    [upLable setText:[dic objectForKey:@"titleDescribe"]];
    upLable.numberOfLines = 0;
    [upLable setLineBreakMode:NSLineBreakByWordWrapping];
    [upLable setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:upLable];
    
    UILabel * middle = [[UILabel alloc] initWithFrame:CGRectMake(0, 203, 70, 40)];
    [middle setText:@"  往日爆款"];
    [middle setTextColor:[UIColor blackColor]];
    [middle setFont:[UIFont systemFontOfSize:14]];
    [imageLable addSubview:middle];
    
    UILabel * aLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 203, 230, 40)];
    [aLable setText:@"您可以在这儿查到10日内的爆款信息"];
    [aLable setFont:[UIFont systemFontOfSize:12]];
    [aLable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [imageLable  addSubview:aLable];
    
}

-(void)webViewhaha{
    
    NSDictionary * dic =[self.maxOutDic objectForKey:@"data"];
    
    DetailViewController * detail = [[DetailViewController alloc] init];
    detail.lineNumber = [dic objectForKey:@"lineId"];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:navi animated:NO completion:nil];
    
}

-(void)maxList{
    
    [self addIndicator];
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * page = [NSString stringWithFormat:@"%ld",(long)_i];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",page,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    page = [NSString stringWithFormat:@"%@=%@%@",@"page",page,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kMaxListUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,page];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [_everyArr removeAllObjects];
        [_everyArr addObjectsFromArray:[dic objectForKey:@"data"]];
        
        [self.maxOutArr addObjectsFromArray:_everyArr];
        [_maxOutTable reloadData];
        [_progressHUD hide:YES];
        [_progressHUD removeFromSuperViewOnHide];
        
    }];
    if (_maxOutArr.count>10 && _maxOutArr.count == _maxOutArr.count + _everyArr.count) {
        
    }else{
        
        _i+=1;
    }
    
}
-(void)hiddenLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
}

-(void)bigTableView{
    
    self.maxOutTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _maxOutTable.dataSource = self;
    _maxOutTable.delegate = self;
    [_maxOutTable setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.15]];
    [_maxOutTable setShowsVerticalScrollIndicator:NO];
    [_maxOutTable setTableHeaderView:imageLable];
    
    [_maxOutTable setRowHeight:100];
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
        [_maxOutTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self hiddenLine:_maxOutTable];
    [self.view addSubview:_maxOutTable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_maxOutArr.count>10 && _maxOutArr.count == _maxOutArr.count + _everyArr.count) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==1) {
        return 0;
    }
    return [self.maxOutArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 100;
    }
    return 0;
}
-(UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==1) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"提示" delegate:nil cancelButtonTitle:@"没有更多了" otherButtonTitles:nil, nil];
        [alert show];
        return alert;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIden = @"cell";
    FirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    NSDictionary * dic = [_maxOutArr objectAtIndex:indexPath.row];
    
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
        [cell.baseImage setImage:[UIImage imageNamed:@"111"]];
        
    }else{
        
        [cell.basePrice setText:string];
        [cell.baseImage setImage:[UIImage imageNamed:@"横线"]];
    }
    
    if ([[dic objectForKey:@"travelType"] isEqualToString:@"随团游"]) {
        
        [cell.genImage setImage:[UIImage imageNamed:@"跟团游"]];
        
    }else{
        [cell.genImage setImage:[UIImage imageNamed:@"自由行"]];
    }
    
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath  animated:NO];
    NSDictionary * dic = [_maxOutArr objectAtIndex:indexPath.row];
    NSString *lineId = [dic objectForKey:@"lineId"];
    NSString *isFavorite = [dic objectForKey:@"isFavorite"];
    BOOL isFavoriteOrNo = [isFavorite boolValue];
    
    DetailViewController * detail = [[DetailViewController alloc]init];
    if (isFavoriteOrNo ==true) {
        detail.isCollect =1;
    }else{
        detail.isCollect = 0;
    }
    detail.lineNumber = lineId;
    [self.navigationController pushViewController:detail animated:NO];
    
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
