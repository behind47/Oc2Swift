//
//  ReviewInWindowVC.m
//  Oc2Swift
//
//  Created by behind47 on 2023/7/4.
//

#import <Foundation/Foundation.h>
#import "ReviewInWindowVC.h"
#import <Masonry/Masonry.h>

@implementation ReviewInWindowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ReviewInWindow sharedInstance] show];
}

@end

@interface ReviewInWindow()
@property (nonatomic, strong) UIView *infoPanel;
@end

@implementation ReviewInWindow

+ (instancetype)sharedInstance {
    static ReviewInWindow *instance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[ReviewInWindow alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.windowLevel = UIWindowLevelStatusBar + 55;
        self.backgroundColor = [UIColor yellowColor];
        /// 没有这一个设置scene的block，window就不会添加到view树上
        [[[UIApplication sharedApplication] connectedScenes] enumerateObjectsUsingBlock:^(UIScene * _Nonnull scene, BOOL * _Nonnull stop) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                self.windowScene = (UIWindowScene *)scene;
                *stop = TRUE;
            }
        }];
        _infoPanel = [UIView new];
        _infoPanel.backgroundColor = [UIColor greenColor];
        [self addSubview:_infoPanel];
        [_infoPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.frame.size.width/2-30);
            make.height.mas_equalTo(60);
            make.center.mas_equalTo(CGPointMake(self.frame.size.width/2, self.frame.size.height/2));// center有问题
        }];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMove:)];
        [_infoPanel addGestureRecognizer:pan];
    }
    return self;
}

- (void)show {
    self.hidden = false;
}

- (void)hide {
    self.hidden = true;
}

- (void)dragMove:(UIPanGestureRecognizer *)recognizer {
    UIView *sender = recognizer.view;
    CGPoint translation = [recognizer translationInView:sender];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [sender mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(sender.center.x + translation.x, sender.center.y + translation.y));
        }];
        [recognizer setTranslation:CGPointZero inView:sender];
    }
}

@end
