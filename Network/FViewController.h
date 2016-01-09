//
//  ViewController.m
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "SocketDelegate.h"
#import "RemoteController.h"
#import "JSONKit.h"



//访问硬件
#import "UIViewController+Servie.h"




#define BACKGROUND_ACTIVE_BRODACAST @"back_ground_active"


@interface FViewController : UIViewController<SocketDelegate>//<MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
   // MBProgressHUD *HUD;
}

@end