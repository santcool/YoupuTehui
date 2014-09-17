//
//  IndividualViewController.m
//  游谱旅行
//
//  Created by youpu on 14-8-7.
//  Copyright (c) 2014年 youpu. All rights reserved.
//

#import "IndividualViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface IndividualViewController ()
{
    UIActivityIndicatorView * _indicator;//菊花
}

@property (nonatomic, strong) UINavigationController * liveNavigation;
@property (nonatomic, strong) UINavigationController * sexNavigation;
@property (nonatomic, strong) UINavigationController * favoriteNavigation;

@end

@implementation IndividualViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.array = [NSArray arrayWithObjects:@"头像",@"昵称",@"手机号",@"现居住地址", nil];
        self.downArray = [NSArray arrayWithObjects:@"生日",@"性别",@"个性签名",@"旅行偏好", nil];
        self.qitaArray= [NSArray arrayWithObjects:@"修改密码",@"关于我们",@"意见反馈", nil];
        self.userInfoDic = [[NSMutableDictionary alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dianhuahaoma:) name:@"qwer" object:nil];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self qzy];

    [self createTableView];
    
    [self netWorking];

    
}

-(void)dianhuahaoma:(NSNotification *)noti{
    
    _mobileNumber = [[noti userInfo]objectForKey:@"dianhua"];
    [_individualTable reloadData];
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

-(void)qzy{
    
    self.title = @"个人设置";
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:70/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backActon)];
    
    UIColor * cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    
}

-(void)backActon{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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

#pragma mark
#pragma mark -----------------------------用户信息
-(void)netWorking{
    
    [self addIndicator];
    //获取当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    
    //加密规则
    NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
    NSString * memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
    NSString * qzy = [self md5:QZY];
    NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
    NSString * qaz = [self md5:qwe];
    
    //接口拼接
    NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
    memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
    NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kUserInfoUrl,time];
    
    NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
    NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
    NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
    NSLog(@"%@",finally);
    
    [ConnectModel connectWithParmaters:nil url:finally style: kConnectGetType finished:^(id result) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        [self.userInfoDic addEntriesFromDictionary:dic];
        
        _myPicture =[[_userInfoDic objectForKey:@"data"] objectForKey:@"picPath"];
        _myName =[[_userInfoDic objectForKey:@"data"] objectForKey:@"nickName"];
        _mobileNumber =[[_userInfoDic objectForKey:@"data"] objectForKey:@"mobile"];
        _address =[[_userInfoDic objectForKey:@"data"] objectForKey:@"city"];
        _birth =[[_userInfoDic objectForKey:@"data"] objectForKey:@"memberBrithday"];
        _sex =[[_userInfoDic objectForKey:@"data"] objectForKey:@"genderValue"];
        _character =[[_userInfoDic objectForKey:@"data"] objectForKey:@"qualification"];
        _favorite =[[[_userInfoDic objectForKey:@"data"] objectForKey:@"travelTypeName"]stringByReplacingOccurrencesOfString:@" " withString:@","];
        if ([[[_userInfoDic objectForKey:@"data"] objectForKey:@"email"]isEqualToString:@""]) {
            _emailStr =[[_userInfoDic objectForKey:@"data"] objectForKey:@"userName"];
        }else{
        _emailStr =[[_userInfoDic objectForKey:@"data"] objectForKey:@"email"];
        }
        
        [_individualTable reloadData];
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        
    }];    
}

