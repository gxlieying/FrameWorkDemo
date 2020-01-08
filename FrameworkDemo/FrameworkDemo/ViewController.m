//
//  ViewController.m
//  FrameworkDemo
//
//  Created by 郭旭 on 2020/1/8.
//  Copyright © 2020 郭旭. All rights reserved.
//

#import "ViewController.h"
#import <Framework/Framework.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [Utils alertActionWithController:self];
}


@end
