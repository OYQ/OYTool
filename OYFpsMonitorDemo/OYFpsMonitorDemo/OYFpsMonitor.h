//
//  OYFpsMonitor.h
//  OYFpsMonitorDemo
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OYFpsMonitor;
@protocol OYFpsMonitorDelegate <NSObject>
@optional
- (void)fpsMonitor:(OYFpsMonitor *)monitor currentFps:(NSUInteger)fps;
@end

@interface OYFpsMonitor : NSObject
@property (nonatomic, weak) id<OYFpsMonitorDelegate> delegate;
@property (nonatomic, assign, readonly) NSUInteger currentFPS;
+ (instancetype)shareMonitor;
- (void)startMonitor;
- (void)stopMonitor;
@end
