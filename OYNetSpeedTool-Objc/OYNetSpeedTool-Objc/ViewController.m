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

-(void)onUpdateNetSpeed:(OYNetSpeedToolType)type speed:(unsigned long long)speed{
    NSLog(@"onUpdateNetSpeed type:%lu speed:%llu",(unsigned long)type,speed);
}


@end
