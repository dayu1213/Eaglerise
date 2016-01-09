//
//  SettingViewController.m
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#define channelOnPeropheralView @"SettingView"
@interface SettingViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate,UIActionSheetDelegate>
{
    float textHeight;
    // Yes 为 on，ON 为off
    BOOL onOrOff;
    NSMutableArray *pickerArray,*pickerArray6;
    NSArray *pickerArray2,*pickerArray3,*pickerArray4,*pickerArray5;
    NSDateFormatter *dateFormatter;
    int CH;
    NSString *  hour;
    NSString * second;
    NSString *  hour2;
    NSString * second2;
    NSString *  hour3;
    NSString * second3;
    NSString *  hour4;
    NSString * second4;
    int WEEK;
    int MODE;
//    bool isPop;
    AppDelegate * mydelegate;
    NSUserDefaults *userdefaults;
    NSDictionary * SettingDic;
    UIActionSheet * actionSheet1,* actionSheet2,* actionSheet3;
    bool loading;
    NSString * loadName;
    int channelIndex;
    NSMutableDictionary* channelDic;
}
@property (nonatomic,strong) UITextField * deviceNameTxt,* channelTxt;
//@property (nonatomic,strong) UIPickerView *PickerView;
//@property (nonatomic,strong) UIPickerView *PickerView2;
@property (nonatomic,strong) UIScrollView * contentSView;
@property (nonatomic,strong) UILabel * SettingsLbl,* FristLbl,* SecondLbl,* ThirdLbl,* FourthLbl,* onLbl;

@property (nonatomic,strong) UIButton * TurnOnBtn,* FirstEventBtn,* SecondEventBtn,* TurnOffBtn,* TurnOnSaveBtn,* FirstEventSaveBtn,* SecondEventSaveBtn,* TurnOffSaveBtn,* ExactlyBtn,* AfterBtn,* SpecificBtn,* changeChannelBtn,* SettingsBtn;
@property (nonatomic,strong) UIView * PopView,* FirstView,* SecondView,* ThirdView,* FourthView;
@property (nonatomic,strong) UIPickerView * FristPicker;//,* SecondPicker,* ThirdPicker
@property (nonatomic,strong) UIDatePicker * FristdatePicker,* SeconddatePicker,* ThirddatePicker;
@property (nonatomic,strong) UISwitch *switchView, *switchView2;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) UISlider * Fristslider,* Secondslider,* Thirdslider;
@property (nonatomic,strong) UIImageView * ivImageV;
@property (nonatomic,strong) UIAlertView *dialog;
@property (nonatomic,retain) NSMutableDictionary *setDic;

@end

