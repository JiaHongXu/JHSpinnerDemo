//
//  ViewController.m
//  JHSpinnerDemo
//
//  Created by 307A on 2016/12/22.
//  Copyright © 2016年 徐嘉宏. All rights reserved.
//

#import "ViewController.h"
#import "JHSpinner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JHSpinner *spinner = [[JHSpinner alloc] initWithFrame:CGRectMake(20, 64, 300, 44) andOptions:@[@"大",@"屁",@"鑫",@"哈哈哈"] onView:self.view];
    [self.view addSubview:spinner];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
