//
//  toCityViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-14.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "toCityViewController.h"

static toCityViewController *toCity = nil;

@interface toCityViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
}

@property (strong,nonatomic)NSIndexPath *lastpath;


@end

@implementation toCityViewController

+(id)shareSingle{
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
       
        toCity = [[self alloc] initWithNibName:nil bundle:nil];
        
    });
    return toCity;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dictionary = [[NSMutableDictionary alloc] init];
        
        self.valueArray = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self createSearchBar];
    [self createTable];
    [self connect];

    
}

//添加菊花
-(void)addIndicator
{
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
        [_indicator setColor:[UIColor colorWithRed:224/255.0  green:89/255.0 blue:60/255.0 alpha:1]];
        [_indicator setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        [_indicator startAnimating];
        [self.view addSubview:_indicator];
    }
}

-(void)setNavigationBar{
    
    self.title = @"选择目的地";
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

-(void)createSearchBar{
    
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [_search setPlaceholder:@"请输入您要去的国家"];
    [_search setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    _search.delegate = self;
    _search.autocorrectionType = UITextAutocorrectionTypeNo;
    _search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _search.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:_search];
    
    UISearchDisplayController * searchdispalyCtrl = [[UISearchDisplayController  alloc] initWithSearchBar:_search contentsController:self];
    
    searchdispalyCtrl.active = NO;
    
    searchdispalyCtrl.delegate = self;
    
    searchdispalyCtrl.searchResultsDelegate=self;
    
    searchdispalyCtrl.searchResultsDataSource = self;
    
}

-(void)searchText{
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.search resignFirstResponder];// 放弃第一响应者
    [self.destinationTable reloadData];
    
}

#pragma mark
#pragma mark -大加密
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
#pragma mark - 筛选条件网络请求
-(void)connect{
    
    [self addIndicator];
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
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kFilterUrl,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [self.dictionary addEntriesFromDictionary:dic];
        
        [_destinationTable reloadData];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        
        
    }];
}

-(void)createTable{
    
    self.destinationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 160, [UIScreen mainScreen].bounds.size.height-109) style:UITableViewStylePlain];
    
    _destinationTable.delegate = self;
    _destinationTable.dataSource = self;
    
    NSInteger selectedIndex = 0;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [_destinationTable selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:_destinationTable];
    
    self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(160, 44, 160, [UIScreen mainScreen].bounds.size.height-110) style:UITableViewStylePlain];
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.scrollEnabled = YES;
    [_rightTable setHidden:YES];
    [_rightTable setBackgroundColor:[UIColor whiteColor]];
    [_rightTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_rightTable];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.destinationTable)
    {
        NSDictionary * dic = [self.dictionary objectForKey:@"data"];
        NSArray * array = [dic objectForKey:@"toCity"];
        return [array count];
        
    }
    else
    {
        
        return [self.valueArray count];
        
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.destinationTable])
    {
        static NSString * cellIdentify = @"cell";
        DestinationTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil)
        {
            cell = [[DestinationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            
            
        }
        NSDictionary * dic = [self.dictionary objectForKey:@"data"];
        NSArray * array = [dic objectForKey:@"toCity"];
        NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[nameDic objectForKey:@"name"]];
        UIView * view= [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1]];
        cell.selectedBackgroundView = view;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        if ([[nameDic objectForKey:@"name"]isEqualToString:_toCityStr]) {
            _lastpath = indexPath;
            [cell.image setImage:[UIImage imageNamed:@"钩钩"]];
        }
        
        return cell;
    }
    else
    {
        
        static NSString * cellIdentif = @"哈哈";
        DestinationTableViewCell * cell1  = [tableView dequeueReusableCellWithIdentifier:cellIdentif];
        if (cell1 == nil)
        {
            cell1 = [[DestinationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentif];
            
            
            
            
        }
        NSDictionary * dic = [self.valueArray objectAtIndex:indexPath.row];
        
        [cell1.textLabel setText:[dic objectForKey:@"name"]];
       
        cell1.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.05];
        [cell1.textLabel setFont:[UIFont systemFontOfSize:14]];
        return cell1;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.destinationTable)
    {
        if (indexPath.row == 0)
        {
            
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"toCity"];
            NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
            NSString * mainId = [dictionary objectForKey:@"mainId"];
            NSDictionary * mainDic = [NSDictionary dictionaryWithObject:mainId forKey:@"string"];
            SingleClass * single  = [SingleClass singleClass];
            [single.singleDic addEntriesFromDictionary:mainDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
            
            [self.delegate destination:[dictionary objectForKey:@"name"]];
            
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
            
        }
        else
        {
            [_rightTable setHidden:NO];
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"toCity"];
            NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
            NSString * string = [dictionary objectForKey:@"name"];
            NSString * mainId = [dictionary objectForKey:@"mainId"];
            NSDictionary * allDic = [NSDictionary dictionaryWithObjectsAndKeys:string,@"name",mainId,@"mainId",nil];
            
            NSArray * arr = [dictionary objectForKey:@"value"];
            if ([self.valueArray count]==0)
            {
                
                [self.valueArray addObjectsFromArray:arr];
                [self.valueArray insertObject:allDic atIndex:0];
                [_rightTable reloadData];
            }
            else
            {
                [_rightTable setHidden:NO];
                
                [self.valueArray removeAllObjects];
                [self.valueArray addObjectsFromArray:arr];
                [self.valueArray insertObject:allDic atIndex:0];
                [_rightTable reloadData];
            }
        }
        
        
        
        
    }
    else
    {
        int newRow = [indexPath row];
        int oldRow = (_lastpath != nil) ? [_lastpath row] : newRow-1;
        if (newRow != oldRow) {
            DestinationTableViewCell *newCell = (DestinationTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                         indexPath];
            [newCell.image setImage:[UIImage imageNamed:@"钩钩"]];
            
            DestinationTableViewCell *oldCell = (DestinationTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                         _lastpath];
            [oldCell.image setHidden:YES];
            
            _lastpath = indexPath;
        }
        // 取消选择状态
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary * dic = [self.valueArray objectAtIndex:indexPath.row];
        
        [self.delegate tocityId:[dic objectForKey:@"id"]];
        NSString* strings = [[dic objectForKey:@"name"]stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.delegate destination:strings];
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
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
