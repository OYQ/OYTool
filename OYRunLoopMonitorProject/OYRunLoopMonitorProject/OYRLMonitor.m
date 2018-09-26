//
//  OYRLMonitor.m
//  OYRunLoopMonitorProject
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "OYRLMonitor.h"

static double _beforeWaiting;
static double _afterWaiting;

@interface OYRLMonitor()
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@end

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
    [self addMainRunloopOberver];
}

- (void)stopMonitor{
    
}

- (void)addMainRunloopOberver{
    //需要在主线程中添加
    dispatch_async(dispatch_get_main_queue(), ^{
       //创建一个单独的runloop，不要添加在主releasepool中
        @autoreleasepool{
            NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
            
            //设置Run loop observer的运行环境
            CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
            
            //创建Run loop observer对象
            //第一个参数用于分配observer对象的内存
            //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
            //第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
            //第四个参数用于设置该observer的优先级
            //第五个参数用于设置该observer的回调函数
            //第六个参数用于设置该observer的运行环境
            self.observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserver, &context);
            
            if (self.observer) {
                //将Cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
                CFRunLoopRef cfRunLoop = [mainRunLoop getCFRunLoop];
                //将新建的observer加入到当前thread的run loop
                CFRunLoopAddObserver(cfRunLoop, self.observer, kCFRunLoopCommonModes);
            }
        }
    });
}

void runLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
        case kCFRunLoopBeforeTimers:
        case kCFRunLoopBeforeSources:
        case kCFRunLoopExit:
            break;
        case kCFRunLoopBeforeWaiting:{
            _beforeWaiting = [[NSDate date] timeIntervalSince1970];
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        }
        case kCFRunLoopAfterWaiting:{
            _afterWaiting = [[NSDate date] timeIntervalSince1970];
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        }
        default:
            break;
    }
}

- (void)addTimerToAutherThread{
    
}

@end
