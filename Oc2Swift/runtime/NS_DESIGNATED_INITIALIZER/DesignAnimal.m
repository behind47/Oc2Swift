//
//  DesignAnimal.m
//  Oc2Swift
//
//  Created by behind47 on 2024/1/21.
//

#import "DesignAnimal.h"

@interface DesignAnimal()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) DesignAnimalType type;
@end

@implementation DesignAnimal
/// 父类NSObject的init是NS_DESIGNATED_INITIALIZER的，需要重写为Convenience initializer。
/// warning: Method override for the designated initializer of the superclass '-init' not found
- (instancetype)init {
    /// Convenience initializer missing a 'self' call to another initializer
    return [self initWithName:@"四不像" andType:DesignAnimalTypeFly];
}

- (instancetype)initWithName:(NSString *)name andType:(DesignAnimalType)type {
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
    }
    return self;
}
- (instancetype)initWithName:(NSString *)name {
//    Designated initializer should only invoke a designated initializer on 'super'
    return [self initWithName:name andType:DesignAnimalTypeFly];
}
- (instancetype)initWithType:(DesignAnimalType)type {
    return [self initWithName:@"四不像" andType:type];
}
@end
