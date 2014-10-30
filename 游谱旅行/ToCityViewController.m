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
    MBProgressHUD * _progressHUD;
    NSInteger _i;
}

@property (strong,nonatomic) NSIndexPath *lastpath;
@property (strong,nonatomic) NSIndexPath *desPath;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) NSMutableArray *resultIdArray;;

@end

@implementation toCityViewController

+ (id)shareSingle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
        self.arr = [[NSMutableArray alloc]init];
        
        self.resultArray = [[NSMutableArray alloc]init];
        self.resultIdArray = [[NSMutableArray alloc]init];
        _i=0;
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setNavigationBar];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_displayController setActive:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTable];
    [self connect];
    [self createSearchBar];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1];
    [self.navigationController.view addSubview:view];
    
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


-(void)setNavigationBar{
    
    self.title = @"选择目的地";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    
    UIColor * cc = [UIColor whiteColor];
    UIFont * font =[UIFont systemFontOfSize:18];
    NSDictionary * dict = @{NSForegroundColorAttributeName:cc,NSFontAttributeName:font};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(backActon) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
}

-(void)backActon{
    
    _countryName = [_countryName stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self.delegate destination:_countryName];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    _displayController= [[UISearchDisplayController alloc]initWithSearchBar:_search
                                                         contentsController:self];
    
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
}

#pragma mark - searchBar的协议等相关方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_search setShowsCancelButton:YES animated:NO];
    CGRect frame = self.search.frame;
    frame.origin.y = 20;
    self.search.frame = frame;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [_search resignFirstResponder];
    CGRect frame = self.search.frame;
    frame.origin.y = 0;
    self.search.frame = frame;
    [searchBar setShowsCancelButton:NO animated:NO];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    for (int i = 0; i<[_arr count]; i++) {
        NSString * cityName = [_arr objectAtIndex:i];
        
        NSPredicate * pridicate =[NSPredicate predicateWithFormat:@"self == %@",_search.text];
        BOOL _isexit = [pridicate evaluateWithObject:cityName];
        if (_isexit ==YES) {
            [self.resultArray addObject:cityName];
        }
        
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self.resultArray removeAllObjects];
    for (int i = 0; i<[_arr count]; i++) {
        NSString * cityName = [_arr objectAtIndex:i];
        NSString * city =[cityName stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSPredicate * pridicate =[NSPredicate predicateWithFormat:@"self == %@",_search.text];
        BOOL _isexit = [pridicate evaluateWithObject:city];
        if (_isexit ==YES) {
            [self.resultArray addObject:cityName];
            return YES;
        }
        
    }
    
    return NO;
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
    NSString * qzy = [TeHuiModel md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [TeHuiModel md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kPrefixUrl,kFilterUrl];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",url,time];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",lastUrl,sign];
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [self.dictionary addEntriesFromDictionary:dic];
        
        [_destinationTable reloadData];
        [_progressHUD hide:YES];
        [_progressHUD removeFromSuperViewOnHide];
        
        NSDictionary * dicc = [self.dictionary objectForKey:@"data"];
        NSArray * arr = [dicc objectForKey:@"toCity"];
        
        for (int i = 1; i< [arr count]; i++) {
            NSDictionary * dic = [arr objectAtIndex:i];
            NSArray  * arr = [dic objectForKey:@"value"];
            for (NSDictionary * cityName in arr) {
                
                [_arr addObject:[cityName objectForKey:@"name"]];
                NSDictionary * idDic = [NSDictionary dictionaryWithObjectsAndKeys:[cityName objectForKey:@"name"],@"cityName",[cityName objectForKey:@"id"],@"cityId", nil];
                [_resultIdArray addObject:idDic];
            }
        }
        
        
        
    }];
}

