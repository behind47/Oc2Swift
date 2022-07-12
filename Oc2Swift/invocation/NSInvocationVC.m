//
//  NSInvocationVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/11.
//
/// NSInvocation可以调用类的方法， 这是一种反射调用
///  据此可以抽出一个public 方法，用来执行target对象的aSelector方法，并传入参数arguments

#import "NSInvocationVC.h"

@interface NSInvocationVC()
@property (nonatomic, strong) UIButton *normalBtn;
@property (nonatomic, strong) UIButton *normalBtn2;
@property (nonatomic, strong) UIButton *invocationBtn;
@end

@implementation NSInvocationVC

/// 执行target对象的aSelector方法，并传入参数arguments
/// @param aSelector 需要执行的方法
/// @param target 执行方法的对象
/// @param arguments 方法执行需要的参数列表
+ (id)performSelector:(SEL)aSelector onTarget:(id)target withArguments:(NSArray<id> *)arguments {
    NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
    if (signature == nil) {
        NSLog(@"signature cannot be nil");
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = aSelector;
    invocation.target = target;
    NSInteger len = MIN([arguments count], [signature numberOfArguments]);
    for (int i = 0; i < len; i++) {
        const char *cfType = [signature getArgumentTypeAtIndex:i+2];
        id argument = [arguments objectAtIndex:i];
        // 返回值是结果类型编码后的字符串，因此需要用类型编码后的字符串与其比较，判断是哪一种类型
        if (strcmp(cfType, @encode(void)) == 0) {
            [invocation setArgument:&argument atIndex:i+2];
        } else if (strcmp(cfType, @encode(id)) == 0) { // id是对象
            [invocation setArgument:&argument atIndex:i+2];
        } else { // 数值类型
            if (strcmp(cfType, @encode(BOOL)) == 0) {
                bool res = [argument boolValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(char)) == 0) {
                char res = [argument charValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(short)) == 0) {
                short res = [argument shortValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(int)) == 0) {
                int res = [argument intValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(long)) == 0) {
                long res = [argument longValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(long long)) == 0) {
                long long res = [argument longLongValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(float)) == 0) {
                float res = [argument floatValue];
                [invocation setArgument:&res atIndex:i+2];
            } else if (strcmp(cfType, @encode(double)) == 0) {
                double res = [argument doubleValue];
                [invocation setArgument:&res atIndex:i+2];
            } // 还有一堆无符号类型
            else {
                [invocation setArgument:&argument atIndex:i+2];
            }
        }
    }
    [invocation invoke];
    if ([signature methodReturnLength] > 0) {
        void *returnValue = (void *)malloc([signature methodReturnLength]);
        [invocation getReturnValue:returnValue];
        id result = [NSInvocationVC obtainCfValue:returnValue ofType:[signature methodReturnType]];
        free(returnValue);
        return result;
    } else {
        return nil;
    }
}

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
    [NSInvocationVC performSelector:@selector(bar3:andBook:andFood:) onTarget:self withArguments:@[@"Alan", @"LonelyThroughHunderedOfYears", @(3)]];
}

/// 将指定类型的void *数据转化成CF对象
///  @param voidValue   void*数据
///  @param cfType  要转换成的cf对象的类型
+ (id)obtainCfValue:(void *)voidValue ofType:(const char*)cfType {
    id result = nil;
    // 返回值是结果类型编码后的字符串，因此需要用类型编码后的字符串与其比较，判断是哪一种类型
    if (strcmp(cfType, @encode(void)) == 0) {
        result = nil;
        NSLog(@"invocation result: %@", result);
    } else if (strcmp(cfType, @encode(id)) == 0) { // id是对象
        result = (__bridge id)(voidValue);
        NSLog(@"invocation result: %@", result);
    } else { // 数值类型
        if (strcmp(cfType, @encode(BOOL)) == 0) {
            result = [NSNumber numberWithBool:*((BOOL *) voidValue)];
            NSLog(@"invocation result: %d", [result boolValue]);
        } else if (strcmp(cfType, @encode(char)) == 0) {
            result = [NSNumber numberWithChar:*((char *) voidValue)];
            NSLog(@"invocation result: %c", [result charValue]);
        } else if (strcmp(cfType, @encode(short)) == 0) {
            result = [NSNumber numberWithShort:*((short *) voidValue)];
            NSLog(@"invocation result: %d", [result shortValue]);
        } else if (strcmp(cfType, @encode(int)) == 0) {
            result = [NSNumber numberWithInt:*((int *) voidValue)];
            NSLog(@"invocation result: %d", [result intValue]);
        } else if (strcmp(cfType, @encode(long)) == 0) {
            result = [NSNumber numberWithLong:*((long *) voidValue)];
            NSLog(@"invocation result: %ld", [result longValue]);
        } else if (strcmp(cfType, @encode(long long)) == 0) {
            result = [NSNumber numberWithLongLong:*((long long *) voidValue)];
            NSLog(@"invocation result: %lld", [result longLongValue]);
        } else if (strcmp(cfType, @encode(float)) == 0) {
            result = [NSNumber numberWithFloat:*((float *) voidValue)];
            NSLog(@"invocation result: %f", [result floatValue]);
        } else if (strcmp(cfType, @encode(double)) == 0) {
            result = [NSNumber numberWithDouble:*((double *) voidValue)];
            NSLog(@"invocation result: %f", [result doubleValue]);
        } // 还有一堆无符号类型
    }
    // TODO:怎么把NSLog抽出来，能统一处理所有的结果？或者怎么把众多if else去掉？
    
    return result;
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
