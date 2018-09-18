//
//  ViewController.m
//  OYNetSpeedTool-Objc
//
//  Created by 欧阳铨 on 2018/9/17.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "ViewController.h"
#import "OYNetSpeedTool.h"

@interface ViewController ()<OYNetSpeedToolDelegate>
@property (nonatomic, strong) OYNetSpeedTool *tool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tool = [OYNetSpeedTool shareTool];
    self.tool.delegate = self;
    [self.tool startMonitor];
}

-(void)onUpdateNetReceiveSpeed:(unsigned long long)speed{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(speed <1024) {
            NSLog(@"%@",[NSString stringWithFormat:@"下行速度%lludB/秒", speed]);
        }else if(speed >=1024 && speed <1024*1024) {
            NSLog(@"%@",[NSString stringWithFormat:@"下行速度%lluKB/秒", speed /1024]);
        }else if(speed >= 1024*1024){
            NSLog(@"%@",[NSString stringWithFormat:@"下行速度%lluMB/秒", speed / (1024*1024)]);
        }
    });
    
    
}

-(void)onUpdateNetSendSpeed:(unsigned long long)speed{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(speed <1024) {
            NSLog(@"%@",[NSString stringWithFormat:@"上行速度%lludB/秒", speed]);
        }else if(speed >=1024 && speed <1024*1024) {
            NSLog(@"%@",[NSString stringWithFormat:@"上行速度%lluKB/秒", speed /1024]);
        }else if(speed >= 1024*1024&& speed < 1024*1024*1024){
            NSLog(@"%@",[NSString stringWithFormat:@"上行速度%lluMB/秒", speed / (1024*1024)]);
        }
    });
    
}

@end