-(void)createTable{
    
    self.destinationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 160, [UIScreen mainScreen].bounds.size.height-109) style:UITableViewStylePlain];
    
    _destinationTable.delegate = self;
    _destinationTable.dataSource = self;
    [_destinationTable setShowsVerticalScrollIndicator:NO];
    [_destinationTable setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:_destinationTable];
    
    self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(160, 44, 160, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStylePlain];
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.scrollEnabled = YES;
    _rightTable.hidden = YES;
    [_rightTable setShowsVerticalScrollIndicator:NO];
    [_rightTable setShowsHorizontalScrollIndicator:NO];
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
    else if (tableView== self.rightTable)
    {
        return [self.valueArray count];
    }
    else{
        
        return [self.resultArray count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.destinationTable])
    {
        static NSString * cellIdentify = @"cell";
        UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            
        }
        NSDictionary * dic = [self.dictionary objectForKey:@"data"];
        NSArray * array = [dic objectForKey:@"toCity"];
        NSDictionary * nameDic = [array objectAtIndex:indexPath.row];
        [cell.textLabel setText:[nameDic objectForKey:@"name"]];
        
        UIView * view= [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.06]];
        cell.selectedBackgroundView = view;
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        return cell;
    }
    else if(tableView ==self.rightTable)
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
        
        [cell1.textLabel setFont:[UIFont systemFontOfSize:16]];
        
        for (int i = 0; i < [_valueArray count]; i++) {
            NSDictionary * dic = [_valueArray objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"name"]isEqualToString:_countryName]) {
                _lastpath = indexPath;
                [cell1.image setImage:[UIImage imageNamed:@"钩钩"]];
            }
            
        }
        
        if (_lastpath != nil) {
            if (_lastpath.row == indexPath.row) {
                [cell1.image setImage:[UIImage imageNamed:@"钩钩"]];
                cell1.image.hidden = NO;
            }
            else {
                
                [cell1.image setHidden:YES];
            }
        } else {
            
            cell1.image.hidden = YES;
        }
        
        
        return cell1;
        
    }
    else{
        
        static NSString * cellIdentify = @"哈";
        UITableViewCell * cell1  = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell1 == nil)
        {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            
        }
        [cell1.textLabel setText:[self.resultArray objectAtIndex:indexPath.row]];
        [cell1.textLabel setFont:[UIFont systemFontOfSize:16]];
        return cell1;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.destinationTable)
    {
        if (_desPath!= indexPath) {
            _lastpath =nil;
        }
        if (indexPath.row == 0)
        {
            _countryName = nil;
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"toCity"];
            NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
            [_rightTable setHidden:YES];
            [self.delegate destination:[dictionary objectForKey:@"name"]];
            NSDictionary * name = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"string",nil];
            SingleClass * single  = [SingleClass singleClass];
            [single.singleDic addEntriesFromDictionary:name];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"toCity"];
            NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
            NSString * string = [dictionary objectForKey:@"name"];
            NSString * mainId = [dictionary objectForKey:@"mainId"];
            NSDictionary * allDic = [NSDictionary dictionaryWithObjectsAndKeys:string,@"name",mainId,@"mainId",nil];
            
            NSArray * arr = [dictionary objectForKey:@"value"];
            if ([self.valueArray count]==0)
            {
                [_rightTable setHidden:NO];
                [self.valueArray addObjectsFromArray:arr];
                if (![string isEqualToString:@"热门地区"]) {
                    [self.valueArray insertObject:allDic atIndex:0];
                }
                [_rightTable reloadData];
            }
            else
            {
                
                [_rightTable setHidden:NO];
                [self.valueArray removeAllObjects];
                [self.valueArray addObjectsFromArray:arr];
                if (![string isEqualToString:@"热门地区"]) {
                    [self.valueArray insertObject:allDic atIndex:0];
                }
                [_rightTable reloadData];
            }
        }
        
        _desPath=indexPath;
        
    }
    else if(tableView==self.rightTable)
    {
        
        int newRow = [indexPath row];
        int oldRow = (_lastpath != nil) ? [_lastpath row] : newRow-1;
        if (newRow != oldRow) {
            DestinationTableViewCell *newCell = (DestinationTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                             indexPath];
            [newCell.image setImage:[UIImage imageNamed:@"钩钩"]];
            [newCell.image setHidden:NO];
            
            DestinationTableViewCell *oldCell = (DestinationTableViewCell *)[tableView cellForRowAtIndexPath:
                                                                             _lastpath];
            [oldCell.image setHidden:YES];
            
            _lastpath = indexPath;
        }
        // 取消选择状态
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary * dic = [self.valueArray objectAtIndex:indexPath.row];
        
        if (![[dic objectForKey:@"mainId"]isEqualToString:@""]) {
            NSString* strings = [[dic objectForKey:@"name"]stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [self.delegate destination:strings];
            self.countryName = [dic objectForKey:@"name"];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        if (indexPath.row == 0)
        {
            
            NSString * mainId = [dic objectForKey:@"mainId"];
            if (mainId!=nil) {
                [self.delegate tocityId:mainId];
            }else{
                [self.delegate tocityId:[dic objectForKey:@"id"]];
            }
            
        }
        else
        {
            NSString * string = [dic objectForKey:@"id"];
            [self.delegate tocityId:string];
        }
        
    }
    else{
        
        NSString * string = [self.resultArray objectAtIndex:indexPath.row];
        for (NSDictionary * idDic  in _resultIdArray) {
            NSString * str = [idDic objectForKey:@"cityName"];
            if ([str isEqualToString:string]) {
                [self.delegate tocityId:[idDic objectForKey:@"cityId"]];
            }
        }
        
        NSString * cityName = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.delegate destination:cityName];
        _countryName = cityName;
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
