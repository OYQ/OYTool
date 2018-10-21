//
//  ViewController.m
//  OYRunLoopMonitorProject
//
//  Created by 欧阳铨 on 2018/9/19.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

#import "ViewController.h"
#import "OYRLMonitor.h"

@interface ViewController ()
@property (nonatomic, strong) OYRLMonitor *monitor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.monitor = [[OYRLMonitor alloc] init];
    [self.monitor startMonitor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)startMonitor:(id)sender {
//    [[OYRLMonitor shareMonitor] startMonitor];
    [self.monitor startMonitor];
}

- (IBAction)stopMonitor:(id)sender {
//    [[OYRLMonitor shareMonitor] stopMonitor];
    [self.monitor stopMonitor];
}

- (IBAction)destory:(id)sender {
    [self.monitor stopMonitor];
    self.monitor = nil;
}

- (IBAction)buttonClick:(id)sender {
    NSLog(@"---");
    sleep(5);
    NSLog(@"---");
}

@end
