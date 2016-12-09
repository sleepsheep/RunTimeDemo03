//
//  main.m
//  runTimeDemo3
//
//  Created by yangL on 16/3/24.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        TestClass *test = [TestClass new];
        
//        [test methodExchange];
        
        [test testMyMethodExchange];
    }
    return 0;
}
