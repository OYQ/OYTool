//
//  OYRLMonitor.m
//  OYRunLoopMonitorProject
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "OYRLMonitor.h"

@implementation OYRLMonitor
+ (instancetype)shareMonitor{
    static dispatch_once_t onceToken;
    static OYRLMonitor *monitor;
    dispatch_once(&onceToken, ^{
        monitor = [[OYRLMonitor alloc] init];
    });
    return monitor;
}

- (void)startMonitor{
    
}

- (void)stopMonitor{
    
}
@end
