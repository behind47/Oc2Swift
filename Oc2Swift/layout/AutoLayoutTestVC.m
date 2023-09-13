//
//  AutoLayoutTestVC.m
//  Oc2Swift
//
//  Created by behind47 on 2023/9/12.
//
/// auto layout的关键：
/// NSLayoutConstraint：描述一条约束的对象
/// item1.attribute1 = item2.attribute2 * multiplier + constant

#import <Foundation/Foundation.h>
#import "AutoLayoutTestVC.h"

@implementation AutoLayoutTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *triangle = [UIView new];
    triangle.backgroundColor = [UIColor greenColor];
    triangle.translatesAutoresizingMaskIntoConstraints = false; // autoresizing mask是autolayout的子集，作为历史产物，在使用autolayout约束布局时可以通过设置translatesAutoresizingMaskIntoConstraints为false将autoresizing mask关闭
    [self.view addSubview:triangle];
    // triangle.top = self.view.top * 1.0 + 150
    NSLayoutConstraint *topContraint = [NSLayoutConstraint constraintWithItem:triangle
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:150];
    // triangle.left = self.view.left * 1.0 + 100
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:triangle
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:100];
    
    // triangle.width = 100
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:triangle
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:100];
    
    // triangle.height = 50
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:triangle
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:50];
    
    [self.view addConstraint:topContraint];
    [self.view addConstraint:leftConstraint];
    [self.view addConstraint:widthConstraint];
    [self.view addConstraint:heightConstraint];
}

@end
