//
//  OYRLMonitor.h
//  OYRunLoopMonitorProject
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OYRLMonitor;
@protocol OYRLMonitorDelegate <NSObject>
@optional
- (void)runLoop:monitor;
@end

@interface OYRLMonitor : NSObject
@property (nonatomic, weak) id<OYRLMonitorDelegate> delegate;
+ (instancetype)shareMonitor;
- (void)startMonitor;
- (void)stopMonitor;
@end
