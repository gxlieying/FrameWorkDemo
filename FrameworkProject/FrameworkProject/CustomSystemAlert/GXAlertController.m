//
//  GXAlertController.m
//  GXDemo
//
//  Created by iOS开发T001 on 2018/10/25.
//  Copyright © 2018年 iOS开发. All rights reserved.
//

#import "GXAlertController.h"

//toast默认展示时间
static NSTimeInterval const GXAlertShowDurationDefault = 1.0f;

#pragma mark - AlertAcionModel
@interface GXAlertActionModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@end
@implementation GXAlertActionModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}
@end

/**
 AlertAction配置

 @param actionBlock GXAlertActionBlock
 */
typedef void(^GXAlertActionsConfig)(GXAlertActionBlock actionBlock);
@interface GXAlertController ()
// GXAlertActionModel数组
@property (nonatomic, strong) NSMutableArray <GXAlertActionModel *> *alertActionArr;
// action配置
- (GXAlertActionsConfig)alertActionsConfig;
@end

@implementation GXAlertController
- (void)dealloc {
    
}

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    if (!(title.length > 0) && (message.length > 0) && (preferredStyle == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (!self) return nil;
    
    self.alertAnimated = NO;
    self.toastStyleDuration = GXAlertShowDurationDefault;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
}

// action配置
- (GXAlertActionsConfig)alertActionsConfig {
    return ^(GXAlertActionBlock actionBlock) {
        if (self.alertActionArr.count > 0) {
            // 创建action
            __weak typeof(self) weakSelf = self;
            [self.alertActionArr enumerateObjectsUsingBlock:^(GXAlertActionModel * _Nonnull actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                //可利用这个改变字体颜色
                if (actionModel.titleColor) {
                    [alertAction setValue:actionModel.titleColor forKey:@"titleTextColor"];
                }
                //action作为self元素，其block实现如果引用本类指针，会造成循环引用
                [self addAction:alertAction];
            }];
        } else {
            NSTimeInterval duration = self.toastStyleDuration > 0 ? self.toastStyleDuration:GXAlertShowDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:!(self.alertAnimated) completion:nil];
            });
        }
    };
}

- (GXAlertActionTitle)addActionDefaultTitle {
    // 该block返回值不是本类属性，只是局部变量，不会造成循环引用
    return ^(NSString *title) {
        GXAlertActionModel *actionModel = [[GXAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        actionModel.titleColor = [UIColor colorWithHexString:@"333333"];
        [self.alertActionArr addObject:actionModel];
        return self;
    };
}

- (GXAlertActionTitle)addActionCancelTitle {
    return ^(NSString *title) {
        GXAlertActionModel *actionModel = [[GXAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        actionModel.titleColor = [UIColor colorWithHexString:@"999999"];
        [self.alertActionArr addObject:actionModel];
        return self;
    };
}
- (GXAlertActionTitle)addActionDestructiveTitle {
    return ^(NSString *title) {
        GXAlertActionModel *actionModel = [[GXAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.alertActionArr addObject:actionModel];
        return self;
    };
}

#pragma mark - lazyload
- (NSMutableArray<GXAlertActionModel *> *)alertActionArr {
    if (!_alertActionArr) {
        _alertActionArr = [NSMutableArray array];
    }
    return _alertActionArr;
}
@end

#pragma mark - III.UIViewController扩展
@implementation UIViewController (GXAlertController)

- (void)showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message appearanceProcess:(GXAlertAppearanceProcess)appearanceProcess actionsBlock:(GXAlertActionBlock)actionBlock
{
    if (appearanceProcess)
    {
        GXAlertController *alertMaker = [[GXAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        //防止nil
        if (!alertMaker) {
            return ;
        }
        //加工链
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
        //        alertMaker.alertActionsConfig(^(NSInteger buttonIndex, UIAlertAction *action){
        //            if (actionBlock) {
        //                actionBlock(buttonIndex, action);
        //            }
        //        });
        
        if (alertMaker.alertDidShown)
        {
            [self presentViewController:alertMaker animated:!(alertMaker.alertAnimated) completion:^{
                alertMaker.alertDidShown();
            }];
        }
        else
        {
            [self presentViewController:alertMaker animated:!(alertMaker.alertAnimated) completion:NULL];
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(GXAlertAppearanceProcess)appearanceProcess actionsBlock:(GXAlertActionBlock)actionBlock
{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(GXAlertAppearanceProcess)appearanceProcess actionsBlock:(GXAlertActionBlock)actionBlock
{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sure:(AlertSureBlock)sure cancel:(AlertCancelBlock)cancel {
    [self showAlertWithTitle:title message:message appearanceProcess:^(GXAlertController *alertMaker) {
        alertMaker.
        addActionCancelTitle(@"取消").
        addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction *action, GXAlertController *alertController) {
        if (buttonIndex == 0) {
            if (cancel) {
                cancel();
            }
        }
        else if (buttonIndex == 1) {            
            if (sure) {
                sure();
            }
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sure:(AlertSureBlock)sure {
    [self showAlertWithTitle:title message:message appearanceProcess:^(GXAlertController *alertMaker) {
        alertMaker.
        addActionDestructiveTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction *action, GXAlertController *alertController) {
        if (buttonIndex == 0) {
            if (sure) {
                sure();
            }
        }
    }];
}
@end

