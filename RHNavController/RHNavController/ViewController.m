//
//  ViewController.m
//  RHNavController
//
//  Created by 郭人豪 on 2017/7/10.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "ViewController.h"
#import "RHNavController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"
#import "SixthViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    [self setNavController];
}


- (void)setNavController {
    
    FirstViewController * first = [[FirstViewController alloc] init];
    SecondViewController * second = [[SecondViewController alloc] init];
    ThirdViewController * third = [[ThirdViewController alloc] init];
    FourthViewController * fourth = [[FourthViewController alloc] init];
    FifthViewController * fifth = [[FifthViewController alloc] init];
    SixthViewController * sixth = [[SixthViewController alloc] init];
    
    NSArray * controllerArr = @[first, second, third, fourth, fifth, sixth];
    NSArray * titleArr = @[@"first", @"second", @"third", @"fourth", @"fifth", @"sixth"];
    RHNavController * nav = [[RHNavController alloc] initWithControllers:controllerArr itemTitles:titleArr];
//    nav.tintColor = [UIColor lightGrayColor];
//    nav.itemNormalColor = [UIColor whiteColor];
//    nav.itemSelectColor = [UIColor redColor];
//    nav.itemFont = [UIFont systemFontOfSize:17];
    nav.parentController = self;
}


@end
