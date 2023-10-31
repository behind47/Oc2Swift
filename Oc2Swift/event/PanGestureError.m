//
//  PanGestureError.m
//  Oc2Swift
//
//  Created by behind47 on 2023/10/31.
//
/// requireGestureRecognizerToFail:在12.4上传入nil会crash
/// 在13.6上传入nil不会crash
/// 这说明warning不修可能会出问题

#import <Foundation/Foundation.h>
#import "PanGestureError.h"

@implementation PanGestureError

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] init];
    [recognizer requireGestureRecognizerToFail:nil];
}

@end
