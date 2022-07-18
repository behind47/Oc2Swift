//
//  testRuntimeModel.m
//  Oc2SwiftTests
//
//  Created by behind47 on 2022/7/18.
//

#import <XCTest/XCTest.h>
#import "RuntimeModel.h"

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
    XCTAssert([[RuntimeModel classMethoda] isEqualToString:[RuntimeModel rawClassMethodb]], @"交换失败");
    XCTAssert([[RuntimeModel classMethodb] isEqualToString:[RuntimeModel rawClassMethoda]], @"交换失败");
}

@end
