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
@property (weak, nonatomic) IBOutlet UILabel *fpsLabel;
@property (nonatomic, strong) OYFpsMonitor *fpsMonitor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.fpsMonitor = [[OYFpsMonitor alloc] init];
    self.fpsMonitor.delegate = self;
//    [[OYFpsMonitor shareMonitor] startMonitor];
//    [OYFpsMonitor shareMonitor].delegate = self;
    
}

-(void)fpsMonitor:(OYFpsMonitor *)monitor currentFps:(NSUInteger)fps{
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS:%lu",(unsigned long)fps];
}
- (IBAction)startMonitor:(id)sender {
    [self.fpsMonitor startMonitor];
}
- (IBAction)stopMonitor:(id)sender {
    [self.fpsMonitor stopMonitor];
}
- (IBAction)destory:(id)sender {
    self.fpsMonitor = nil;
}

- (IBAction)kadunbutton:(id)sender {
    for (int i=0; i<10000; i++) {
        for (int i=0; i<10000; i++) {
            float a = 3.4554451/54547.4578;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