#pragma mark
#pragma mark ---------------------协议传值
-(void)names:(NSString *)name{
    
    _myName = name;
    [_individualTable reloadData];
    
}
-(void)address:(NSString *)address{
    _address = address;
   [_individualTable reloadData];

}
-(void)birth:(NSString *)birth{

    _birth = birth;
    [_individualTable reloadData];
    
}
-(void)sex:(NSString *)sex{
    
    _sex = sex;
    [_individualTable reloadData];
}
-(void)character:(NSString *)charecter{
    
    _character = charecter;
    [_individualTable reloadData];
    
}
-(void)favorite:(NSArray *)favorite{
    
    _favorite = nil;
    for (int i = 0; i < [favorite count]; i++) {
         NSString * string =[favorite objectAtIndex:i];
            if (self.favorite==nil) {
                self.favorite = [NSString stringWithFormat:@"%@",string];
            }else{
                self.favorite  =[NSString stringWithFormat:@"%@%@%@",_favorite,@",",string];
            }
    }
    [_individualTable reloadData];
    
}
#pragma mark
#pragma mark ------------------ 隐藏tableview多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark
#pragma mark - 创建tableview
-(void)createTableView{
    
    self.individualTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _individualTable.dataSource = self;
    _individualTable.delegate = self;
    [_individualTable setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.11]];
    [self setExtraCellLineHidden:_individualTable];
    [self.view addSubview:_individualTable];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        [_individualTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
}
#pragma mark
#pragma mark ------------------退出登陆
-(void)exit{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"memberId"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"credential"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tab.selectedIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

#pragma mark
#pragma mark 协议啊啊啊啊啊啊啊啊
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return [_array count];
    }else if (section==1){
      return [_downArray count];
    }else if (section==2){
       return [_qitaArray count] ;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 75;
    }else if (section==1){
        return 20;
    }else if(section==2){
        return 20;
    }else{
        return 60;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        UIView * view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
        [view setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.view.frame.size.width, 20)];
        [lable setText:@"您当前账户信息为:"];
        [lable setTextColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1]];
        [lable setFont:[UIFont systemFontOfSize:16]];
        [view addSubview:lable];
        UILabel * userLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.view.frame.size.width, 20)];
        [userLable setText:_emailStr];
        [lable setTextColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1]];
        [userLable setFont:[UIFont systemFontOfSize:18]];
        [view addSubview:userLable];
        return view;
    }else if (section==1 || section==2){
        
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [lable setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
        return lable;
    }else{
        UIView * view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        [view setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
        UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"橙条长"] forState:UIControlStateNormal];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = [self.array objectAtIndex:indexPath.row];
    if (indexPath.section==0 && indexPath.row==0) {
        UIFont *tfont = [UIFont systemFontOfSize:14.0];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
        CGSize sizeText = [str boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        return sizeText.height+50;
    }
    if (indexPath.section==1 && indexPath.row==2) {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize sizeText = [_character boundingRectWithSize:CGSizeMake(190, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        if (sizeText.height<=30) {
            return 40;
        }else if(sizeText.height<=50){
            return 60;
        }else if (sizeText.height<=70){
            return 80;
        }else if(sizeText.height >70){
            return 100;
        }
    }

    return  40;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIden = @"cell";
    IndividualTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[IndividualTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];

    }
    if (indexPath.section==0) {
        [cell.textLabel setText:[_array objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case 0:{
                if ([_myPicture isEqualToString:@""])
                {
                    [cell.image setImage:[UIImage imageNamed:@"默认头像"]];
                }
                else
                {
                    if (picture != nil)
                   {
                    cell.image.image = picture;
                   }
                    else
                   {
                    [cell.image setImageWithURL:[NSURL URLWithString:_myPicture]];
                   }
                }
                [cell.button setFrame:CGRectMake(295, 25, 20, 20)];
            }
                break;
            case 1:
                [cell.lable setText:_myName];
                break;
            case 2:
                
                [cell.lable setText:_mobileNumber];
                
                break;
            case 3:
                [cell.lable setText:_address];
                break;
            default:
                break;
        }
        
    } if (indexPath.section==1){
        [cell.textLabel setText:[_downArray objectAtIndex:indexPath.row]];
        switch (indexPath.row)
        {
            case 0:
                [cell.lable setText:_birth];
                break;
            case 1:
                [cell.lable setText:_sex];
                break;
            case 2:
            {
                if (_character.length<=13) {
                    [cell.lable setFrame:CGRectMake(100, 5, 190, 30)];
                }else if(_character.length<=26){
                    [cell.lable setFrame:CGRectMake(100, 5, 190, 50)];
                    [cell.lable setTextAlignment:NSTextAlignmentLeft];
                    [cell.button setFrame:CGRectMake(295, 20, 20, 20)];
                }else if(_character.length<=39&&_character.length>26){
                    [cell.lable setFrame:CGRectMake(100, 0, 190, 80)];
                    [cell.lable setTextAlignment:NSTextAlignmentLeft];
                    [cell.button setFrame:CGRectMake(295, 30, 20, 20)];
                }else{
                    [cell.lable setFrame:CGRectMake(100, -10, 190, 100)];
                    [cell.lable setTextAlignment:NSTextAlignmentLeft];
                    [cell.button setFrame:CGRectMake(295, 30, 20, 20)];
                }
                [cell.lable setText:_character];
            }

                break;
            case 3:
                [cell.lable setText:_favorite];
                break;
            default:
                break;
        }
        
    }if (indexPath.section==2){
        [cell.textLabel setText:[_qitaArray objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case 2:
                [cell.image setImage:[UIImage imageNamed:@"qwe"]];
                [cell.button setFrame:CGRectMake(295, 10, 20, 20)];
                break;
                
            default:
                break;
        }
    }
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        NSString * string = [self.array objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                UIActionSheet * photoBtn = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
                [photoBtn setActionSheetStyle:UIActionSheetStyleBlackOpaque];
                [photoBtn showInView:[self.view window]];
            }
                
                break;
            case 1:
            {
                MyNameViewController * name = [[MyNameViewController alloc] init];
                name.delegate = self;
                name.name= string;
                name.myName = _myName;
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:name];
                [self presentViewController:na animated:NO completion:nil];
                
            }
                break;
                
            case 2:
            {
                MobileViewController  *mobile = [[MobileViewController alloc] init];
                mobile.phoneNumber = string;
                mobile.nowNumber = _mobileNumber;
                [self.navigationController pushViewController:mobile animated:NO];
                
            }
                break;
            case 3:
            {
                LiveViewController * live = [[LiveViewController alloc]init];
                live.delegate = self;
                live.nowAddress = string;
                live.liveHere = _address;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:live];
                [self presentViewController:na animated:NO completion:nil];
            }
                break;
            default:
                break;
        }

    }if (indexPath.section==1){
    
    NSString * string = [self.downArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            BirthdayViewController * name = [[BirthdayViewController alloc] init];
            name.delegate = self;
            name.name= string;
            name.birthday = self.birth;
            UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:name];
            [self presentViewController:na animated:NO completion:nil];
        
        }

            break;
        case 1:
        {
            SexViewController *sexs = [[SexViewController alloc]init];
            sexs.delegate = self;
            sexs.sex = string;
            sexs.sexAndLove = _sex;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:sexs];
            [self presentViewController:na animated:NO completion:nil];
        }
            break;
            
            case 2:
        {
            CharacterViewController * cha = [[CharacterViewController alloc] init];
            cha.character = string;
            cha.delegate = self;
            cha.characterNow = self.character;
            UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:cha];
            [self presentViewController:navi animated:NO completion:nil];
        }
            break;
            
            case 3:
        {
            
            FavoriteViewController * favorite = [[FavoriteViewController alloc]init];
            favorite.favorite = string;
            favorite.delegate = self;
            favorite.favoriteNow = self.favorite;
            UINavigationController * na  = [[UINavigationController alloc] initWithRootViewController:favorite];
            [self presentViewController:na animated:NO completion:nil];

        }
            break;
        default:
            break;
      }
        
    } if (indexPath.section==2){
        
        NSString * string = [self.qitaArray objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                PassWordViewController * pass = [[PassWordViewController alloc] init];
                pass.titleName= string;
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:pass];
                [self presentViewController:na animated:NO completion:nil];
            }
                break;
            case 1:
            {
                GuanyuViewController * pass = [[GuanyuViewController alloc] init];
                pass.titleName = string;
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:pass];
                [self presentViewController:na animated:NO completion:nil];
            }
                break;
            case 2:
            {
                SuggestionViewController * suggest = [[SuggestionViewController alloc] init];
                suggest.titleName = string;
                UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:suggest];
                [self presentViewController:na animated:NO completion:nil];
            }
               break;
                
            default:
                break;
        }

    }
    
}

