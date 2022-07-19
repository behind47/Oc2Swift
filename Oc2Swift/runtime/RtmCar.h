//
//  RtmCar.h
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//

#import "RtmCarColor.h"
#import "RtmCarType.h"

@interface RtmCar : RuntimeModel
@property (nonatomic, strong) RtmCarType *type;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, strong) NSArray<RtmCarColor *> *carColorArr;
@end
