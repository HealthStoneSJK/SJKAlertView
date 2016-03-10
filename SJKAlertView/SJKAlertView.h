//
//  SJKAlertView.h
//  SJKAlertView
//
//  Created by Amy on 16/3/9.
//  Copyright © 2016年 SJK. All rights reserved.
//
#define DURATION 0.8f //停留时间
#define BACKCOLOR [UIColor grayColor] //背景色

#import <UIKit/UIKit.h>

@interface SJKAlertView : UIView
@property (nonatomic, strong) UIView * bagView;
@property (nonatomic, strong) UILabel * messageLabel;
+(SJKAlertView*)shareAlertView;

+(void)showWithMessage:(NSString*)message;

@end
