//
//  OperationVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/8/4.
//
/// Operation多线程：
/// 1. 创建Operation
/// 2. 创建OperationQueue
/// 3. Operation插入OperationQueue
/// 系统会自动取出Queue里的Operation，并在新线程中执行操作

#import <Foundation/Foundation.h>
#import "OperationVC.h"

@interface CustomOperation : NSOperation

@end

@implementation CustomOperation
/// 重写main或start方法来定义自己的Operation对象
- (void)main {
    if (!self.isCancelled) {
        NSLog(@"custom task----%@", [NSThread currentThread]);
    }
}

@end

@interface OperationVC() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *labelArr;
@property (nonatomic, strong) NSArray<NSString *> *selectorArr;
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation OperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelArr = @[@"useInvocationOperation",
                      @"useBlockOperation",
                      @"useCustomOperation",
                      @"用OperationQueue添加一堆Operations",
                      @"通过添加依赖关系确定operation的先后执行顺序",
                      @"线程间通信"
    ];
    self.selectorArr = @[NSStringFromSelector(@selector(useInvocationOperation)),
                         NSStringFromSelector(@selector(useBlockOperation)),
                         NSStringFromSelector(@selector(useCustomOperation)),
                         NSStringFromSelector(@selector(addOperation2Queue)),
                         NSStringFromSelector(@selector(addDependency)),
                         NSStringFromSelector(@selector(communication))
    ];
    [self tableView];
}

- (void)useInvocationOperation {
    // 在主线程单独使用NSInvocationOperation执行操作时，操作是在当前线程执行的，没有开启新线程。
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [operation start];
}

- (void)useBlockOperation {
    // 在主线程单独使用NSBlockOperation执行操作时，操作是在当前线程执行的，没有开启新线程。但是如果添加的操作过多，就会自动开启新线程处理。这由系统决定。
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self task1];
    }];
    for (int i = 0; i < 10; i++) {
        [op addExecutionBlock:^{
            [self task1];
        }];
    }
    [op start];
}

- (void)useCustomOperation {
    CustomOperation *op = [CustomOperation new];
    [op start];
}

- (void)addOperation2Queue {
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [self task3];
    }];
    [op3 addExecutionBlock:^{
        [self task4];
    }];
    [self.queue addOperations:@[op1, op2, op3] waitUntilFinished:true];
}

- (void)addDependency {
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [self task3];
    }];
    [op1 addDependency:op2];
    [op2 addDependency:op3];
    [self.queue addOperations:@[op1, op2, op3] waitUntilFinished:true];
}

/// 子线程操作后通知主线程处理
- (void)communication {
    [self.queue addOperationWithBlock:^{
        [self task1];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self task2];
        }];
    }];
}

- (void)task1 {
    [NSThread sleepForTimeInterval:1];
    NSLog(@"1 task----%@", [NSThread currentThread]);
}

- (void)task2 {
    [NSThread sleepForTimeInterval:1];
    NSLog(@"2 task----%@", [NSThread currentThread]);
}

- (void)task3 {
    [NSThread sleepForTimeInterval:1];
    NSLog(@"3 task----%@", [NSThread currentThread]);
}

- (void)task4 {
    [NSThread sleepForTimeInterval:1
    ];
    NSLog(@"4 task----%@", [NSThread currentThread]);
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    }
    return _tableView;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1; // 控制队列中能并发执行的operations上限，默认-1，表示不限制，系统有一个默认最大值。
    }
    return _queue;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectorName = self.selectorArr[indexPath.row];
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
#if 0
        /// 这里直接perform selector会有一个warning ： PerformSelector may cause a leak because its selector is unknown
        /// 原因: ARC下调用一个方法，runtime需要知道对于返回值怎么办，有4种类型：
        /// 1. 对于基本类型，直接忽略。
        /// 2. 把返回值先retain，等到用不到的时候再release。
        /// 3. 对于init,copy这类返回值自动retain的方法，或标注ns_returns_retained的方法，不retain，等到用不到的时候直接release。
        /// 4. 对于标注ns_returns_autoreleased的方法，什么也不做，等到最近的release pool结束时release。
        /// performSelector:的时候，系统会mourn返回值不是基本类型，但也不会retain, relase，也就是默认采取方案4。所以如果那个方案本来属于前3种情况，可能会导致内存泄漏。
        [self performSelector:selector];
#else
        IMP selecorImp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)selecorImp;
        func(self, selector);
#endif
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    cell.textLabel.text = self.labelArr[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.labelArr count];
}

@end
