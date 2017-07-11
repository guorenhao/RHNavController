//
//  RHNavController.h
//  
//
//  Created by 郭人豪 on 16/4/30.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHNavController : UIViewController

// navView 背景色
@property (nonatomic, strong) UIColor * tintColor;
// 未选中 item 字体颜色
@property (nonatomic, strong) UIColor * itemNormalColor;
// 选中 item 字体颜色
@property (nonatomic, strong) UIColor * itemSelectColor;
// item 字体大小
@property (nonatomic, strong) UIFont * itemFont;
// 父 vc
@property (nonatomic, weak) UIViewController * parentController;
// 当前选中的下标
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

// vc 与 title 个数必须一致
- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers itemTitles:(NSArray<NSString *> *)titles;
@end
