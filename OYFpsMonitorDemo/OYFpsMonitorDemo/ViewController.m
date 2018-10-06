//
//  ViewController.m
//  OYFpsMonitorDemo
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "ViewController.h"
#import "OYFpsMonitor.h"

@interface ViewController ()<OYFpsMonitorDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[OYFpsMonitor shareMonitor] startMonitor];
    [OYFpsMonitor shareMonitor].delegate = self;
    
}

-(void)fpsMonitor:(OYFpsMonitor *)monitor currentFps:(NSUInteger)fps{
    NSLog(@"fps:%lu",(unsigned long)fps);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
