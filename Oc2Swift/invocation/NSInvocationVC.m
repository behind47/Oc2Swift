//
//  NSInvocationVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/11.
//
/// NSInvocation可以调用类的方法， 这是一种反射调用

#import "NSInvocationVC.h"

@interface NSInvocationVC()
@property (nonatomic, strong) UIButton *normalBtn;
@property (nonatomic, strong) UIButton *normalBtn2;
@property (nonatomic, strong) UIButton *invocationBtn;
@end

@implementation NSInvocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _normalBtn = [UIButton new];
    [_normalBtn setTitle:@"一个参数" forState:UIControlStateNormal];
    [_normalBtn addTarget:self action:@selector(foo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_normalBtn];
    
    _normalBtn2 = [UIButton new];
    [_normalBtn2 setTitle:@"两个参数" forState:UIControlStateNormal];
    [_normalBtn2 addTarget:self action:@selector(foo2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_normalBtn2];
    
    _invocationBtn = [UIButton new];
    [_invocationBtn setTitle:@"三个参数" forState:UIControlStateNormal];
    [_invocationBtn addTarget:self action:@selector(foo3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_invocationBtn];
}

- (void)foo:(UIButton *)sender {
    [self performSelector:@selector(bar:) withObject:@"Alan"];
}

- (void)bar:(NSString *)name {
    NSLog(@"%s %@", __FUNCTION__, name);
}

- (void)foo2:(UIButton *)sender {
    // 最多支持传递两个object，更多参数需要使用NSInvocation
    [self performSelector:@selector(bar2:andBook:) withObject:@"Alan" withObject:@"LonelyThroughHunderedOfYears"];
}

- (void)bar2:(NSString *)name andBook:(NSString *)book {
    NSLog(@"%s %@ %@", __FUNCTION__, name, book);
}

- (void)foo3:(UIButton *)sender {
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(bar3:andBook:andFood:)];
    if (signature == nil) {
        NSLog(@"signature cannot be nil");
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(bar3:andBook:andFood:)];
    NSString *name = @"Alan";
    [invocation setArgument:&name atIndex:2]; // argument需要传入地址才能正确取值
    [invocation setArgument:@"LonelyThroughHunderedOfYears" atIndex:3];
    int food = 3;
    [invocation setArgument:&food atIndex:4];
    [invocation invoke];
    if (signature.methodReturnLength > 0) {
        const char *resultType = signature.methodReturnType;
        // 返回值是结果类型编码后的字符串，因此需要用类型编码后的字符串与其比较，判断是哪一种类型
        if (strcmp(resultType, @encode(void)) == 0) {
            NSLog(@"invocation result: nil");
        } else if (strcmp(resultType, @encode(id)) == 0) { // id是对象
            id result;
            [invocation getReturnValue:&result];
            NSLog(@"invocation result: %@", result);
        } else { // 数值类型
            void *returnValue = (void *)malloc(signature.methodReturnLength);
            [invocation getReturnValue:returnValue];
            id result;
            // TODO:怎么把NSLog抽出来，能统一处理所有的结果？或者怎么把众多if else去掉？
            if (strcmp(resultType, @encode(BOOL)) == 0) {
                result = [NSNumber numberWithBool:*((BOOL *) returnValue)];
                NSLog(@"invocation result: %d", [result boolValue]);
            } else if (strcmp(resultType, @encode(char)) == 0) {
                result = [NSNumber numberWithChar:*((char *) returnValue)];
                NSLog(@"invocation result: %c", [result charValue]);
            } else if (strcmp(resultType, @encode(short)) == 0) {
                result = [NSNumber numberWithShort:*((short *) returnValue)];
                NSLog(@"invocation result: %d", [result shortValue]);
            } else if (strcmp(resultType, @encode(int)) == 0) {
                result = [NSNumber numberWithInt:*((int *) returnValue)];
                NSLog(@"invocation result: %d", [result intValue]);
            } else if (strcmp(resultType, @encode(long)) == 0) {
                result = [NSNumber numberWithLong:*((long *) returnValue)];
                NSLog(@"invocation result: %ld", [result longValue]);
            } else if (strcmp(resultType, @encode(long long)) == 0) {
                result = [NSNumber numberWithLongLong:*((long long *) returnValue)];
                NSLog(@"invocation result: %lld", [result longLongValue]);
            } else if (strcmp(resultType, @encode(float)) == 0) {
                result = [NSNumber numberWithFloat:*((float *) returnValue)];
                NSLog(@"invocation result: %f", [result floatValue]);
            } else if (strcmp(resultType, @encode(double)) == 0) {
                result = [NSNumber numberWithDouble:*((double *) returnValue)];
                NSLog(@"invocation result: %f", [result doubleValue]);
            } // 还有一堆无符号类型
            free(returnValue);
        }
    }
}

- (int)bar3:(NSString *)name andBook:(NSString *)book andFood:(int)food {
    NSLog(@"%s %@ %@ %d", __FUNCTION__, name, book, food);
    return 3;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat height = 100;
    CGFloat padding = 10;
    _normalBtn.frame = CGRectMake(50, height, 100, 20);
    height += _normalBtn.frame.size.height;
    height += padding;
    _normalBtn2.frame = CGRectMake(50, height, 100, 20);
    height += _normalBtn2.frame.size.height;
    height += padding;
    _invocationBtn.frame = CGRectMake(50, height, 100, 20);
}

/// InjectionIII需要的方法，在这个hook里的方法会在热更新触发时被调用
- (void)injected {
#if DEBUG
    [self viewDidLoad];
#endif
}
@end
