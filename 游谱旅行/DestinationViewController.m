//
//  DestinationViewController.m
//  游谱旅行
//
//  Created by youpu on 14-7-25.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "DestinationViewController.h"

static DestinationViewController * destination = nil;

@interface DestinationViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
    NSInteger _i;
}

@property (strong,nonatomic) NSIndexPath *lastpath;
@property (strong,nonatomic) NSIndexPath *desPath;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) NSMutableArray *resultIdArray;;

@end

@implementation DestinationViewController

+ (id)shareSingle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        destination = [[self alloc] initWithNibName:nil bundle:nil];
    });
    
    return destination;
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
    if (!_indicator.isAnimating) {
        //添加菊花
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicator setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]];
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
    
    if ([_titleStr isEqualToString:@"目的地"]) {
        [self.delegate desColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]];
    }else{
    
        [self.delegate desColor:[UIColor colorWithRed:224/255.0 green:89/255.0 blue:60/255.0 alpha:1]];
    }
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

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    CGRect frame = self.search.frame;
    frame.origin.y = 0;
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
    
    [self.view addSubview:_destinationTable];
    
    self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(160, 44, 160, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStylePlain];
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.scrollEnabled = YES;
    _rightTable.hidden = YES;
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
        [view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1]];
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
        if (indexPath.row == 0)
        {
            NSDictionary * dic = [self.dictionary objectForKey:@"data"];
            NSArray * array = [dic objectForKey:@"toCity"];
            NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
            [_rightTable setHidden:YES];
            [self.delegate destination:[dictionary objectForKey:@"name"]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            if (_desPath.row != indexPath.row) {
                _lastpath =nil;
                
            }
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
        
        _desPath = indexPath;
        
        
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
            if (![mainId isEqualToString:@""]) {
                NSDictionary * name = [NSDictionary dictionaryWithObjectsAndKeys:mainId,@"string",nil];
                SingleClass * single  = [SingleClass singleClass];
                [single.singleDic addEntriesFromDictionary:name];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
            }
      
        }
        else
        {
            NSString * string = [dic objectForKey:@"id"];
            NSDictionary * name = [NSDictionary dictionaryWithObjectsAndKeys:string,@"string",nil];
            SingleClass * single  = [SingleClass singleClass];
            [single.singleDic addEntriesFromDictionary:name];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
        }

        }
    else{
        
        NSString * string = [self.resultArray objectAtIndex:indexPath.row];
        for (NSDictionary * idDic  in _resultIdArray) {
            NSString * str = [idDic objectForKey:@"cityName"];
            if ([str isEqualToString:string]) {
                
                NSDictionary * name = [NSDictionary dictionaryWithObjectsAndKeys:[idDic objectForKey:@"cityId"],@"string",nil];
                SingleClass * single  = [SingleClass singleClass];
                [single.singleDic addEntriesFromDictionary:name];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qzy" object:nil userInfo:single.singleDic];
            }
        }
    
        NSString * cityName = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.delegate destination:cityName];
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
