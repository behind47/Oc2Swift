//
//  KVOVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/8/17.
//

#import "KVOVC.h"

@interface KVOVC()
@property (nonatomic, strong) KVOModel *model;
@end

@implementation KVOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[KVOModel alloc] init];
    [self.model addObserver:self forKeyPath:@"clock" options:NSKeyValueObservingOptionNew context:@"123"];
    
    UIButton *btn = [UIButton new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    btn.frame = CGRectMake(50, 200, 50, 20);
    [btn addTarget:self action:@selector(changeColock) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeColock {
    self.model.clock = self.model.clock + 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"123") {
        NSLog(@"%@ %@ %@ KVO success", object, keyPath, [change valueForKey:@"new"]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end


@implementation KVOModel

@end