@implementation SettingViewController
@synthesize deviceNameTxt,channelTxt;
//@synthesize PickerView2;//PickerView,
@synthesize contentSView;
@synthesize  FristLbl,SecondLbl,ThirdLbl,FourthLbl,onLbl;
@synthesize TurnOnBtn,FirstEventBtn,SecondEventBtn,TurnOffBtn,TurnOnSaveBtn,FirstEventSaveBtn,SecondEventSaveBtn,TurnOffSaveBtn,ExactlyBtn,AfterBtn,SpecificBtn,changeChannelBtn,SettingsBtn;
@synthesize PopView,FirstView,SecondView,ThirdView,FourthView;
@synthesize FristPicker,FristdatePicker,SeconddatePicker,ThirddatePicker;;
@synthesize switchView,switchView2;
@synthesize Fristslider,Secondslider,Thirdslider;
@synthesize ivImageV;
@synthesize setDic;
@synthesize dialog;
-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAction:) name:@"loadSetting" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceName) name:@"updateDeviceName2" object:nil];
        mydelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self iv];
    [self lc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //设置蓝牙委托
    [self babyDelegate];
    
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
    pickerArray = [[NSMutableArray alloc]initWithObjects:@"channel 1",@"channel 2",@"channel 3",@"channel 4", nil];
    
    pickerArray2 = [[NSArray alloc]initWithObjects:@"Nightly",@"SUN/MON",@"MON/TUE",@"TUE/WED",@"WED/THU",@"THU/FRI",@"FRI/SAT",@"SAT/SUN",nil];
    
    pickerArray3 = [[NSArray alloc]initWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",nil];
    pickerArray4 = [[NSArray alloc]initWithObjects:@"0",@"15",@"30",@"45",nil];
    pickerArray5 = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",nil];
    pickerArray6 = [[NSMutableArray alloc]init];
    for(int i= 0;i<24;i++)
    {
        [pickerArray6 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    setDic = [[NSMutableDictionary alloc]init];
    if(dateFormatter==nil)
    {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"hh:mm aa"];
    userdefaults = [NSUserDefaults standardUserDefaults];
    
    SettingDic = [[NSMutableDictionary alloc]init];
    channelDic = [[NSMutableDictionary alloc]init];
    loading = NO;
    SettingDic = [NSMutableDictionary dictionaryWithDictionary:[userdefaults objectForKey:@"setting"]];
    channelIndex = 1;
    CH = 1;
    WEEK=-1;
    hour = @"3";
    second = @"0";
    hour2 = @"3";
    second2 = @"0";
    hour3 = @"3";
    second3 = @"0";
    hour4 = @"3";
    second4 = @"0";
    if ([userdefaults objectForKey:@"channel1"]!=nil) {
        [pickerArray replaceObjectAtIndex:0 withObject:[userdefaults objectForKey:@"channel1"]];
    }
    if ([userdefaults objectForKey:@"channel2"]!=nil) {
        [pickerArray replaceObjectAtIndex:1 withObject:[userdefaults objectForKey:@"channel2"]];
    }
    if ([userdefaults objectForKey:@"channel3"]!=nil) {
        [pickerArray replaceObjectAtIndex:2 withObject:[userdefaults objectForKey:@"channel3"]];
    }
    if ([userdefaults objectForKey:@"channel4"]!=nil) {
        [pickerArray replaceObjectAtIndex:3 withObject:[userdefaults objectForKey:@"channel4"]];
    }

}

/**
 *加载控件
 */
-(void)lc
{
    
   
    contentSView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, Device_Height-100)];
    [contentSView setBackgroundColor:[UIColor whiteColor]];
//    contentSView.pagingEnabled = YES;
    contentSView.delegate = self;
//    contentSView.showsVerticalScrollIndicator = NO;
//    contentSView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentSView];
    
    deviceNameTxt=[[UITextField alloc]initWithFrame:CGRectMake(20.0,0.0,Device_Wdith-40, 50)];//创建一个UITextField对象，及设置其位置及大小
    
    deviceNameTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    deviceNameTxt.textAlignment = NSTextAlignmentCenter;
    
    [deviceNameTxt setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    
    deviceNameTxt.leftViewMode=UITextFieldViewModeAlways;
    
    //    deviceNameTxt.placeholder=@"请输入关键字";//默认显示的字
    
    //    deviceNameTxt.secureTextEntry=YES;//设置成密码格式
    
    deviceNameTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    
    deviceNameTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    deviceNameTxt.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    deviceNameTxt.delegate=self;//设置委托
    deviceNameTxt.text = [userdefaults objectForKey:@"DeviceName"]!=nil?[userdefaults objectForKey:@"DeviceName"]:@"Eagleris Lighting 1";
    [contentSView addSubview:deviceNameTxt];
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 49.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    
    channelTxt=[[UITextField alloc]initWithFrame:CGRectMake(30.0,51.5,(Device_Wdith-60)/2, 50)];//创建一个UITextField对象，及设置其位置及大小
    
    channelTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    channelTxt.textAlignment = NSTextAlignmentLeft;
    
    [channelTxt setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    
    channelTxt.leftViewMode=UITextFieldViewModeAlways;
    
    //    deviceNameTxt.placeholder=@"请输入关键字";//默认显示的字
    
    //    deviceNameTxt.secureTextEntry=YES;//设置成密码格式
    
    channelTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    
    channelTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    channelTxt.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    channelTxt.delegate=self;//设置委托
    channelTxt.text = [userdefaults objectForKey:@"channel1"]!=nil?[userdefaults objectForKey:@"channel1"]:@"channel 1";
    [contentSView addSubview:channelTxt];
    changeChannelBtn = [[UIButton alloc]initWithFrame:CGRectMake(30.0+(Device_Wdith-60)/2,51.5,(Device_Wdith-60)/2, 50)];
    
    [changeChannelBtn setBackgroundColor:[UIColor clearColor]];
    [changeChannelBtn setImage:[UIImage imageNamed:@"downward"] forState:UIControlStateNormal];
//    [changeChannelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//    [changeChannelBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    changeChannelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [changeChannelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [changeChannelBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:changeChannelBtn];
//    PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 50, Device_Wdith-60, 120)];
//    //    指定Delegate
//    PickerView.delegate=self;
//    //    显示选中框
//    PickerView.showsSelectionIndicator=YES;
//    [contentSView addSubview:PickerView];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 101.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    UIButton * LoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 103, (Device_Wdith-60)/2, 40)];
    
    [LoadBtn setBackgroundColor:[UIColor clearColor]];
    [LoadBtn setTitle:@" Load Preset" forState:UIControlStateNormal];
    [LoadBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    LoadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [LoadBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [LoadBtn addTarget:self action:@selector(LoadAction) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:LoadBtn];
    
    UIButton * SaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/2, 103, (Device_Wdith-60)/2-10, 40)];
    
    [SaveBtn setBackgroundColor:[UIColor clearColor]];
    [SaveBtn setTitle:@"Save As Preset" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [SaveBtn addTarget:self action:@selector(SaveAction) forControlEvents:UIControlEventTouchUpInside];
    [SaveBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [contentSView addSubview:SaveBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 143, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 144.5, Device_Wdith-160, 40)];
    Lbl.text = @"Output Voltage";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, 151.5, 40, 30)];
    Lbl.text = @"12V";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    switchView = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, 151.5, 80.0f, 28.0f)];
    
    
    switchView.on = YES;//设置初始为ON的一边
    switchView.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [contentSView addSubview:switchView];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 151.5, 30, 30)];
    Lbl.text = @"15V";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 184.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 183, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Theses Settings for";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    Lbl.adjustsFontSizeToFitWidth = YES;
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
//    SettingsBtn = [[UILabel alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/2, 183, (Device_Wdith-60)/2, 40)];
//    SettingsLbl.text = @"Nightly";
//    SettingsLbl.backgroundColor = [UIColor clearColor];
//    [SettingsLbl setTextAlignment:NSTextAlignmentRight];
//    [SettingsLbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
//    [SettingsLbl setFont:[UIFont boldSystemFontOfSize:17]];
//    [contentSView addSubview:SettingsLbl];
    SettingsBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 183, (Device_Wdith-60), 40)];
    
    [SettingsBtn setBackgroundColor:[UIColor clearColor]];
    [SettingsBtn setTitle:@"Nightly" forState:UIControlStateNormal];
    [SettingsBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [SettingsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [SettingsBtn setImage:[UIImage imageNamed:@"downward"] forState:UIControlStateNormal];
    [SettingsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (Device_Wdith-90), 0, 0)];
    SettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [SettingsBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [SettingsBtn addTarget:self action:@selector(changeAction2) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:SettingsBtn];

    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 223, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
//    PickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 293, Device_Wdith-60, 120)];
//    //    指定Delegate
//    PickerView2.delegate=self;
//    //    显示选中框
//    PickerView2.showsSelectionIndicator=YES;
//    [contentSView addSubview:PickerView2];
    
//    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 413, Device_Wdith-60, 1.5)];
//    
//    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
//    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 224.5, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Turn on";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    TurnOnBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 224.5, (Device_Wdith-60), 40)];
    
    [TurnOnBtn setBackgroundColor:[UIColor clearColor]];
    [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
    [TurnOnBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [TurnOnBtn addTarget:self action:@selector(TurnOnAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOnBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:TurnOnBtn];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 264.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 266, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"First Event";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    FirstEventBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 266, (Device_Wdith-60), 40)];
    
    [FirstEventBtn setBackgroundColor:[UIColor clearColor]];
    [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
    [FirstEventBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    FirstEventBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [FirstEventBtn addTarget:self action:@selector(FirstEventAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstEventBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:FirstEventBtn];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 306, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 307.5, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Second Event";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    SecondEventBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 307.5, (Device_Wdith-60), 40)];
    
    [SecondEventBtn setBackgroundColor:[UIColor clearColor]];
    [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
    [SecondEventBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SecondEventBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [SecondEventBtn addTarget:self action:@selector(SecondEventAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondEventBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:SecondEventBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 347.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 349, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Turn Off";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    TurnOffBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 349, Device_Wdith-60, 40)];
    
    [TurnOffBtn setBackgroundColor:[UIColor clearColor]];
    [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
    [TurnOffBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOffBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [TurnOffBtn addTarget:self action:@selector(TurnOffAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOffBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:TurnOffBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 389, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 390.5, Device_Wdith-160, 40)];
    Lbl.text = @"Use DST";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, 397.5, 40, 30)];
    Lbl.text = @"OFF";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    switchView2 = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, 397.5, 80.0f, 28.0f)];
    
    
    switchView2.on = YES;//设置初始为ON的一边
    switchView2.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [switchView2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [contentSView addSubview:switchView2];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 397.5, 30, 30)];
    Lbl.text = @"ON";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    contentSView.contentSize = CGSizeMake(Device_Wdith, 470);
    
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    //隐藏键盘
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
////    tapGr.cancelsTouchesInView = NO;
//
//    [self.view addGestureRecognizer:tapGr];
    
    [self roadPopView];
    channelDic = [userdefaults objectForKey:@"settinglast"];
    if (channelDic != nil) {
        setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
        loadName = [userdefaults objectForKey:@"loadName"];
        [self loadMessage:setDic];
    }
}

-(void)roadPopView
{
    PopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, CGRectGetHeight(self.view.frame))];
    [PopView setBackgroundColor:[UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:0.3f]];
    //    [PopView setAlpha:0.2];
    [self.view addSubview:PopView];
    
//    //添加点击触摸手势
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
////    tapGr.cancelsTouchesInView = NO;
//    [PopView addGestureRecognizer:tapGr];
    
    FirstView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-449, Device_Wdith, 400)];
    [FirstView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
//    FirstView.center = PopView.center;
    [PopView addSubview:FirstView];
    
    onLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, 60)];
    onLbl.text = @"Turn on";
    onLbl.font = [UIFont boldSystemFontOfSize:16];
    onLbl.backgroundColor = [UIColor clearColor];
    onLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl.textAlignment = NSTextAlignmentCenter;
    
    [FirstView addSubview:onLbl];
    
    
    
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    ExactlyBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 61.5, Device_Wdith-120, 40)];
    [ExactlyBtn setTitle:@"Exactly at Sunset" forState:UIControlStateNormal];
    [ExactlyBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [ExactlyBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    ExactlyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    ExactlyBtn.backgroundColor = [UIColor clearColor];

    ExactlyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ExactlyBtn addTarget:self action:@selector(ExactlyAction:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:ExactlyBtn];
    
    ivImageV = [[UIImageView alloc]initWithFrame:CGRectMake(Device_Wdith-66, 69.5, 32, 20)];
    ivImageV.image = [UIImage imageNamed:@"duihao"];
    
    [FirstView addSubview:ivImageV];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 101.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    AfterBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 103, Device_Wdith-120, 40)];
    [AfterBtn setTitle:@"After Sunset" forState:UIControlStateNormal];
    [AfterBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [AfterBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    AfterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    AfterBtn.backgroundColor = [UIColor clearColor];
    
    AfterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [AfterBtn addTarget:self action:@selector(AfterAction:) forControlEvents:UIControlEventTouchUpInside];    [FirstView addSubview:AfterBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 143, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    SpecificBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 144.5, Device_Wdith-120, 40)];
    [SpecificBtn setTitle:@"Specific Time" forState:UIControlStateNormal];
    [SpecificBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [SpecificBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    SpecificBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    SpecificBtn.backgroundColor = [UIColor clearColor];
    
    SpecificBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [SpecificBtn addTarget:self action:@selector(SpecificAction:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:SpecificBtn];


    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 184.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    
    FristdatePicker  = [[UIDatePicker alloc]init];
    FristdatePicker.frame=CGRectMake(30, 186, Device_Wdith-60, 90);
    FristdatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    FristdatePicker.date = [NSDate date];
    FristdatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [FirstView addSubview:FristdatePicker];
    
    FristPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 186, Device_Wdith-60, 90)];
    FristPicker.delegate = self;
    FristPicker.dataSource = self;
    FristPicker.showsSelectionIndicator = YES;
    [FirstView addSubview:FristPicker];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 276, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    Fristslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 288.5, Device_Wdith-160, 20)];
    Fristslider.minimumValue = 0;
    Fristslider.maximumValue = 100;
    Fristslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Fristslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Fristslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Fristslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Fristslider addTarget:self action:@selector(FirstValue:) forControlEvents:UIControlEventValueChanged];
    
    [FirstView addSubview:Fristslider];
    
    
    FristLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 278.5, 80, 40)];
    FristLbl.text = @"0%";
    FristLbl.font = [UIFont boldSystemFontOfSize:16];
    FristLbl.backgroundColor = [UIColor clearColor];
    FristLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    FristLbl.textAlignment = NSTextAlignmentLeft;
    
    [FirstView addSubview:FristLbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 318.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    TurnOnSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 330, (Device_Wdith-60)/2, 40)];
    
    [TurnOnSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [TurnOnSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [TurnOnSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOnSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [TurnOnSaveBtn addTarget:self action:@selector(TurnOnSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOnSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [FirstView addSubview:TurnOnSaveBtn];
    
    
    SecondView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-399, Device_Wdith, 330)];
    [SecondView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
//    SecondView.center = PopView.center;
    [PopView addSubview:SecondView];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, 60)];
    Lbl.text = @"Frist Event";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    
    [SecondView addSubview:Lbl];
    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 61.5, Device_Wdith-120, 40)];
    Lbl.text = @"Starting time";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentLeft;
    
    [SecondView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 98.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    SeconddatePicker  = [[UIDatePicker alloc]init];
    SeconddatePicker.frame=CGRectMake(30, 120, Device_Wdith-60, 90);
    SeconddatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    SeconddatePicker.date = [NSDate date];
    SeconddatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [SecondView addSubview:SeconddatePicker];
    
//    SecondPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 120, Device_Wdith-60, 90)];
//    SecondPicker.delegate = self;
//    SecondPicker.dataSource = self;
//    SecondPicker.showsSelectionIndicator = YES;
//    [SecondView addSubview:SecondPicker];

 
    //-----------
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 210, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    
    Secondslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 221.5, Device_Wdith-160, 20)];
    Secondslider.minimumValue = 0;
    Secondslider.maximumValue = 100;
    Secondslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Secondslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Secondslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Secondslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Secondslider addTarget:self action:@selector(SecondValue:) forControlEvents:UIControlEventValueChanged];
    
    [SecondView addSubview:Secondslider];
    
    
    SecondLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 211.5, 80, 40)];
    SecondLbl.text = @"0%";
    SecondLbl.font = [UIFont boldSystemFontOfSize:16];
    SecondLbl.backgroundColor = [UIColor clearColor];
    SecondLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    SecondLbl.textAlignment = NSTextAlignmentLeft;
    
    [SecondView addSubview:SecondLbl];
    //------------
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 255, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    
    FirstEventSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 276.5, (Device_Wdith-60)/2, 40)];
    
    [FirstEventSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [FirstEventSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [FirstEventSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    FirstEventSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [FirstEventSaveBtn addTarget:self action:@selector(FirstEventSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstEventSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [SecondView addSubview:FirstEventSaveBtn];
    
    
    
    
    //==============
    ThirdView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-399, Device_Wdith, 330)];
    [ThirdView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
//    ThirdView.center = PopView.center;
    [PopView addSubview:ThirdView];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, 60)];
    Lbl.text = @"Second Event";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    
    [ThirdView addSubview:Lbl];
    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 61.5, Device_Wdith-120, 40)];
    Lbl.text = @"Starting time";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentLeft;
    
    [ThirdView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 98.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    ThirddatePicker  = [[UIDatePicker alloc]init];
    ThirddatePicker.frame=CGRectMake(30, 100, Device_Wdith-60, 90);
    ThirddatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    ThirddatePicker.date = [NSDate date];
    ThirddatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [ThirdView addSubview:ThirddatePicker];
    
//    ThirdPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 100, Device_Wdith-60, 90)];
//    ThirdPicker.delegate = self;
//    ThirdPicker.dataSource = self;
//    ThirdPicker.showsSelectionIndicator = YES;
//    [ThirdView addSubview:ThirdPicker];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 210, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    //---
    Thirdslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 221.5, Device_Wdith-160, 20)];
    Thirdslider.minimumValue = 0;
    Thirdslider.maximumValue = 100;
    Thirdslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Thirdslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Thirdslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Thirdslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Thirdslider addTarget:self action:@selector(ThirdValue:) forControlEvents:UIControlEventValueChanged];
    
    [ThirdView addSubview:Thirdslider];
    
    
    ThirdLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 211.5, 80, 40)];
    ThirdLbl.text = @"0%";
    ThirdLbl.font = [UIFont boldSystemFontOfSize:16];
    ThirdLbl.backgroundColor = [UIColor clearColor];
    ThirdLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    ThirdLbl.textAlignment = NSTextAlignmentLeft;
    
    [ThirdView addSubview:ThirdLbl];

    //--/
    
   
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 255, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    
    SecondEventSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 276.5, (Device_Wdith-60)/2, 40)];
    
    [SecondEventSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [SecondEventSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [SecondEventSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SecondEventSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SecondEventSaveBtn addTarget:self action:@selector(SecondEventSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondEventSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [ThirdView addSubview:SecondEventSaveBtn];
    
    
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-40, 0, 40, 40)];
    
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:closeBtn];
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-40, 0, 40, 40)];
    
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondView addSubview:closeBtn];
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-40, 0, 40, 40)];
    
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [ThirdView addSubview:closeBtn];
    PopView.hidden = YES;
    FirstView.hidden = YES;
    SecondView.hidden = YES;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
    FristPicker.hidden = YES;
    FristdatePicker.hidden = YES;
}
#pragma mark-
#pragma mark--页面信息处理

