//
//  ViewController.m
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "FViewController.h"

@interface FViewController ()



@end

@implementation FViewController





static NSBundle *bundle = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBg2"]]];
    // Do view setup here.
    //定制加载信息
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//
//    HUD.delegate = self;
//    HUD.labelText = LOCALIZATION(@"text_loading");
}


#pragma mark ---
#pragma mark --- 网络数据处理
-(void)resultStr:(CBCharacteristic *)characteristics index:(int)index{}
//-(void)onReciveData:(NSMutableArray *) messageResponse with:(long)tag{}
//-(void)onError:(NSError *)error with:(long)tag{}

@end
