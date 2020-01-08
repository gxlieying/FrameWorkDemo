//
//  GXSystemAlertView.h
//  GXDemo
//
//  Created by iOS开发T001 on 2018/9/28.
//  Copyright © 2018年 iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlertTextFieldBlock)(NSString *filedString);
typedef void(^AlertSureBlock)(void);
typedef void(^AlertCancelBlock)(void);

@interface GXSystemAlertView : NSObject

/**
 单例
 
 @return  self
 */
+ (instancetype)shareAlert;

/**
 确定取消弹窗
 
 @param title 标题
 @param message 内容
 @param sureStr 确定按钮
 @param cancelStr 取消按钮
 @param viewController 控制器
 @param sure 确定
 @param cancel 取消
 */
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message withSureStr:(NSString *)sureStr withCancelStr:(NSString *)cancelStr withViewController:(UIViewController *)viewController sure:(AlertSureBlock)sure cancel:(AlertCancelBlock)cancel;

/**
 输入弹窗
 
 @param title 标题
 @param placeholder 提示文字
 @param sureStr 确定按钮
 @param cancelStr 取消按钮
 @param viewController 控制器
 @param sure 确定
 @param cancel 取消
 */
- (void)textAlertControllerWithTitle:(NSString *)title placeholder:(NSString *)placeholder withSureStr:(NSString *)sureStr withCancelStr:(NSString *)cancelStr withViewController:(UIViewController *)viewController sure:(AlertTextFieldBlock)sure cancel:(AlertCancelBlock)cancel;

@end