#pragma mark 
#pragma mark - actionsheet协议
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhotoBtn];
    }else if(buttonIndex == 1){
        [self checkPhoto];
    }else{
        
        [actionSheet didMoveToWindow];
    }
}
-(void)takePhotoBtn
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==YES) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
    
}
-(void)checkPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]==YES) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    picture=image;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将所拍照片保存到相册
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kIconUrl,time];
        
        NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
        NSLog(@"%@",finally);
        
        [ConnectModel uploadUserIcon:nil icon:UIImagePNGRepresentation(image) url:finally finished:^(id result) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            [self.individualTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                        withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else{
      
        //获取当前时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.f", a];
        
        //加密规则
        NSString *key = @"CtUyV$8MGoK8u5L*P0Q50T/b8S9iclS*LQqo";
        NSString * memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
        NSString * QZY = [NSString stringWithFormat:@"%@%@%@",memberId,timeString,key];
        NSString * qzy = [self md5:QZY];
        NSString * qwe = [NSString stringWithFormat:@"%@%@",key,qzy];
        NSString * qaz = [self md5:qwe];
        
        //接口拼接
        NSString * time = [NSString stringWithFormat:@"%@=%@%@",@"timestamp",timeString,@"&"];
        memberId = [NSString stringWithFormat:@"%@=%@%@",@"memberId",memberId,@"&"];
        NSString * lastUrl = [NSString stringWithFormat:@"%@%@",kIconUrl,time];
        
        NSString * finallyUrl = [NSString stringWithFormat:@"%@%@",lastUrl,memberId];
        NSString * sign = [NSString stringWithFormat:@"%@=%@",@"sign",qaz];
        NSString * finally = [NSString stringWithFormat:@"%@%@",finallyUrl,sign];
        NSLog(@"%@",finally);
        
        [ConnectModel uploadUserIcon:nil icon:UIImagePNGRepresentation(image) url:finally finished:^(id result) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            [self.individualTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                        withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

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
