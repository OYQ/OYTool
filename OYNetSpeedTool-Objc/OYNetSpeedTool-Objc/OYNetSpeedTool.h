//
//  OYNetSpeedTool.h
//  OYNetSpeedTool-Objc
//
//  Created by 欧阳铨 on 2018/9/17.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OYNetSpeedToolDelegate <NSObject>
@optional
- (void)onUpdateNetReceiveSpeed:(unsigned long long)speed;
- (void)onUpdateNetSendSpeed:(unsigned long long)speed;
@end

@interface OYNetSpeedTool : NSObject
@property (nonatomic, weak) id<OYNetSpeedToolDelegate> delegate;
+ (instancetype)shareTool;
- (void)startMonitor;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
