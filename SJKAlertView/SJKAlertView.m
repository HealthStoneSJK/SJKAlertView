//
//  SJKAlertView.m
//  SJKAlertView
//
//  Created by Amy on 16/3/9.
//  Copyright © 2016年 SJK. All rights reserved.
//

#import "SJKAlertView.h"

@implementation SJKAlertView
{
    UIView * titleBagView;
    NSString * tempValidateKey;
    UIButton * choseBtn;
}
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
    label.text = [NSString stringWithFormat:@"%@",message];
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
-(id)showAlertWithTitle:(NSString *)title actionNames:(NSArray *)ActionArray callBack:(SJKAlertViewBlock)callback
{
//    SJKAlertView * Alert = [SJKAlertView shareAlertView];
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=8.0f) {
  
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
        for (NSInteger i=0; i < ActionArray.count; i++) {
            [alertController addAction:[UIAlertAction actionWithTitle:ActionArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                callback(i);
            }]];
        }
        [APPDELEGATE.window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        return alertController;
    }else
    {
        UIAlertView * alert;
        if (ActionArray.count==1) {
            alert = [[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:ActionArray[0] otherButtonTitles:nil, nil];
        }else if (ActionArray.count == 2)
        {
            alert = [[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:ActionArray[0] otherButtonTitles:ActionArray[1], nil];
        }
        [SJKAlertView shareAlertView].alertviewBlock  = callback;
        [alert show];
        return alert;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [SJKAlertView shareAlertView].alertviewBlock(buttonIndex);
}
-(void)showNoNoticeChoseTitle:(NSString *)title actionNames:(NSArray *)ActionArray callBack:(SJKAlertViewBlock)callback validateKey:(NSString *)validateKey
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:validateKey]boolValue]) {
        callback(1);
        return;
    }
    
    titleBagView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    titleBagView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.0f];
    [APPDELEGATE.window addSubview:titleBagView];
    
    [UIView animateWithDuration:0.2f animations:^{
        titleBagView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.5f];
    }];
    UIImageView * titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-80, 140)];
    titleView.image = [UIImage imageNamed:@"widowViewBag"];
    titleView.backgroundColor = [UIColor clearColor];
    titleBagView.userInteractionEnabled = YES;
    titleView.userInteractionEnabled = YES;
    [titleBagView addSubview:titleView];
    
    UIImageView * dogImage = [[UIImageView alloc]initWithFrame:CGRectMake(titleView.frame.size.width/2-35, -47, 70, 70)];
    dogImage.image = [UIImage imageNamed:@"windowDog"];
    [titleView addSubview:dogImage];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, WIDTH-120, 100)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    label.textColor = RGB(102, 102, 102);
    [titleView addSubview:label];
    [label sizeToFit];
    titleView.frame = CGRectMake(0, 0, WIDTH-80, label.frame.size.height+70+25);
    titleView.center = titleBagView.center;
//    titleView.layer.cornerRadius = 10.0f;
//    titleView.clipsToBounds = YES;
    UILabel * noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 100)];
    noticeLabel.text = @"不再提醒";
    noticeLabel.textColor = RGB(143, 143, 143);
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.font = [UIFont systemFontOfSize:12.0f];
    noticeLabel.numberOfLines = 0;
    [titleView addSubview:noticeLabel];
    [noticeLabel sizeToFit];
    noticeLabel.frame = CGRectMake(titleView.frame.size.width-(noticeLabel.frame.size.width+20)/2+20-60, CGRectGetMaxY(label.frame)+7, noticeLabel.frame.size.width, noticeLabel.frame.size.height);
    
    
    choseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choseBtn.frame = CGRectMake(CGRectGetMinX(noticeLabel.frame)-18, CGRectGetMinY(noticeLabel.frame)+1, noticeLabel.frame.size.height-2, noticeLabel.frame.size.height-2);
    [choseBtn setImage:[UIImage imageNamed:@"1111"] forState:UIControlStateNormal];
    [choseBtn setImage:[UIImage imageNamed:@"personal_select"] forState:UIControlStateSelected];
//    choseBtn.selected = YES;
//    choseBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, -10, -5, -10);
    [choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    choseBtn.layer.cornerRadius = 2.0f;
    choseBtn.layer.borderWidth = 1.0f;
    choseBtn.clipsToBounds = YES;
    choseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [titleView addSubview:choseBtn];
    
    
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(choseBtn.frame)+10 , titleView.frame.size.width, 1)];
//    line.backgroundColor = RGB(202, 202, 202);
//    [titleView addSubview:line];
    
    for (NSInteger i = 0; i < ActionArray.count; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(titleView.frame.size.width/ActionArray.count*i+(titleView.frame.size.width/ActionArray.count-80)/2, CGRectGetMaxY(noticeLabel.frame)+8, 80, titleView.frame.size.height-CGRectGetMaxY(noticeLabel.frame)-20)];
        [btn setTitle:ActionArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [btn setBackgroundImage:[UIImage imageNamed:@"YbtnBagImageN"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"YbtnBagImageH"] forState:UIControlStateHighlighted];
        btn.layer.cornerRadius = 5.0f;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [titleView addSubview:btn];
    }
//    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(titleView.frame.size.width/2, CGRectGetMaxY(line.frame) , 1, titleView.frame.size.height-CGRectGetMaxY(line.frame))];
//    line1.backgroundColor = RGB(202, 202, 202);
//    [titleView addSubview:line1];
    _alertviewBlock = callback;
    tempValidateKey = validateKey;
}
-(void)choseBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
}
-(void)BtnClick:(UIButton*)sender
{
    if (choseBtn.selected) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:tempValidateKey];
    }
    _alertviewBlock(sender.tag-100);
    [UIView animateWithDuration:0.2f animations:^{
        titleBagView.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [titleBagView removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
