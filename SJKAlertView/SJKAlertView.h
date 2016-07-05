//
//  SJKAlertView.h
//  SJKAlertView
//
//  Created by Amy on 16/3/9.
//  Copyright © 2016年 SJK. All rights reserved.
//
#define DURATION 0.8f //停留时间
#define BACKCOLOR [UIColor grayColor] //背景色
#define APPDELEGATE [UIApplication sharedApplication].delegate
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGB(x,y,z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0f]

#import <UIKit/UIKit.h>

typedef void(^SJKAlertViewBlock)(NSInteger actionIndex);

@interface SJKAlertView : UIView<UIAlertViewDelegate>
@property (nonatomic, strong) UIView * bagView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) SJKAlertViewBlock alertviewBlock;
+(SJKAlertView*)shareAlertView;

+(void)showWithMessage:(NSString*)message;

-(id)showAlertWithTitle:(NSString*)title actionNames:(NSArray*)ActionArray callBack:(SJKAlertViewBlock)callback;
-(void)showNoNoticeChoseTitle:(NSString*)title actionNames:(NSArray*)ActionArray callBack:(SJKAlertViewBlock)callback validateKey:(NSString*)validateKey;
@end