/**
 *  获取输入框的Y坐标
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == deviceNameTxt) {
//        isPop = NO;
        textHeight=deviceNameTxt.frame.origin.y + CGRectGetHeight(deviceNameTxt.frame);
    }
        if (textField == channelTxt) {
            textHeight=channelTxt.frame.origin.y + CGRectGetHeight(channelTxt.frame);
        }
    
    
}
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    
    CGPoint keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    //自适应代码（输入法改变也可随之改变）
    if(keyboardSize.y<textHeight)
    {
        
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, -(textHeight-keyboardSize.y), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    
}
-(void)keyboardWillHide:(NSNotification *)note
{
    
    //    NSDictionary *info = [note userInfo];
    //    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //
    //    if((Device_Height-keyboardSize.height-48)<textHeight)
    //    {
    //还原
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(Device_Wdith*2, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    //    }
    
}
/**
 *	@brief	设置隐藏键盘
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    //    if (theTextField == self.remarksTxt) {
    //        [theTextField resignFirstResponder];
    //    }
    if (theTextField == deviceNameTxt) {
        [theTextField resignFirstResponder];
        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:deviceNameTxt.text,@"NameStr",  nil];
        [self getRequest:9 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];
        [userdefaults setObject:deviceNameTxt.text forKey:@"DeviceName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceName" object:nil];

    }
    if (theTextField == channelTxt) {
        [theTextField resignFirstResponder];

        [pickerArray replaceObjectAtIndex:(channelIndex-1) withObject:channelTxt.text];
        [userdefaults setObject:channelTxt.text forKey:[NSString stringWithFormat:@"channel%d",channelIndex ]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadControlTable" object:self userInfo:nil];

        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:channelTxt.text,@"NameStr",[NSString stringWithFormat:@"%d",(channelIndex-1)],@"value",  nil];
        
        [self getRequest:10 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];

        
    }
    return YES;
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
//-(void)viewTapped:(UITapGestureRecognizer*)tapGr
//{
////    NSLog(@"%@",tapGr.view);
////    if (isPop == YES) {
////         PopView.hidden = YES;
////    }
////    else
////    {
//    [deviceNameTxt resignFirstResponder];
//        [channelTxt resignFirstResponder];
////    }
//    //    [self.mobelTxt resignFirstResponder];
//   
//}

//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
//        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            //            [weakSelf insertSectionToTableView:s];
//        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        //        [weakSelf insertRowToTableView:service];
        
        
        //        if([service.UUID isEqual:@"1912"])
        //           {
        //         NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",8],@"index",weakSelf.characteristic,@"characteristic",weakSelf.currPeripheral,@"currPeripheral",nil];
        //         [weakSelf getRequest:2 requestDic:temp delegate:weakSelf];
        //           }
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //硬件返回值
        NSLog(@"--1--characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
        
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

-(void)loadDataAction:(NSNotification *)notification
{
    self.currPeripheral = mydelegate.currPeripheral;
    self->baby  = mydelegate.baby;
    self.characteristic = [mydelegate.characteristics objectAtIndex:1];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == dialog) {
        if (buttonIndex == 1) {
            
            
            
            if ([[[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] >0) {
                if (setDic != nil) {
                    [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
                }

                [SettingDic setValue:channelDic forKey:[alertView textFieldAtIndex:0].text];
                [userdefaults setObject:SettingDic forKey:@"setting"];
                [userdefaults setObject:channelDic forKey:@"settinglast"];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"Please enter a correct name"];
                
            }
        }

    }
    else
    {
        if (buttonIndex == 0) {
            
            [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
            
            [SettingDic setValue:channelDic forKey:loadName];
            [userdefaults setObject:SettingDic forKey:@"setting"];
        }
        else
        {
            dialog = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[dialog textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeDefault];
            [[dialog textFieldAtIndex:0] setPlaceholder:@"Name"];
            [[dialog textFieldAtIndex:0] setSecureTextEntry:NO];
            [dialog show];
        }

    }
}

//#pragma mark -
//#pragma mark Picker Date Source Methods
//
////返回显示的列数
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
////返回当前列显示的行数
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
////    if (pickerView == PickerView) {
////        return [pickerArray count];
////    }
////    else
////    {
//        return [pickerArray2 count];
////    }
//}
//
//#pragma mark Picker Delegate Methods
//
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
////    if (pickerView == PickerView) {
////        return [pickerArray objectAtIndex:row];
////    }
////    else
////    {
//        return [pickerArray2 objectAtIndex:row];
////    }
//    
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        // Setup label properties - frame, font, colors etc
//        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.minimumFontSize = 8;
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//        [pickerLabel setTextColor:[UIColor blackColor]];
//    }
//    // Fill the label text here
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}
//
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    UILabel* pickerLabel;
////    if (pickerView == PickerView) {
////        pickerLabel = (UILabel *)[PickerView viewForRow:row forComponent:component];
////        
////        
////        
////    }
////    else
////    {
//        pickerLabel = (UILabel *)[PickerView2 viewForRow:row forComponent:component];
////        SettingsLbl.text = pickerLabel.text;
//    [SettingsBtn setTitle:pickerLabel.text forState:UIControlStateNormal];
//        WEEK = row;
//        
//        NSArray *keys = [SettingDic allKeys];
//        if(keys.count>0)
//        {
//        setDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(row)]]];
//        loadName = [keys objectAtIndex:(row)];
//        bool full = NO;
//        
//        
//        NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value5"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//        
//        temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value5"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//
//        
//        temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value5"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//
//        
//        temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value4"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//
//        
//        loading = full;
//        }
////    }
//    [pickerLabel setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
//    [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
//    CH = (int)row;
//}


#pragma mark -
#pragma mark UIPickerViewDelegate methods
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pTitle = nil;
    if (component == 0) {
        if (pickerView == FristPicker) {
            if (MODE ==1) {
                pTitle = [pickerArray5 objectAtIndex:row];
            }
            else if (MODE ==2)
            {
                if (onOrOff) {
                    pTitle = [pickerArray3 objectAtIndex:row];
                }
                else
                {
                    pTitle = [pickerArray6 objectAtIndex:row];
                    
                }
                
            }
        }
        else
        {
            pTitle = [pickerArray6 objectAtIndex:row];
        }
    }
    if (component == 1) {
        pTitle = [pickerArray4 objectAtIndex:row];
    }
//    if (component == 2) {
//        pTitle = @"PM";
//    }
    return pTitle;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    
    if (pickerView == FristPicker) {
        if (onOrOff == YES) {
            if (component == 0) {
                if (MODE ==1) {
                    hour = [pickerArray5 objectAtIndex:row];
                }
                else if (MODE ==2)
                {
                    if (onOrOff) {
                        hour = [pickerArray3 objectAtIndex:row];
                    }
                    else
                    {
                        hour = [pickerArray6 objectAtIndex:row];
                        
                    }

                }
               
                
            }
            if (component == 1) {
                second = [pickerArray4 objectAtIndex:row];
            }
            
        }
        else
        {
            if (component == 0) {
                if (MODE ==1) {
                    hour4 = [pickerArray5 objectAtIndex:row];
                }
                else if (MODE ==2)
                {
                    if (onOrOff) {
                        hour4 = [pickerArray3 objectAtIndex:row];
                    }
                    else
                    {
                        hour4 = [pickerArray6 objectAtIndex:row];
                        
                    }
                }
//                hour4 = [pickerArray3 objectAtIndex:row];
                
            }
            if (component == 1) {
                second4 = [pickerArray4 objectAtIndex:row];
            }
        }
    }
//    else if (pickerView == SecondPicker) {
//        
//        if (component == 0) {
//            hour2 = [pickerArray6 objectAtIndex:row];
//            
//        }
//        if (component == 1) {
//            second2 = [pickerArray4 objectAtIndex:row];
//        }
//        
//    }
//    else if (pickerView == ThirdPicker) {
//        
//        if (component == 0) {
//            hour3 = [pickerArray6 objectAtIndex:row];
//            
//        }
//        if (component == 1) {
//            second3 = [pickerArray4 objectAtIndex:row];
//        }
//        
//    }

}

#pragma mark -
#pragma mark UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger RCount;
    switch (component) {
        case 0:
        {
            if (pickerView == FristPicker) {
                if (MODE ==1) {
                    
                    RCount = [pickerArray5 count];
                }
                else if (MODE ==2)
                {
                    if (onOrOff) {
                        RCount = [pickerArray3 count];
                    }
                    else
                    {
                        RCount = [pickerArray6 count];
                        
                    }
                    
                }
                else
                {
                    RCount = 0;
                }
            }
            
            else
            {
                 RCount = [pickerArray6 count];
            }
        }
            break;
        case 1:
            RCount = [pickerArray4 count];

            break;
        case 2:
            RCount = 1;
            break;
        default:
            break;
    }
    return RCount;
    
    
}

#pragma mark --
#pragma mark - UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
    }
    else
    {
        if (actionSheet == actionSheet1) {
            NSArray *keys = [SettingDic allKeys];
            channelDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(buttonIndex-1)]]];
            [userdefaults setObject:channelDic forKey:@"settinglast"];
            setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
            loadName = [keys objectAtIndex:(buttonIndex-1)];
            [userdefaults setObject:loadName forKey:@"loadName"];
           [self loadMessage:setDic];
        }
        else if(actionSheet == actionSheet2)
        {
            channelTxt.text = [pickerArray objectAtIndex:(buttonIndex -1)];
            if (setDic != nil && !loading) {
                 [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
            }
            channelIndex = buttonIndex;
            CH = buttonIndex;
            setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];

            bool full = NO;
            
            
            NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value4"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
            }

            
            loading = full;

        }
        else if(actionSheet == actionSheet3)
        {
//            channelTxt.text = [pickerArray objectAtIndex:(buttonIndex -1)];
            [SettingsBtn setTitle:[pickerArray2 objectAtIndex:(buttonIndex -1)] forState:UIControlStateNormal];
 
            WEEK = (buttonIndex -2);
            
            NSArray *keys = [channelDic allKeys];
            if(keys.count>0)
            {
   
                
                setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
                loadName = [keys objectAtIndex:(buttonIndex-1)];
                
//                setDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(buttonIndex -1)]]];
//                loadName = [keys objectAtIndex:(buttonIndex -1)];
                bool full = NO;
                
                
                NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value4"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                loading = full;
            }
        }
        
        
           }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


#pragma mark -
#pragma mark --TOUCH


-(void)LoadAction
{
    SettingDic = [NSMutableDictionary dictionaryWithDictionary:[userdefaults objectForKey:@"setting"]];
    if (SettingDic.count<1) {
        [SVProgressHUD showInfoWithStatus:@"The list is empty"];
    }
    else
    {
       
        actionSheet1 = [[UIActionSheet alloc]
                       initWithTitle:@"select"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:nil];
        
        NSArray *keys = [SettingDic allKeys];
        for (int i = 0; i< SettingDic.count; i++) {
            [actionSheet1 addButtonWithTitle:[keys objectAtIndex:i] ];
            
        }
        actionSheet1.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet1 showInView:self.view];

    }
    [userdefaults objectForKey:@""];
}

-(void)SaveAction
{
    if(loading)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Select" delegate:self cancelButtonTitle:@"update" otherButtonTitles:@"save", nil];
        
        [alertView show];

    }
    else
    {
        dialog = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[dialog textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeDefault];
        [[dialog textFieldAtIndex:0] setPlaceholder:@"Name"];
        [[dialog textFieldAtIndex:0] setSecureTextEntry:NO];
        [dialog show];
    }
}
-(void)TurnOnAction
{
    onLbl.text = @"Turn on";
[ExactlyBtn setTitle:@"Exactly at Sunset" forState:UIControlStateNormal];
    [AfterBtn setTitle:@"After Sunset" forState:UIControlStateNormal];
    PopView.hidden = NO;
    onOrOff = YES;
    FirstView.hidden = NO;
    SecondView.hidden = YES;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
    Fristslider.hidden = NO;
    FristLbl.hidden = NO;
//    isPop = YES;
    if(MODE == 0)
    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = YES;
    }
    else
    {
        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
        FristdatePicker.hidden = YES;
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour=[pickerArray5 objectAtIndex:row];
        second = [pickerArray4 objectAtIndex:row2];
    }
//    else
//    {
//        FristPicker.hidden = YES;
//        
//        FristdatePicker.hidden = NO;
//    }


}

-(void)FirstEventAction
{
    PopView.hidden = NO;
//    isPop = YES;

    FirstView.hidden = YES;
    SecondView.hidden = NO;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
}

-(void)SecondEventAction
{
    PopView.hidden = NO;
//    isPop = YES;

    FirstView.hidden = YES;
    SecondView.hidden = YES;
    ThirdView.hidden = NO;
    FourthView.hidden = YES;
    
}

-(void)TurnOffAction
{
    onLbl.text = @"Turn off";
    onOrOff = NO;
//    isPop = YES;
    [ExactlyBtn setTitle:@"Exactly at Sunrise" forState:UIControlStateNormal];
    [AfterBtn setTitle:@"After Sunrise" forState:UIControlStateNormal];

    PopView.hidden = NO;
    
    FirstView.hidden = NO;
    SecondView.hidden = YES;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
    Fristslider.hidden = YES;
    if(MODE == 0)
    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = YES;
    }
    else if(MODE == 1)
    {
        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
        FristdatePicker.hidden = YES;
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour4=[pickerArray5 objectAtIndex:row];
        second4 = [pickerArray4 objectAtIndex:row2];
    }
    else
    {
        FristPicker.hidden = YES;

        FristdatePicker.hidden = NO;
    }
    
    FristLbl.hidden = YES;
}

-(void)switchAction:(id)sender
{
    UISwitch * switchw = (UISwitch *)sender;
    int on = 0;
    if (switchw == switchView) {
        
        if (switchw.on) {
            on = 1;
            
        }
        else
        {
            
            on = 0;
            
        }
        if(self.currPeripheral != nil &&self.characteristic != nil)
        {
//            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",on],@"value2",  nil];
            [self getRequest:5 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            
           [setDic setObject:temp forKey:@"ov"];
            
        }
    }
    if (switchw == switchView2) {
        NSDictionary * temp;
        if (switchw.on) {
            on = 1;
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"11",@"index",  nil];
        }
        else
        {
            
            on = 0;
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"index",  nil];
        }
        if(self.currPeripheral != nil &&self.characteristic != nil)
        {
//            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
            
            [self getRequest:2 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            [setDic setObject:temp forKey:@"det"];
        }
    }
}


-(void)FirstValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    FristLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}

-(void)SecondValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    SecondLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}

-(void)ThirdValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    ThirdLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}

-(void)FourthValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    FourthLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}
-(void)TurnOnSaveAction
{
    
    PopView.hidden = YES;
    NSDictionary * temp;
    if (onOrOff == YES) {
        if (MODE == 0) {
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  00:00 to %@",FristLbl.text] forState:UIControlStateNormal];    }
        else
        {
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %@:%@  to %@",[hour intValue]<10?[NSString stringWithFormat:@"0%@",hour]:hour,[second intValue]<10?[NSString stringWithFormat:@"0%@",second]:second,FristLbl.text] forState:UIControlStateNormal];
        }

//        if (MODE == 0) {
//            hour = 0;
//            second = 0;
//        }
//        else if(MODE == 1)
//        {
//            if ([[tempArray objectAtIndex:0]integerValue]>12) {
//                hour = @"12";
//            }
//            else
//            {
//            hour = [tempArray objectAtIndex:0];
//            }
//            second = [tempArray objectAtIndex:1];
//
//        }
//
//        else{
//            hour = [tempArray objectAtIndex:0];
//            second = [tempArray objectAtIndex:1];
//        }
        temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",[NSString stringWithFormat:@"%d",MODE],@"value3",[NSString stringWithFormat:@"%.0f",Fristslider.value],@"value4",[NSString stringWithFormat:@"%d",MODE!=0?[hour intValue]:0],@"value5",[NSString stringWithFormat:@"%d",MODE!=0?[second intValue]:0],@"value6", nil];
//        [setDic removeObjectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
        [setDic setObject:temp forKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];

        
        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

    }
    else
    {
        NSDate *selected = [FristdatePicker date];
        [dateFormatter setDateFormat:@"hh:mm aa"];
        NSString *str=[dateFormatter stringFromDate:selected];
        
        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        
//        NSDateComponents *comps = nil;
//        
//        comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//        
//        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//        
//        [adcomps setHour:1];
//        
//        
//        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:selected options:0];
        
//        if(MODE == 1)
//        {
//            [dateFormatter setDateFormat:@"H:mm"];
//            
//        }
//        else
            if(MODE == 2)
        {
            [dateFormatter setDateFormat:@"HH:mm"];
        }
        
        NSString *str2=[dateFormatter stringFromDate:selected];
        NSArray * tempArray = [str2 componentsSeparatedByString:@":"];

        if (MODE == 0) {
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  00:00 to %@",FristLbl.text] forState:UIControlStateNormal];
        }
        else if(MODE == 1)
        {
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %@:%@  to %@",[hour4 intValue]<10?[NSString stringWithFormat:@"0%@",hour4]:hour4,[second4 intValue]<10?[NSString stringWithFormat:@"0%@",second4]:second4,FristLbl.text] forState:UIControlStateNormal];
        }
        else
        {
//            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %@:%@  to %@",[hour4 intValue]<10?[NSString stringWithFormat:@"0%@",hour4]:hour4,[second4 intValue]<10?[NSString stringWithFormat:@"0%@",second4]:second4,FristLbl.text] forState:UIControlStateNormal];
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %@  to %@",str,FristLbl.text] forState:UIControlStateNormal];
        }
//        if (MODE == 0) {
//            hour4 = @"0";
//            second4 = @"0";
//        }
//        else if(MODE == 1)
//        {
//            if ([[tempArray objectAtIndex:0]integerValue]>12) {
//                hour4 = @"12";
//            }
//            else
//            {
//                hour4 = [tempArray objectAtIndex:0];
//            }
//            second4 = [tempArray objectAtIndex:1];
//            
//        }
        if (MODE == 2)
        {
            hour4 = [tempArray objectAtIndex:0];
            second4 = [tempArray objectAtIndex:1];
        }
        temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",[NSString stringWithFormat:@"%d",MODE],@"value3",[NSString stringWithFormat:@"%d",MODE!=0?[hour4 intValue]:0],@"value4",[NSString stringWithFormat:@"%d",MODE!=0?[second4 intValue]:0],@"value5", nil];
        
//       [setDic setObject:temp forKey:@"turnOff"];
        [setDic setObject:temp forKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
        [self getRequest:6 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
    }
    
}

-(void)FirstEventSaveAction
{
        NSDate *selected = [SeconddatePicker date];
    
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    [dateFormatter setDateFormat:@"hh:mm aa"];
    NSString *str=[dateFormatter stringFromDate:selected];
//
    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %@  to %@",str,SecondLbl.text] forState:UIControlStateNormal];
    
    PopView.hidden = YES;
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *comps = nil;
//    
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    
//    [adcomps setHour:1];
//    
//    
//    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
//    
//
        [dateFormatter setDateFormat:@"HH:mm"];
//
//    
    NSString *str2=[dateFormatter stringFromDate:selected];
    NSArray * tempArray = [str2 componentsSeparatedByString:@":"];
    hour2 = [tempArray objectAtIndex:0];
    second2 = [tempArray objectAtIndex:1];
    
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"1",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour2 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second2 intValue]],@"value6", nil];
    [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//    [setDic setObject:temp forKey:@"event1"];
    [setDic setObject:temp forKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
}

-(void)SecondEventSaveAction
{
    [dateFormatter setDateFormat:@"hh:mm aa"];
    NSDate *selected = [ThirddatePicker date];
    
    NSString *str=[dateFormatter stringFromDate:selected];
//
    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %@  to %@",str,ThirdLbl.text] forState:UIControlStateNormal];
    
    PopView.hidden = YES;
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *comps = nil;
//    
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    
//    [adcomps setHour:1];
//    
//    
//    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
//    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    
    NSString *str2=[dateFormatter stringFromDate:selected];
    NSArray * tempArray = [str2 componentsSeparatedByString:@":"];
    hour3 = [tempArray objectAtIndex:0];
    second3 = [tempArray objectAtIndex:1];
    
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"1",@"value3",[NSString stringWithFormat:@"%.0f",Thirdslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour3 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second3 intValue]],@"value6", nil];
    [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//    [setDic setObject:temp forKey:@"event2"];
    [setDic setObject:temp forKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
}


-(void)ExactlyAction:(id)sender
{
    FristPicker.hidden = YES;
    FristdatePicker.hidden = YES;
    ivImageV.frame = CGRectMake(Device_Wdith-66, 69.5, 32, 20);
    MODE = 0;
    ExactlyBtn.selected = YES;
    AfterBtn.selected = NO;
    SpecificBtn.selected = NO;
    hour = @"0";

    hour4 = @"0";

}

-(void)AfterAction:(id)sender
{
     MODE = 1;
    if (onOrOff) {
        FristPicker.hidden = NO;
        FristdatePicker.hidden = YES;
        [FristPicker reloadAllComponents];
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour=[pickerArray5 objectAtIndex:row];
        second = [pickerArray4 objectAtIndex:row2];
    }
    else
    {
        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
        FristdatePicker.hidden = YES;
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour4=[pickerArray5 objectAtIndex:row];
        second4 = [pickerArray4 objectAtIndex:row2];
    
    }
    
//    FristPicker.hidden = NO;
//    [FristPicker reloadAllComponents];

    ivImageV.frame = CGRectMake(Device_Wdith-66, 111, 32, 20);
   
    ExactlyBtn.selected = NO;
    AfterBtn.selected = YES;
    SpecificBtn.selected = NO;
//    hour = @"0";
//
//    hour4 = @"0";

}

-(void)SpecificAction:(id)sender
{MODE = 2;
    if (onOrOff) {
        FristPicker.hidden = NO;
        FristdatePicker.hidden = YES;
        [FristPicker reloadAllComponents];
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour=[pickerArray3 objectAtIndex:row];
        second = [pickerArray4 objectAtIndex:row2];
    }
    else
    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = NO;
    }
    
    ivImageV.frame = CGRectMake(Device_Wdith-66, 152.5, 32, 20);
    
    ExactlyBtn.selected = NO;
    AfterBtn.selected = NO;
    SpecificBtn.selected = YES;
//    hour = @"3";
//    
//    hour4 = @"3";
}
-(void)changeAction
{
    actionSheet2 = [[UIActionSheet alloc]
                    initWithTitle:@"select"
                    delegate:self
                    cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                    otherButtonTitles:nil];
    
//    NSArray *keys = [pickerArray allKeys];
    for (int i = 0; i< pickerArray.count; i++) {
        [actionSheet2 addButtonWithTitle:[pickerArray objectAtIndex:i] ];
        
    }
    actionSheet2.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet2 showInView:self.view];

}
-(void)changeAction2
{
    actionSheet3 = [[UIActionSheet alloc]
                    initWithTitle:@"select"
                    delegate:self
                    cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                    otherButtonTitles:nil];
    
    //    NSArray *keys = [pickerArray allKeys];
    for (int i = 0; i< pickerArray2.count; i++) {
        [actionSheet3 addButtonWithTitle:[pickerArray2 objectAtIndex:i] ];
        
    }
    actionSheet3.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet3 showInView:self.view];
    
}

-(void)closeAction
{
    PopView.hidden = YES;
}

-(void)loadMessage:(NSMutableDictionary *)setDics
{
    
    bool full = NO;
    
    
    NSDictionary *temp = [setDics objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value5"] intValue];
        if (h>12) {
            
            h -=12;
        }
        
        [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
        full = YES;
    }
    else
    {
        [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    
    temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value5"] intValue];
        if (h>12) {
            
            h -=12;
        }
        
        [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
        full = YES;
    }
    else
    {
        [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    
    
    temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value5"] intValue];
        if (h>12) {
            
            h -=12;
        }
        
        [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
        full = YES;
    }
    else
    {
        [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    
    
    temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value4"] intValue];
        if (h>12) {
            
            h -=12;
        }
        
        [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
        full = YES;
    }
    else
    {
        [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    
    
    loading = full;

}

/**更新设备名称*/
-(void)updateDeviceName
{
    
    
    deviceNameTxt.text = [userdefaults objectForKey:@"DeviceName"];
}
@end