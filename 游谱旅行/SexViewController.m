//
//  SexViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-15.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "SexViewController.h"

static SexViewController * sexView = nil;

@interface SexViewController ()

@property (strong,nonatomic)NSIndexPath *lastpath;

@end

@implementation SexViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sexView = [[self alloc] initWithNibName:nil bundle:nil];
    });
    
    return sexView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sexArray = [[NSMutableArray alloc]init];
        NSDictionary * qaz = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"gender",@"男",@"genders", nil];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"gender",@"女",@"genders", nil];
        NSDictionary * did =[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"gender",@"保密",@"genders", nil];
        
        [self.sexArray addObject:qaz];
        [self.sexArray addObject:dic];
        [self.sexArray addObject:did];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self qzy];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self qzyTableView];
}

-(void)qzy
{
    self.title = self.sex;
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

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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

-(void)qzyTableView{
    
    UILabel * aLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.view addSubview:aLable];
    
    CALayer * yyy = [CALayer layer];
    yyy.frame = CGRectMake(0, 19, 320, 1);
    yyy.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.15].CGColor;
    [aLable.layer addSublayer:yyy];
    
    self.sexTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 132) style:UITableViewStylePlain];
    _sexTable.delegate = self;
    _sexTable.dataSource = self;
    [_sexTable setScrollEnabled:NO];
    
    [self setExtraCellLineHidden:_sexTable];
    
    [self.view addSubview:_sexTable];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.sexArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellIden = @"cell";
    ConditionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        
        [cell.textLabel setText:[[self.sexArray objectAtIndex:indexPath.row] objectForKey:@"genders"]];
        if ([[[self.sexArray objectAtIndex:indexPath.row] objectForKey:@"genders"]isEqualToString:_sexAndLove]) {
            _lastpath = indexPath;
            [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
        }
        
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];;
    NSString * type = @"gender";
    NSString * value = [[_sexArray objectAtIndex:indexPath.row] objectForKey:@"gender"];
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
    
    int newRow = [indexPath row];
    int oldRow = (_lastpath != nil) ? [_lastpath row] : newRow-1;
    if (newRow != oldRow) {
        ConditionTableViewCell *newCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     indexPath];
        [newCell.image setImage:[UIImage imageNamed:@"钩钩"]];
        
        ConditionTableViewCell *oldCell = (ConditionTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                     _lastpath];
        [oldCell.image setHidden:YES];
        
        _lastpath = indexPath;
    }
    // 取消选择状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    NSString * string = [[self.sexArray objectAtIndex:indexPath.row] objectForKey:@"genders"];
    [self.delegate sex:string];
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
