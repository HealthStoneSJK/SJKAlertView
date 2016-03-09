//
//  ViewController.m
//  SJKAlertView
//
//  Created by Amy on 16/3/9.
//  Copyright © 2016年 SJK. All rights reserved.
//

#import "ViewController.h"
#import "SJKAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showButtonClick:(id)sender
{
    [_Message resignFirstResponder];
    [SJKAlertView showWithMessage:_Message.text];
}
@end
