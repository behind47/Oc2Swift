//
//  UIView+Check.m
//  Oc2Swift
//
//  Created by behind47 on 2023/4/14.
//
/// 因为暂时不知道如何用swift实现oc的load方法，所以先用oc处理。
/// 为UIView添加一个边框属性layerBorder，在页面布局刷新时，根据开关显示或隐藏边框。

#import <Foundation/Foundation.h>
#import "UIView+Check.h"
#import <objc/runtime.h>
#import "Oc2Swift-Swift.h"

@implementation UIView(Check)

/// 在类加载时hook系统方法layoutSubviews
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oriSel = @selector(layoutSubviews);
        SEL swiSel = @selector(uicheck_layoutSubviews);
        Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
        Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
        if (class_addMethod(UIView.class, oriSel, method_getImplementation(swizzledAddObserverMethod), method_getTypeEncoding(swizzledAddObserverMethod))) {
            class_replaceMethod(UIView.class, oriSel, method_getImplementation(originAddObserverMethod), method_getTypeEncoding(originAddObserverMethod));
        } else {
            method_exchangeImplementations(originAddObserverMethod, swizzledAddObserverMethod);
        }
    });
}

- (void)uicheck_layoutSubviews {
    [self uicheck_layoutSubviews]; // load()里交换了uicheck_layoutSubviews与layoutSubviews的IMP，所以这里的[self uicheck_layoutSubviews]实际上调用的是layoutSubviews的IMP。相当于在layoutSubviews方法后面追加了以下的逻辑。
    if ([UIViewCheckConfig shared].uiCheckStatus) {
        [self recurseiveShowUIBorder:[UIViewCheckConfig shared].uiCheckOn];
    }
}

- (void)recurseiveShowUIBorder:(Boolean)uiCheckOn {
    // 状态栏及其subViews不显示UI检查边框
    UIWindow *statusBarView = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
    if (statusBarView && [self isDescendantOfView:statusBarView]) {
        return;
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        [subView recurseiveShowUIBorder:uiCheckOn];
    }];
    
    if (uiCheckOn) {
        if (!self.uiCheckBorderLayer) {
            self.uiCheckBorderLayer = [CALayer new];
            self.uiCheckBorderLayer.borderColor = [self randomColor].CGColor;
            self.uiCheckBorderLayer.borderWidth = 1;
            [self.layer addSublayer:self.uiCheckBorderLayer];
        }
        self.uiCheckBorderLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.uiCheckBorderLayer.hidden = false;
    } else if (self.uiCheckBorderLayer) {
        self.uiCheckBorderLayer.hidden = true;
    }
}

/// category使用objc_setAssociatedObject方法来实现与属性声明相同的效果
- (void)setUiCheckBorderLayer:(CALayer *)uiCheckBorderLayer {
    objc_setAssociatedObject(self, @selector(uiCheckBorderLayer), uiCheckBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)uiCheckBorderLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:( arc4random() % 255 / 255.0 )
                           green:( arc4random() % 255 / 255.0 )
                            blue:( arc4random() % 255 / 255.0 )
                           alpha:1.0];
}

@end
