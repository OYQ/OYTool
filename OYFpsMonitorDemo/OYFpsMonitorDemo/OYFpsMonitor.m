//
//  OYFpsMonitor.m
//  OYFpsMonitorDemo
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "OYFpsMonitor.h"
#import <UIKit/UIKit.h>

@interface OYFpsMonitor()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval lastTimestamp;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign, readwrite) NSUInteger currentFPS;
@end

@implementation OYFpsMonitor
+ (instancetype)shareMonitor{
    static OYFpsMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[OYFpsMonitor alloc] init];
    });
    return monitor;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //这里会内存泄漏
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayBit)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void)dealloc{
    [_displayLink invalidate];
}

-(void)startMonitor{
    [self.displayLink setPaused:NO];
}

-(void)stopMonitor{
    [self.displayLink setPaused:YES];
}

- (void)displayBit{
    if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0) {
        //回调速度比较快
        self.currentFPS = 1 /(self.displayLink.targetTimestamp - self.displayLink.timestamp);
        if ([self.delegate respondsToSelector:@selector(fpsMonitor:currentFps:)]) {
            [self.delegate fpsMonitor:self currentFps:self.currentFPS];
        }
    }else{
        if (self.lastTimestamp <= 0) {
            self.lastTimestamp = self.displayLink.timestamp;
            return;
        }
        self.count ++;
        
        CFTimeInterval interval = self.displayLink.timestamp - self.lastTimestamp;
        if(interval >= 1) {//相差大于1s
            self.lastTimestamp = self.displayLink.timestamp;
            self.currentFPS = self.count / interval;
            self.count = 0;
            
            if ([self.delegate respondsToSelector:@selector(fpsMonitor:currentFps:)]) {
                [self.delegate fpsMonitor:self currentFps:self.currentFPS];
            }
        }
    }
    
    
    
    
    
}
@end
