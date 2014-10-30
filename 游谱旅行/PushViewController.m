//
//  PushViewController.m
//  游谱特惠
//
//  Created by youpu on 14-9-18.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "PushViewController.h"
#import "PushView.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.array = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self qzy];
    [self createTable];
    [self connect];
}

-(void)qzy{
    
    self.navigationController.navigationBarHidden = YES;
    PushView * push = [[PushView alloc]init];
    [push.backImage setImage:[UIImage imageNamed:@"back"]];
    [push.button addTarget:self action:@selector(backandback) forControlEvents:UIControlEventTouchUpInside];
    [push.backImage addTarget:self action:@selector(backandback)];
    [self.view addSubview:push];
}
-(void)backandback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)connect{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId = [[NSUserDefaults standardUserDefaults]objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kPushUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@",url,time,memberId];
    
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style:kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_array addObjectsFromArray:[dic objectForKey:@"data"]];
        [_pushTable reloadData];
    }];

}

-(void)createTable{
    
    self.pushTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    _pushTable.delegate = self;
    _pushTable.dataSource = self;
    [_pushTable setRowHeight:100];
    [_pushTable setScrollEnabled:YES];
    [self.view addSubview:_pushTable];
    
    [self setExtraCellLineHidden:_pushTable];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    FirstTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    NSDictionary * dic = [_array objectAtIndex:indexPath.row];
    NSString * thumb = [dic objectForKey:@"thumbPath"];
    NSURL * url = [NSURL URLWithString:thumb];
    if ([thumb isEqualToString:@""]) {
        [cell.image setImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
    }else{
        [cell.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noImageIcon.jpg"]];
    }
    [cell.fromLable setText:[dic objectForKey:@"fromcity"]];
    [cell.toLable setText:[dic objectForKey:@"tocity"]];
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
        [cell.baseImage setImage:[UIImage imageNamed:@"横线"]];
    }
    
    if ([[dic objectForKey:@"travelType"] isEqualToString:@"随团游"])
    {
        [cell.genImage setImage:[UIImage imageNamed:@"跟团游"]];
    }
    else
    {
        [cell.genImage setImage:[UIImage imageNamed:@"自由行"]];
    }
    
    if ([[dic objectForKey:@"hot"]isEqualToString:@"2"]) {
        [cell.hotImage setImage:[UIImage imageNamed:@"hot"]];
    }else{
        [cell.hotImage setImage:[UIImage imageNamed:@"100"]];
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

    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController * detail = [[DetailViewController alloc]init];
    detail.lineNumber = [[_array objectAtIndex:indexPath.row] objectForKey:@"lineId"];
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
