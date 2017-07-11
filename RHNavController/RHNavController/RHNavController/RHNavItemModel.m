//
//  RHNavItemModel.m
//
//
//  Created by 郭人豪 on 2017/7/10.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "RHNavItemModel.h"

@implementation RHNavItemModel

- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor {
    
    self = [super init];
    if (self) {
        
        self.title = title;
        self.titleFont = font;
        self.normalColor = normalColor;
        self.selectColor = selectColor;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleWidth = [self getWidthByText:_title font:_titleFont];
    _itemWidth = _titleWidth + 30;
    _lineWidth = _titleWidth + 10;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    _titleWidth = [self getWidthByText:_title font:_titleFont];
    _itemWidth = _titleWidth + 30;
    _lineWidth = _titleWidth + 10;
}


- (CGFloat)getWidthByText:(NSString *)text font:(UIFont *)font {
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return width;
}

@end
