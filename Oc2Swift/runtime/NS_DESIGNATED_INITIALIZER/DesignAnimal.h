//
//  DesignAnimal.h
//  Oc2Swift
//
//  Created by behind47 on 2024/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DesignAnimalTypeFly,
    DesignAnimalTypeSwim,
    DesignAnimalTypeCrawl,
} DesignAnimalType;

@interface DesignAnimal : NSObject
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithName:(NSString *)name andType:(DesignAnimalType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithType:(DesignAnimalType)type;
@end

NS_ASSUME_NONNULL_END
