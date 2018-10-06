//
//  OYRLMonitor.m
//  OYRunLoopMonitorProject
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "OYRLMonitor.h"
#import <execinfo.h>
#import "BSBacktraceLogger.h"

static NSTimeInterval threadTimeInterval = 0.5;

static double _beforeWaiting;
static double _afterWaiting;
static double _lastRecordTime;

@interface OYRLMonitor()
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, strong) NSMutableArray *backtrace;
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
    [self addTimerToAutherThread];
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
            break;
        }
        case kCFRunLoopAfterWaiting:{
            _afterWaiting = [[NSDate date] timeIntervalSince1970];
            break;
        }
        default:
            break;
    }
}

- (void)addTimerToAutherThread{
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint) object:nil];
        [thread start];
    });
}

- (void)networkRequestThreadEntryPoint{
    @autoreleasepool {
        NSTimer *timer = [NSTimer timerWithTimeInterval:threadTimeInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        [[NSThread currentThread] setName:@"monitorControllerThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        [runLoop run];
    }
}

- (void)timerFired{
    if (_afterWaiting - _beforeWaiting < 0.01) {
        return;
    }
    
    if (_afterWaiting == _lastRecordTime) {
        //去除重复的监听
        return;
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if ((currentTime - _afterWaiting) >= 2.0) {
        NSLog(@"卡住了");
        BSLOG_MAIN 
        _lastRecordTime = _afterWaiting;
    }

}

- (void)logStack{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    _backtrace = [NSMutableArray arrayWithCapacity:frames];
    for ( i = 0 ; i < frames ; i++ ){
        [_backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
}

-(NSMutableArray *)backtrace{
    if (!_backtrace) {
        _backtrace = [NSMutableArray array];
    }
    return _backtrace;
}
@end
