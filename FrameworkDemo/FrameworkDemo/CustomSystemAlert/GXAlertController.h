//
//  GXAlertController.h
//  GXDemo
//
//  Created by iOS开发T001 on 2018/10/25.
//  Copyright © 2018年 iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXAlertController;

/**
 alertAction配置

 @param title 标题
 @return GXAlertController
 */
typedef GXAlertController *_Nonnull (^GXAlertActionTitle)(NSString *title);

/**
 alert按钮执行回调

 @param buttonIndex 按钮index（添加action的顺序）
 @param action UIAlertAction对象
 @param alertController 本类
 */
typedef void(^GXAlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, GXAlertController *alertController);

NS_CLASS_AVAILABLE_IOS(8_0) @interface GXAlertController : UIAlertController

/**
 alert弹出后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidShown)(void);

/**
 alert关闭后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidDismiss)(void);

/**
 是否操作动画
 */
@property (nonatomic, assign) BOOL alertAnimated;
/**
 设置toast模式展示时间：如果alert未添加任何按钮，将会以toast样式展示，这里设置展示时间，默认1s
 */
@property (nonatomic, assign) NSTimeInterval toastStyleDuration; //deafult 1s
/**
 链式构造alert视图按钮，添加一个alertAction按钮，默认样式，参数为标题
 
 @return GXAlertController对象
 */
- (GXAlertActionTitle)addActionDefaultTitle;

/**
 链式构造alert视图按钮，添加一个alertAction按钮，取消样式，参数为标题(warning:一个alert该样式只能添加一次!!!)
 
 @return GXAlertController对象
 */
- (GXAlertActionTitle)addActionCancelTitle;

/**
 链式构造alert视图按钮，添加一个alertAction按钮，警告样式，参数为标题
 
 @return GXAlertController对象
 */
- (GXAlertActionTitle)addActionDestructiveTitle;
@end


#pragma mark - II.UIViewController扩展使用JXTAlertController

/**
 alert构造块
 
 @param alertMaker GXAlertController配置对象
 */
typedef void(^GXAlertAppearanceProcess)(GXAlertController *alertMaker);


/**
 确定回调
 */
typedef void(^AlertSureBlock)(void);

/**
 取消回调
 */
typedef void(^AlertCancelBlock)(void);

@interface UIViewController (GXAlertController)

/**
 show-alert(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess alert配置过程
 @param actionBlock       alert点击响应回调
 */
- (void)showAlertWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
             appearanceProcess:(GXAlertAppearanceProcess)appearanceProcess
                  actionsBlock:(nullable GXAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

/**
 show-actionSheet(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess actionSheet配置过程
 @param actionBlock       actionSheet点击响应回调
 */
- (void)showActionSheetWithTitle:(nullable NSString *)title
                             message:(nullable NSString *)message
                   appearanceProcess:(GXAlertAppearanceProcess)appearanceProcess
                        actionsBlock:(nullable GXAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

/**
 确定取消弹窗

 @param title 标题
 @param message message
 @param sure 确定回调
 @param cancel 取消回调
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sure:(AlertSureBlock)sure cancel:(AlertCancelBlock)cancel;

/**
 确定弹窗

 @param title title
 @param message message
 @param sure 确定回调
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sure:(AlertSureBlock)sure;
@end


