//
//  LeaksVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/8/17.
//

#import "LeaksVC.h"

@interface LeaksVC()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LeaksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// Leaks查不出这种循环引用导致的内存泄漏，但是在Allocations里可以检索到哪些类的实例在退出后没有释放，从而推出哪些类发生了泄漏。
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%s timer %@", __FILE__, self);
    }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
