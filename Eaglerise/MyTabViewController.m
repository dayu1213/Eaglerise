//
//  MyTabViewController.m
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "MyTabViewController.h"
#import "DeviceViewController.h"
#import "ControlViewController.h"
#import "SettingViewController.h"
#import "OverViewController.h"

@interface MyTabViewController ()<UIScrollViewDelegate>
{
    /**滑动HMSegmentedControl*/
    long huaHMSegmentedControl;
    UIColor * wordColor;
    UIColor * wordSelColor;
    UIView * dataView;
}
@property (nonatomic,strong) UIScrollView * contentSView;


@property (nonatomic,strong)  UIButton *DeviceBtn;

@property (nonatomic,strong)  UIButton *ControlBtn;

@property (nonatomic,strong)  UIButton *SettingBtn;

@property (nonatomic,strong)  UIButton *OverBtn;
@property (nonatomic,strong)  UIButton *RefreshBtn;

@property (nonatomic,strong) DeviceViewController *DeviceView;

@property (nonatomic,strong) ControlViewController *ControlView;
@property (nonatomic,strong) SettingViewController *SettingView;

@property (nonatomic,strong) OverViewController *OverView;
@end

@implementation MyTabViewController
@synthesize DeviceView,ControlView,SettingView,OverView;
@synthesize DeviceBtn,ControlBtn,SettingBtn,OverBtn,RefreshBtn;

-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OthertabAction:) name:@"tabAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Othertab2Action:) name:@"tab2Action" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DisconnectAction:) name:@"Disconnect" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:(float)242/255.0 green:(float)242/255.0 blue:(float)242/255.0 alpha:1.0f];
    [self iv];
    [self lc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark --
#pragma mark - 初始化页面元素
/**
 *初始化参数
 */
-(void)iv
{
    wordColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    wordSelColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
}

/**
 *加载控件
 */
-(void)lc
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, 54)];
    bgView.backgroundColor =[UIColor colorWithRed:(float)253/255.0 green:(float)253/255.0 blue:(float)253/255.0 alpha:1.0f];
    [self.view addSubview:bgView];
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Device_Wdith, 34)];
    Lbl.text = @"伊戈尔智能控制";
    Lbl.font = [UIFont boldSystemFontOfSize:18];
    Lbl.backgroundColor = [UIColor colorWithRed:(float)253/255.0 green:(float)253/255.0 blue:(float)253/255.0 alpha:1.0f];
    Lbl.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;

    [bgView addSubview:Lbl];
    
    RefreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-60, 20, 55, 34)];
    
    
    [RefreshBtn setTitle:@"Refresh" forState:UIControlStateNormal];
    [RefreshBtn setTitleColor:wordSelColor forState:UIControlStateNormal];
    [RefreshBtn setTitleColor:wordColor forState:UIControlStateHighlighted];
    [RefreshBtn addTarget:self action:@selector(RefreshAction) forControlEvents:UIControlEventTouchUpInside];
    [RefreshBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [bgView addSubview:RefreshBtn];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 52.5, Device_Wdith, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [self.view addSubview:Lbl];

    _contentSView = [[UIScrollView alloc] init];
    
    _contentSView.frame=CGRectMake(0, 54, Device_Wdith, Device_Height-83);
    [_contentSView setContentSize: CGSizeMake(Device_Wdith*4, Device_Height-84)];
//    _contentSView.frame=CGRectMake(0, 54, Device_Wdith, Device_Height-34);
//    [_contentSView setContentSize: CGSizeMake(Device_Wdith*4, Device_Height-35)];

    [_contentSView setPagingEnabled:YES];
    [_contentSView setScrollEnabled:NO];
    
    [_contentSView setShowsHorizontalScrollIndicator:NO];
    [_contentSView setDelegate:self];
    [self.view addSubview:_contentSView];
    
    
    DeviceView = [[DeviceViewController alloc] init];
    DeviceView.view.frame = CGRectMake(0, 0, Device_Wdith, Device_Height-84);
    
    
    
    [_contentSView addSubview:DeviceView.view];
    
    ControlView = [[ControlViewController alloc] init];
    ControlView.view.frame = CGRectMake(Device_Wdith, 0, Device_Wdith, Device_Height-84);
    [_contentSView addSubview:ControlView.view];
    
    SettingView = [[SettingViewController alloc] init];
    SettingView.view.frame = CGRectMake(Device_Wdith*2, 0, Device_Wdith, Device_Height-84);
    
    [_contentSView addSubview:SettingView.view];
    
    OverView = [[OverViewController alloc] init];
    OverView.view.frame = CGRectMake(Device_Wdith*3, 0, Device_Wdith, Device_Height-84);
    
    [_contentSView addSubview:OverView.view];
    
    
    float y = _contentSView.frame.origin.y+CGRectGetHeight(_contentSView.frame);
    UILabel * hrLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, y, Device_Wdith, 1)];
    hrLbl.backgroundColor = [UIColor colorWithRed:(float)182/255.0 green:(float)182/255.0 blue:(float)182/255.0 alpha:1.0f];
    [self.view addSubview:hrLbl];
    y = hrLbl.frame.origin.y+CGRectGetHeight(hrLbl.frame);
    
    
    DeviceBtn=[[UIButton alloc]init];
    DeviceBtn.frame=CGRectMake(0, y, Device_Wdith/4, 49);
    

    [DeviceBtn setTitle:@"Device" forState:UIControlStateNormal];
    [DeviceBtn setTitleColor:wordColor forState:UIControlStateNormal];
    [DeviceBtn setTitleColor:wordSelColor forState:UIControlStateSelected];
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake((Device_Wdith/4-28
                                                                       )/2, 4, 28, 28)];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Device"  ofType:@"png"];
