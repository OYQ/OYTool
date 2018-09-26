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
    self.monitor = [OYRLMonitor shareMonitor];
    [self.monitor startMonitor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
