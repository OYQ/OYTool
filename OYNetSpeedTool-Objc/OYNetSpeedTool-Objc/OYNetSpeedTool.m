//
//  OYNetSpeedTool.m
//  OYNetSpeedTool-Objc
//
//  Created by 欧阳铨 on 2018/9/17.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "OYNetSpeedTool.h"
#import <ifaddrs.h>
#import <net/if.h>

@interface OYNetSpeedTool()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) unsigned long long loReData;
@property (nonatomic, assign) unsigned long long enReData;
@property (nonatomic, assign) unsigned long long apReData;
@property (nonatomic, assign) unsigned long long pdpReData;
@property (nonatomic, assign) unsigned long long awdlReData;
@property (nonatomic, assign) unsigned long long utunReData;

@property (nonatomic, assign) unsigned long long loSeData;
@property (nonatomic, assign) unsigned long long enSeData;
@property (nonatomic, assign) unsigned long long apSeData;
@property (nonatomic, assign) unsigned long long pdpSeData;
@property (nonatomic, assign) unsigned long long awdlSeData;
@property (nonatomic, assign) unsigned long long utunSeData;
@end

@implementation OYNetSpeedTool
+(instancetype)shareTool{
    static dispatch_once_t onceToken;
    static OYNetSpeedTool *tool;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    });
    return tool;
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)startMonitor{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCurrentSpeed) userInfo:nil repeats:YES];
}
- (void)stopMonitor{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)getCurrentSpeed{
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs) == 0) {
        NSString *netName = [NSString stringWithUTF8String:addrs->ifa_name];
        if ([netName hasPrefix:@"lo"]) {
            [self calculateReveiceData:addrs reData:&_loReData seData:&_loSeData];
        }else if ([netName hasPrefix:@"en"]){
            [self calculateReveiceData:addrs reData:&_enReData seData:&_enSeData];
        }else if ([netName hasPrefix:@"ap"]){
            [self calculateReveiceData:addrs reData:&_apReData seData:&_apSeData];
        }else if ([netName hasPrefix:@"pdp"]){
            [self calculateReveiceData:addrs reData:&_pdpReData seData:&_pdpSeData];
        }else if ([netName hasPrefix:@"awdl"]){
            [self calculateReveiceData:addrs reData:&_awdlReData seData:&_awdlSeData];
        }else if ([netName hasPrefix:@"utun"]){
            [self calculateReveiceData:addrs reData:&_utunReData seData:&_utunSeData];
        }
    }
    freeifaddrs(addrs);
    
    if ([self.delegate respondsToSelector:@selector(onUpdateNetReceive:speed:)]) {
        [self.delegate onUpdateNetReceive:OYNetSpeedToolTypeLo speed:self.loReData/1024];
        [self.delegate onUpdateNetReceive:OYNetSpeedToolTypeEn speed:self.enReData/1024];
        [self.delegate onUpdateNetReceive:OYNetSpeedToolTypeAp speed:self.apReData/1024];
        [self.delegate onUpdateNetReceive:OYNetSpeedToolTypePdp speed:self.pdpReData/1024];
        [self.delegate onUpdateNetReceive:OYNetSpeedToolTypeAwdl speed:self.awdlReData/1024];
        [self.delegate onUpdateNetReceive:OYNetSpeedToolTypeUtun speed:self.utunReData/1024];
    }
    self.loReData = 0;
    self.enReData = 0;
    self.apReData = 0;
    self.pdpReData = 0;
    self.awdlReData = 0;
    self.utunReData = 0;
    
    if ([self.delegate respondsToSelector:@selector(onUpdateNetSend:speed:)]) {
        [self.delegate onUpdateNetSend:OYNetSpeedToolTypeLo speed:self.loSeData/1024];
        [self.delegate onUpdateNetSend:OYNetSpeedToolTypeEn speed:self.enSeData/1024];
        [self.delegate onUpdateNetSend:OYNetSpeedToolTypeAp speed:self.apSeData/1024];
        [self.delegate onUpdateNetSend:OYNetSpeedToolTypePdp speed:self.pdpSeData/1024];
        [self.delegate onUpdateNetSend:OYNetSpeedToolTypeAwdl speed:self.awdlSeData/1024];
        [self.delegate onUpdateNetSend:OYNetSpeedToolTypeUtun speed:self.utunSeData/1024];
    }
    self.loSeData = 0;
    self.enSeData = 0;
    self.apSeData = 0;
    self.pdpSeData = 0;
    self.awdlSeData = 0;
    self.utunSeData = 0;
}

- (void)calculateReveiceData:(const struct ifaddrs *)addrs reData:(unsigned long long *)reData seData:(unsigned long long *)seData{
    while (addrs != NULL) {
        struct if_data *ifa_data = (struct if_data*)addrs->ifa_data;
        if(ifa_data){
            *reData += ifa_data->ifi_ibytes;
            *seData += ifa_data->ifi_obytes;
        }
        addrs = addrs->ifa_next;
    }
}

@end
