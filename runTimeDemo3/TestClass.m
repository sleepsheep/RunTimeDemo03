//
//  TestClass.m
//  runTimeDemo3
//
//  Created by yangL on 16/3/24.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "TestClass.h"
#import <objc/runtime.h>
/*
 1、系统类方法实现部分替换
 void method_exchangeImplementations(Method m1, Method m2) 
 参数说明：1、Method m1 待交换的方法1  2、Method m2 待交换的方法2
 
 2、自定义类的方法实现部分替换
 参考方法（method_exchangeImplementations）的注释说明
 
 3、覆盖系统的方法
 
 4、自动序列化 见 NSObject+AutoEncodeDecode.h
 
 */
@implementation TestClass

//3、覆盖系统的方法
IMP cFuncPointer0;
IMP cFuncPointer1;
IMP cFuncPointer2;

NSString* CustomUppercaseString(id self,SEL _cmd) {
    printf("原始的方法的名字是CustomUppercaseString");
    
    NSString *string = cFuncPointer0(self, _cmd);
    
    return string;
}

NSArray* CustomComponentsSeparatedByString(id self, SEL _cmd, NSString *str) {
    printf("原始的方法的名字是CustomComponentsSeparatedByString");
    
    return cFuncPointer1(self, _cmd, str);
}

bool customIsEqualToString(id self, SEL _cmd, NSString *str) {
    printf("原始的方法的名字是customIsEqualToString");
    return cFuncPointer2(self, _cmd, str);
}

- (void)replaceMethod {
    cFuncPointer0 = [NSString instanceMethodForSelector:@selector(uppercaseString)];
    class_replaceMethod([NSString class], @selector(uppercaseString), (IMP)CustomUppercaseString, "@@:");
    
    cFuncPointer1 = [NSString instanceMethodForSelector:@selector(componentsSeparatedByString:)];
    class_replaceMethod([NSString class], @selector(componentsSeparatedByString:), (IMP)CustomComponentsSeparatedByString, "@@:@");
    
    cFuncPointer2 = [NSString instanceMethodForSelector:@selector(isEqualToString:)];
    class_replaceMethod([NSString class], @selector(isEqualToString:), (IMP)customIsEqualToString, "B@:@");//B@:@ ---- 返回值 self _sel 参数
}


//2、自定义类的方法实现部分替换
- (void)testLog1 {
    NSLog(@"testLog1");
}

- (void)testLog2 {
    NSLog(@"testLog2");
}

- (void)methodSetimplement {
    Method m1 = class_getInstanceMethod([TestClass class], @selector(testLog1));
    Method m2 = class_getInstanceMethod([TestClass class], @selector(testLog2));
    IMP imp1 = method_getImplementation(m1);
    IMP imp2 = method_getImplementation(m2);
    method_setImplementation(m1, imp2);
    method_setImplementation(m2, imp1);
    
    //IMP imp1 = method_getImplementation(m1);
    //IMP imp2 = method_getImplementation(m2);
    //method_setImplementation(m1, imp2);
    //method_setImplementation(m2, imp1);
}

- (void)testMyMethodExchange {
    [self methodSetimplement];
    
    [self testLog1];//testLog2
    
    [self testLog2];//testLog1
}

//1、系统类方法实现部分替换
- (void)methodExchange {
    Method method1 = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method method2 = class_getInstanceMethod([NSString class], @selector(uppercaseString));
    method_exchangeImplementations(method1, method2);//交换两个方法后，两个方法的功能相反
    NSLog(@"lowerCase:%@", [@"ssssAAAAssss" lowercaseString]);//lowerCase:SSSSAAAASSSS
    NSLog(@"upperCase:%@", [@"ssssAAAAssss" uppercaseString]);//upperCase:ssssaaaassss
}

@end
