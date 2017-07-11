//
//  RHNavItemModel.h
//
//
//  Created by 郭人豪 on 2017/7/10.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RHNavItemModel : NSObject

// 标题
@property (nonatomic, copy) NSString * title;
// 标题文字宽度
@property (nonatomic, assign) CGFloat titleWidth;
// 标题对应的按钮宽度
@property (nonatomic, assign) CGFloat itemWidth;
// 标题下方线宽度
@property (nonatomic, assign) CGFloat lineWidth;
// 标题字体大小
@property (nonatomic, strong) UIFont * titleFont;
// 标题未选中颜色
@property (nonatomic, strong) UIColor * normalColor;
// 标题选中颜色
@property (nonatomic, strong) UIColor * selectColor;

// 构造方法快速创建model
- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor;
@end
