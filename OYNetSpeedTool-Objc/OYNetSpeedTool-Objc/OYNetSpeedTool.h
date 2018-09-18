//
//  OYNetSpeedTool.h
//  OYNetSpeedTool-Objc
//
//  Created by 欧阳铨 on 2018/9/17.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,OYNetSpeedToolType) {
    OYNetSpeedToolTypeLo = 0,
    OYNetSpeedToolTypeEn,
    OYNetSpeedToolTypeAp,
    OYNetSpeedToolTypePdp,
    OYNetSpeedToolTypeAwdl,
    OYNetSpeedToolTypeUtun
};

@protocol OYNetSpeedToolDelegate <NSObject>
@optional
- (void)onUpdateNetReceive:(OYNetSpeedToolType)type speed:(unsigned long long)speed;
- (void)onUpdateNetSend:(OYNetSpeedToolType)type speed:(unsigned long long)speed;
@end

@interface OYNetSpeedTool : NSObject
@property (nonatomic, weak) id<OYNetSpeedToolDelegate> delegate;
+ (instancetype)shareTool;
- (void)startMonitor;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
