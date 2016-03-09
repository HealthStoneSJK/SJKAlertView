//
//  SJKAlertView.m
//  SJKAlertView
//
//  Created by Amy on 16/3/9.
//  Copyright © 2016年 SJK. All rights reserved.
//

#import "SJKAlertView.h"

@implementation SJKAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = BACKCOLOR;
        self.layer.cornerRadius = 8.0f;
        self.clipsToBounds = YES;
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:13.0f];
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
    }
    return self;
}
static SJKAlertView * alert = nil;
+(SJKAlertView*)shareAlertView
{
    @synchronized(self) {
        if (!alert) {
            alert = [[SJKAlertView alloc]init];
            alert.hidden = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
    }
    return alert;
}
+(void)showWithMessage:(NSString *)message
{
    SJKAlertView* aler = [SJKAlertView shareAlertView];
    if (aler.hidden == NO) {
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    aler.hidden = NO;
    aler.alpha = 1.0f;
    UILabel * label = aler.messageLabel;
    label.frame = CGRectMake(0, 0, window.frame.size.width-100, 1000);
    label.text = message;
    [label sizeToFit];
    
    CGFloat width = label.frame.size.width;
    CGFloat height = label.frame.size.height;
    aler.frame = CGRectMake(0, 0, width + 40, height+20);
    label.center = aler.center;
    aler.center = CGPointMake(window.center.x, window.frame.size.height - height - 50);
    [window bringSubviewToFront:aler];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:DURATION animations:^{
            aler.alpha = 0.0f;
        } completion:^(BOOL finished) {
            aler.hidden = YES;
        }];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
