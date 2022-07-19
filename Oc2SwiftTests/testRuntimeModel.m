//
//  testRuntimeModel.m
//  Oc2SwiftTests
//
//  Created by behind47 on 2022/7/18.
//

#import <XCTest/XCTest.h>
#import "RuntimeModel.h"
#import "RuntimeModel+Property.h"
#import "RtmCar.h"

@interface testRuntimeModel : XCTestCase

@end

@implementation testRuntimeModel

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSwitchClassMethod {
    // 测试在加载类时动态交换两个类方法
    XCTAssert([[RuntimeModel classMethoda] isEqualToString:[RuntimeModel rawClassMethodb]], @"交换失败");
    XCTAssert([[RuntimeModel classMethodb] isEqualToString:[RuntimeModel rawClassMethoda]], @"交换失败");
}

- (void)testCategoryProperty {
    // 测试给分类动态添加属性和获取属性值
    NSString *name = @"testName";
    RuntimeModel *model = [RuntimeModel new];
    model.name = name;
    XCTAssert([model.name isEqualToString:name], @"");
}

- (void)testDict2Model {
    // 测试字典转实体
    NSDictionary *dict = @{
        @"carType":@{@"type":@"BMW"},
        @"speed":@120,
        @"carColorArr":@[@{@"color":@"red"},@{@"color":@"blue"}]
    };
    RtmCar *car = [RtmCar objectWithDict:dict];
//    NSLog(@"type = %@, speed = %ld", car.carType, car.speed);
    XCTAssert([car.carType.type isEqualToString:@"BMW"], @"");
    RtmCarColor *color = [car.carColorArr firstObject];
//    NSLog(@"color = %@", color);
    XCTAssert([[car.carColorArr firstObject].color isEqual:@"red"], @"");
}

@end
