//
//  FavoriteViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteTableViewCell.h"

@interface FavoriteViewController ()

@property (strong,nonatomic)NSIndexPath *lastpath;

@end

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.array = [[NSMutableArray alloc]init];;
        
        self.favoriteArr = [[NSMutableArray alloc] init];
        self.favoriteId = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self qzy];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLable];
    
    [self createTable];
    
    [self connect];
}

-(void)qzy
{
    self.title = self.favorite;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.06]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)saveAction{
    
    
    _favoriteNow =nil;
    for (int i = 0; i < [_favoriteId count]; i++) {
        NSString * string = [_favoriteId objectAtIndex:i];
        if (_favoriteNow==nil) {
            _favoriteNow = [NSString stringWithFormat:@"%@",string];
        }else{
            _favoriteNow = [NSString stringWithFormat:@"%@%@%@",_favoriteNow,@",",string];
        }
        
    }
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];

    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * type = @"travelType";
    NSString * value = _favoriteNow;
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@%@%@",memberId,timeString,type,value,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    type = [NSString stringWithFormat:@"%@=%@%@",@"type",type,@"&"];
    value = [NSString stringWithFormat:@"%@=%@%@",@"value",value,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@%@%@",kReviseUrl,time,type,value];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
    }];

    
    [self.delegate favorite:self.favoriteArr];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
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
-(void)connect{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * QZY = [NSString stringWithFormat:@"%@%@",timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kFilterCaseListUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        [_array addObjectsFromArray:[[dic objectForKey:@"data"] objectForKey:@"travelType"]];
        [_table reloadData];
        
    }];
}

-(void)createLable{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [lable setText:@"  选择您的旅行偏好,可多选"];
    [lable setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    [lable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:lable];
    
    CALayer * yyy = [CALayer layer];
    yyy.frame = CGRectMake(0, 39, self.view.frame.size.width, 1);
    yyy.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.15].CGColor;
    [lable.layer addSublayer:yyy];
    
}

-(void)lineHidden:(UITableView *)tableView{
    
    UIView * view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [tableView setTableFooterView:view];
    
}

-(void)createTable
{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [_table setEditing:YES];
    
    [self lineHidden:_table];
    
    [self.view addSubview:_table];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentify = @"cell";
    FavoriteTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[FavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    [cell.textLabel setText:[[_array objectAtIndex:indexPath.row] objectForKey:@"value"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * value = [[self.array objectAtIndex:indexPath.row] objectForKey:@"value"];
    NSString * strings= [[self.array objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.favoriteArr addObject:value];
    [self.favoriteId addObject:strings];

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