//    ImgView.image=[[UIImage alloc] initWithContentsOfFile:imagePath];
    ImgView.image=[UIImage imageNamed:@"DeviceSel"];
    ImgView.tag=101;
    [DeviceBtn addSubview:ImgView];

//    [DeviceBtn setBackgroundColor:[UIColor colorWithRed:0.114 green:0.459 blue:0.682 alpha:1]];
    [DeviceBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [DeviceBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    DeviceBtn.titleEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0);
    DeviceBtn.tag=100;
    [self.view addSubview:DeviceBtn];
    DeviceBtn.selected = YES;
   
    ControlBtn=[[UIButton alloc]init];
    ControlBtn.frame=CGRectMake(Device_Wdith/4, y, Device_Wdith/4, 49);

    [ControlBtn setTitle:@"Control" forState:UIControlStateNormal];
    [ControlBtn setTitleColor:wordColor forState:UIControlStateNormal];
    [ControlBtn setTitleColor:wordSelColor forState:UIControlStateSelected];
    
    ImgView=[[UIImageView alloc]initWithFrame:CGRectMake((Device_Wdith/4-28
                                                          )/2, 4, 28, 28)];
//    imagePath = [[NSBundle mainBundle] pathForResource:@"Control"  ofType:@"png"];
//    ImgView.image=[[UIImage alloc] initWithContentsOfFile:imagePath];
    ImgView.image=[UIImage imageNamed:@"Control"];
    ImgView.tag=103;
    [ControlBtn addSubview:ImgView];

//    [ControlBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
    [ControlBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [ControlBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    ControlBtn.titleEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0);
    ControlBtn.tag=102;
    [self.view addSubview:ControlBtn];
    
  
    SettingBtn=[[UIButton alloc]init];
    SettingBtn.frame=CGRectMake(Device_Wdith/4*2, y, Device_Wdith/4, 49);
    

    [SettingBtn setTitle:@"Setting" forState:UIControlStateNormal];
    [SettingBtn setTitleColor:wordColor forState:UIControlStateNormal];
    [SettingBtn setTitleColor:wordSelColor forState:UIControlStateSelected];
    
    ImgView=[[UIImageView alloc]initWithFrame:CGRectMake((Device_Wdith/4-28
                                                          )/2, 4, 28, 28)];
//    imagePath = [[NSBundle mainBundle] pathForResource:@"Setting"  ofType:@"png"];
//    ImgView.image=[[UIImage alloc] initWithContentsOfFile:imagePath];
    ImgView.image=[UIImage imageNamed:@"Setting"];
    ImgView.tag=105;
    [SettingBtn addSubview:ImgView];

//    [SettingBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
    [SettingBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [SettingBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    SettingBtn.titleEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0);
    SettingBtn.tag=104;
    [self.view addSubview:SettingBtn];
    
    
    OverBtn=[[UIButton alloc]init];
    OverBtn.frame=CGRectMake(Device_Wdith/4*3, y, Device_Wdith/4, 49);
    
    
    [OverBtn setTitle:@"Overview" forState:UIControlStateNormal];
    [OverBtn setTitleColor:wordColor forState:UIControlStateNormal];
    [OverBtn setTitleColor:wordSelColor forState:UIControlStateSelected];
    
    ImgView=[[UIImageView alloc]initWithFrame:CGRectMake((Device_Wdith/4-28
                                                          )/2, 4, 28, 28)];
//    imagePath = [[NSBundle mainBundle] pathForResource:@"Overview"  ofType:@"png"];
//    ImgView.image=[[UIImage alloc] initWithContentsOfFile:imagePath];
    ImgView.image=[UIImage imageNamed:@"Overview"];
    ImgView.tag=107;
    [OverBtn addSubview:ImgView];
    
//    [OverBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
    [OverBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [OverBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    OverBtn.titleEdgeInsets = UIEdgeInsetsMake(32, 0, 0, 0);
    OverBtn.tag=106;
    [self.view addSubview:OverBtn];
    [self.view bringSubviewToFront:_contentSView];
//    _contentSView.frame=CGRectMake(0, 54, Device_Wdith, Device_Height-34);
//    [_contentSView setContentSize: CGSizeMake(Device_Wdith*4, Device_Height-35)];
    
}
#pragma  mark--
#pragma  mark--滑动事件

/**列表切换*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    if (scrollView.tag == 101) {
//    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
//    NSInteger page = scrollView.contentOffset.x / pageWidth;
//    
//    huaHMSegmentedControl = (int)page;
//    switch (huaHMSegmentedControl) {
//        case 0:
//            
//            DeviceBtn.selected = YES;
//            ControlBtn.selected = NO;
//            SettingBtn.selected = NO;
//            OverBtn.selected = NO;
//
//            break;
//            
//        case 1:
//            
//            DeviceBtn.selected = NO;
//            ControlBtn.selected = YES;
//            SettingBtn.selected = NO;
//            OverBtn.selected = NO;
//
//            break;
//        case 2:
//            
//            DeviceBtn.selected = NO;
//            ControlBtn.selected = NO;
//            SettingBtn.selected = YES;
//            OverBtn.selected = NO;
//
//            break;
//        case 3:
//            
//            DeviceBtn.selected = NO;
//            ControlBtn.selected = NO;
//            SettingBtn.selected = NO;
//            OverBtn.selected = YES;
//            
//            break;
//        default:
//            break;
//            
//    }
    
    
}


#pragma mark --
#pragma mark --点击事件
- (void)tabAction:(id)sender
{
    UIButton *tempBtn=(UIButton *)sender;
    long num = 0;
    UIImageView * tempImg,* tempImg2,* tempImg3,* tempImg4;
    tempImg = (UIImageView *)[DeviceBtn viewWithTag:101];
    tempImg2 = (UIImageView *)[ControlBtn viewWithTag:103];
    tempImg3 = (UIImageView *)[SettingBtn viewWithTag:105];
    tempImg4 = (UIImageView *)[OverBtn viewWithTag:107];
    switch (tempBtn.tag) {
        case 100:
        {
             RefreshBtn.hidden = NO;
            num=0;
            DeviceBtn.selected = YES;
            ControlBtn.selected = NO;
            SettingBtn.selected = NO;
            OverBtn.selected = NO;
            
            [tempImg setImage:[UIImage imageNamed:@"DeviceSel"]];
            [tempImg2 setImage:[UIImage imageNamed:@"Control"]];
            [tempImg3 setImage:[UIImage imageNamed:@"Setting"]];
            [tempImg4 setImage:[UIImage imageNamed:@"Overview"]];
            
//            [_MainBtn setBackgroundColor:[UIColor colorWithRed:0.114 green:0.459 blue:0.682 alpha:1]];
//            [_FeedbackBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
//            [SettingBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
        }
            break;
            
        case 102:
        {
            num=1;
            DeviceBtn.selected = NO;
            ControlBtn.selected = YES;
            SettingBtn.selected = NO;
            OverBtn.selected = NO;
            
            [tempImg setImage:[UIImage imageNamed:@"Device"]];
            [tempImg2 setImage:[UIImage imageNamed:@"ControlSel"]];
            [tempImg3 setImage:[UIImage imageNamed:@"Setting"]];
            [tempImg4 setImage:[UIImage imageNamed:@"Overview"]];
//            [_MainBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
//            [_FeedbackBtn setBackgroundColor:[UIColor colorWithRed:0.114 green:0.459 blue:0.682 alpha:1]];
//            [SettingBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
            
            //            [tempImg setImage:grayLineImage];
            //            [tempImg2 setImage:blueLineImage];
            //            [_NoteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [_AbnormalDetailBtn setTitleColor:[UIColor colorWithRed:0.318 green:0.733 blue:0.965 alpha:1] forState:UIControlStateNormal];
        }
            break;
        case 104:
            num=2;
//            [_MainBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
//            [_FeedbackBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
//            [SettingBtn setBackgroundColor:[UIColor colorWithRed:0.114 green:0.459 blue:0.682 alpha:1]];
            DeviceBtn.selected = NO;
            ControlBtn.selected = NO;
            SettingBtn.selected = YES;
            OverBtn.selected = NO;
            
            [tempImg setImage:[UIImage imageNamed:@"Device"]];
            [tempImg2 setImage:[UIImage imageNamed:@"Control"]];
            [tempImg3 setImage:[UIImage imageNamed:@"SettingSel"]];
            [tempImg4 setImage:[UIImage imageNamed:@"Overview"]];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSetting" object:self userInfo:nil];
            
            break;
        case 106:
            num=3;
            //            [_MainBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
            //            [_FeedbackBtn setBackgroundColor:[UIColor colorWithRed:0.192 green:0.529 blue:0.773 alpha:1]];
            //            [SettingBtn setBackgroundColor:[UIColor colorWithRed:0.114 green:0.459 blue:0.682 alpha:1]];
            DeviceBtn.selected = NO;
            ControlBtn.selected = NO;
            SettingBtn.selected = NO;
            OverBtn.selected = YES;
            [tempImg setImage:[UIImage imageNamed:@"Device"]];
            [tempImg2 setImage:[UIImage imageNamed:@"Control"]];
            [tempImg3 setImage:[UIImage imageNamed:@"Setting"]];
            [tempImg4 setImage:[UIImage imageNamed:@"OverviewSel"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadOverView" object:self userInfo:nil];
            break;
        default:
            break;
    }
    if (num !=0) {
        RefreshBtn.hidden = YES;
    }
    huaHMSegmentedControl = num;
    [self.contentSView scrollRectToVisible:CGRectMake(Device_Wdith * num, 0, Device_Wdith, Device_Height-44) animated:YES];
    
    
}
//连接硬件设备
-(void)OthertabAction:(NSNotification *)notification
{
    long num = 1;
    UIImageView * tempImg,* tempImg2,* tempImg3,* tempImg4;
    tempImg = (UIImageView *)[DeviceBtn viewWithTag:101];
    tempImg2 = (UIImageView *)[ControlBtn viewWithTag:103];
    tempImg3 = (UIImageView *)[SettingBtn viewWithTag:105];
    tempImg4 = (UIImageView *)[OverBtn viewWithTag:107];

   
            DeviceBtn.selected = NO;
            ControlBtn.selected = YES;
            SettingBtn.selected = NO;
            OverBtn.selected = NO;
            
            [tempImg setImage:[UIImage imageNamed:@"Device"]];
            [tempImg2 setImage:[UIImage imageNamed:@"ControlSel"]];
            [tempImg3 setImage:[UIImage imageNamed:@"Setting"]];
            [tempImg4 setImage:[UIImage imageNamed:@"Overview"]];
     RefreshBtn.hidden = YES;
    huaHMSegmentedControl = num;
    [self.contentSView scrollRectToVisible:CGRectMake(Device_Wdith * num, 0, Device_Wdith, Device_Height-44) animated:YES];
    NSDictionary * temp = notification.userInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ld" object:self userInfo:[temp copy]];
    
    dataView = [[UIView alloc] initWithFrame:self.view.frame];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Device_Wdith, 200)];
    
    label.text = @"Are connected, please wait a moment";
    label.center = self.view.center;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    [dataView addSubview:label];
    dataView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:dataView];
    
    [self performSelector:@selector(moveView) withObject:nil afterDelay:5.0f];
    
}

- (void)moveView{

    [dataView removeFromSuperview];
}

-(void)Othertab2Action:(NSNotification *)notification
{
    long num = 0;
    UIImageView * tempImg,* tempImg2,* tempImg3,* tempImg4;
    tempImg = (UIImageView *)[DeviceBtn viewWithTag:101];
    tempImg2 = (UIImageView *)[ControlBtn viewWithTag:103];
    tempImg3 = (UIImageView *)[SettingBtn viewWithTag:105];
    tempImg4 = (UIImageView *)[OverBtn viewWithTag:107];
    
    
    DeviceBtn.selected = YES;
    ControlBtn.selected = NO;
    SettingBtn.selected = NO;
    OverBtn.selected = NO;
    
    [tempImg setImage:[UIImage imageNamed:@"DeviceSel"]];
    [tempImg2 setImage:[UIImage imageNamed:@"Control"]];
    [tempImg3 setImage:[UIImage imageNamed:@"Setting"]];
    [tempImg4 setImage:[UIImage imageNamed:@"Overview"]];
     RefreshBtn.hidden = NO;
    huaHMSegmentedControl = num;
    [self.contentSView scrollRectToVisible:CGRectMake(Device_Wdith * num, 0, Device_Wdith, Device_Height-44) animated:YES];
   
    
}

-(void)DisconnectAction:(NSNotification *)notification
{
    NSDictionary * temp = notification.userInfo;
    switch ([[temp objectForKey:@"bool"]integerValue]) {
        case 0:
            _contentSView.frame=CGRectMake(0, 54, Device_Wdith, Device_Height-83);
            [_contentSView setContentSize: CGSizeMake(Device_Wdith*4, Device_Height-84)];
            
            break;
        case  1:
            RefreshBtn.hidden = NO;
            _contentSView.frame=CGRectMake(0, 54, Device_Wdith, Device_Height-34);
            [_contentSView setContentSize: CGSizeMake(Device_Wdith*4, Device_Height-35)];
            huaHMSegmentedControl = 0;
            [self.contentSView scrollRectToVisible:CGRectMake(Device_Wdith * 0, 0, Device_Wdith, Device_Height-44) animated:YES];
            break;
        default:
            break;
    }
    
}
/**刷新设备列表*/
-(void)RefreshAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:self userInfo:nil];
}
@end
