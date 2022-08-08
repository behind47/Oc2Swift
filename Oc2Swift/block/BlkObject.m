//
//  BlkObject.m
//  Oc2Swift
//
//  Created by behind47 on 2022/8/8.
//

#import "BlkObject.h"

@implementation BlkObject
{
    int val0;
    int val1;
}
int main() {
    void(^block)(void) = ^(void) {
        printf("Block\n");
    };
    block();
    return 0;
}

//// 用clang -rewrite-objc fileName 指令可以将OC代码转换成cpp文件，得到main的cpp实现如下:
////
//typedef struct objc_class *Class;
//struct objc_class {
//    Class isa;
//};
//typedef struct objc_object {
//    Class isa;
//} *id;
//// @implementation BlkObject
//// 这是一个wrapper，包含impl——block实现，与Desc——block说明
//struct __main_block_impl_0 {
//  struct __block_impl impl;
//  struct __main_block_desc_0* Desc;
//  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
//    impl.isa = &_NSConcreteStackBlock; // 这是__main_block_impl_0的类型，说明这是一个栈block
//    impl.Flags = flags;
//    impl.FuncPtr = fp;
//    Desc = desc;
//  }
//};
//
//struct __block_impl {
//  void *isa;
//  int Flags;
//  int Reserved;
//  void *FuncPtr;
//};
//
//static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
//    printf("Block\n");
//}
//
//static struct __main_block_desc_0 {
//  size_t reserved;
//  size_t Block_size;
//} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
//
//int main() {
//    /// block = __main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);
//    /// 创建block，第一个参数是函数指针，传给 block->FuncPtr
//    /// block->FuncPtr ( block );
//    void(*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
//    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
//    return 0;
//}
//// @end

int capture() {
    int dmy = 256;
    int val = 10;
    const char *fmt = "val = %d\n";
    void (^block)(void) = ^{
        printf(fmt, val);
    };
    val = 2;
    fmt = "These values were changed. val = %d\n";
    block();
    return 0;
}
/**
// 用clang -rewrite-objc fileName 指令可以将OC代码转换成cpp文件，得到capture的cpp实现如下:
/// 相比于没有block参数的main，这里的blockWrapper里增加了与参数完全相同的成员变量，而block->FuncPtr里是通过传入的blockWrapper获取参数的。
struct __capture_block_impl_0 {
  struct __block_impl impl;
  struct __capture_block_desc_0* Desc;
  const char *fmt;
  int val;
  __capture_block_impl_0(void *fp, struct __capture_block_desc_0 *desc, const char *_fmt, int _val, int flags=0) : fmt(_fmt), val(_val) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
      // 这里将_val赋值给成员变量val，相当于int val = _val,
      // 对于C数组的情形，就是int[1] arr = _arr, 不符合语法规范，
      // 会报错Array initializer must be an initializer list or wide string literal
      // 因此Block不能截获C数组
  }
};

static void __capture_block_func_0(struct __capture_block_impl_0 *__cself) {
  const char *fmt = __cself->fmt; // bound by copy
  int val = __cself->val; // bound by copy
  printf(fmt, val);
}

static struct __capture_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __capture_block_desc_0_DATA = { 0, sizeof(struct __capture_block_impl_0)};

int capture() {
    int dmy = 256;
    int val = 10;
    const char *fmt = "val = %d\n";
    void (*block)(void) = ((void (*)())&__capture_block_impl_0((void *)__capture_block_func_0, &__capture_block_desc_0_DATA, fmt, val));
    val = 2;
    fmt = "These values were changed. val = %d\n";
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    return 0;
}
// @end
*/
@end
