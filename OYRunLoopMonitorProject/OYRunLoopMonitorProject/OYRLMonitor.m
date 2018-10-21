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
#import "YYWeakProxy.h"

static NSTimeInterval threadTimeInterval = 0.5;

static double _beforeWaiting;
static double _afterWaiting;
static double _lastRecordTime;
static bool _isSleeping;

@interface OYRLMonitor()
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSRunLoop *runloop;
@property (nonatomic, assign, getter=isMonitoring) BOOL monitoring;
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
    if (!self.isMonitoring) {
        [self addMainRunloopOberver];
        [self addTimerToAutherThread];
        self.monitoring = YES;
    }
    
}

- (void)stopMonitor{
    if (self.isMonitoring) {
        [self.timer invalidate];
        
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
        CFRelease(self.observer);
        self.observer = NULL;
        
        CFRunLoopStop(self.runloop.getCFRunLoop);
    }
    self.monitoring = NO;

}

-(void)dealloc{
    NSLog(@"dealloc");
}

- (void)addMainRunloopOberver{
    //需要在主线程中添加
    dispatch_async(dispatch_get_main_queue(), ^{
       //创建一个单独的runloop
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
                CFRunLoopAddObserver(cfRunLoop, self.observer, kCFRunLoopDefaultMode);
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
            _isSleeping = YES;
            break;
        }
        case kCFRunLoopAfterWaiting:{
            _afterWaiting = [[NSDate date] timeIntervalSince1970];
            _isSleeping = NO;
            break;
        }
        default:
            break;
    }
}

- (void)addTimerToAutherThread{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint) object:nil];
    [thread setName:@"monitorControllerThread"];
    [thread start];
}

- (void)networkRequestThreadEntryPoint{
    @autoreleasepool {
        self.timer = [NSTimer timerWithTimeInterval:threadTimeInterval target:[YYWeakProxy proxyWithTarget:self] selector:@selector(timerFired) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        //子线程默认不开启 runloop，它会向一个运行完所有代码后退出线程
        self.runloop = [NSRunLoop currentRunLoop];
        [self.runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [self.runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)timerFired{
    if (_isSleeping) {
        //正在休眠，直接跳过
        return;
    }
    
    if (_afterWaiting == _lastRecordTime) {
        //去除重复的监听
        return;
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    bool con0 = currentTime - _afterWaiting >= 2.0;
    bool con1 = _beforeWaiting - _afterWaiting >= 2.0;
    
    if (!_isSleeping && (con0 || con1)) {
        NSLog(@"卡住了");
        BSLOG_MAIN 
        _lastRecordTime = _afterWaiting;
    }

}
@end
