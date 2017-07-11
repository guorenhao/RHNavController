//
//  RHNavItem.m
//  
//
//  Created by 郭人豪 on 16/4/30.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHNavItem.h"

@implementation RHNavItem

- (instancetype)initWithFrame:(CGRect)frame itemModel:(RHNavItemModel *)model {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.titleLabel.font = model.titleFont;
        [self setTitle:model.title forState:UIControlStateNormal];
        [self setTitleColor:model.normalColor forState:UIControlStateNormal];
        [self setTitleColor:model.selectColor forState:UIControlStateSelected];
    }
    return self;
}

@end
