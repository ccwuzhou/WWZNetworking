//
//  WWZNetworkingTests.m
//  WWZNetworkingTests
//
//  Created by apple on 2017/5/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WWZNetworking.h"
@interface WWZNetworkingTests : XCTestCase

@end

@implementation WWZNetworkingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [WWZHttpRequest GET:@"http://test.zhichecn.com/test/user.do" parameters:@{@"username":@"admin",@"pwd":@"zcadmin"} success:^(id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    });
    
    
    while (1) {
        
    }
   
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
