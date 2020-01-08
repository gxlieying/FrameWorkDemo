//
//  GXSystemAlertView.m
//  GXDemo
//
//  Created by iOS开发T001 on 2018/9/28.
//  Copyright © 2018年 iOS开发. All rights reserved.
//

#import "GXSystemAlertView.h"

@implementation GXSystemAlertView

+ (instancetype)shareAlert {
    static GXSystemAlertView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GXSystemAlertView alloc]init];
    });
    return instance;
}

#pragma mark - ---- alert弹窗
/**
 确定取消弹窗
 */
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message withSureStr:(NSString *)sureStr withCancelStr:(NSString *)cancelStr withViewController:(UIViewController *)viewController sure:(AlertSureBlock)sure cancel:(AlertCancelBlock)cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (message) {
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
        
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#000000"] range:NSMakeRange(0, message.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, message.length)];
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
    
    if (cancelStr) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancel();
        }];
//        [cancelAction setValue:[UIColor colorWithHexString:@"#007AFF"] forKey:@"titleTextColor"];
        
        [alert addAction:cancelAction];
    }
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sure();
    }];
//    [sureAction setValue:[UIColor colorWithHexString:@"#007AFF"] forKey:@"titleTextColor"];
    [alert addAction:sureAction];
    
    [viewController presentViewController:alert animated:YES completion:^{
        
    }];
    
}

/**
 输入弹窗
 */
- (void)textAlertControllerWithTitle:(NSString *)title placeholder:(NSString *)placeholder withSureStr:(NSString *)sureStr withCancelStr:(NSString *)cancelStr withViewController:(UIViewController *)viewController sure:(AlertTextFieldBlock)sure cancel:(AlertCancelBlock)cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cancel();
        
    }];
    [cancelAction setValue:[UIColor colorWithHexString:@"#999999"] forKey:@"titleTextColor"];
    
    [alert addAction:cancelAction];
    
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakAlert) strongAlert = weakAlert;
        sure(strongAlert.textFields.firstObject.text);
    }];
    [sureAction setValue:[UIColor colorWithHexString:@"f03846"] forKey:@"titleTextColor"];
    [alert addAction:sureAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    
    [viewController presentViewController:alert animated:YES completion:^{
        
    }];
}

@end
