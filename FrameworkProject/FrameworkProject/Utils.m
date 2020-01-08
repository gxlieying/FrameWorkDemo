//
//  Utils.m
//  FrameworkProject
//
//  Created by 郭旭 on 2020/1/8.
//  Copyright © 2020 郭旭. All rights reserved.
//

#import "Utils.h"
#import "GXSystemAlertView.h"

@implementation Utils

+ (void)alertActionWithController:(UIViewController *)controller {
    [[GXSystemAlertView shareAlert] alertControllerWithTitle:@"提示" message:@"demo" withSureStr:@"确定" withCancelStr:nil withViewController:controller sure:^{
        
    } cancel:^{
        
    }];
}

@end
