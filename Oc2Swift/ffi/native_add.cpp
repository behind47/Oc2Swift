//
//  native_add.cpp
//  Oc2Swift
//
//  Created by behind47 on 2022/5/23.
//

#include "native_add.hpp"
#include <stdint.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y) {
    return x + y;
}
