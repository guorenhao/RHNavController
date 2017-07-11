//
//  RHNavItem.h
//  
//
//  Created by 郭人豪 on 16/4/30.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHNavItemModel.h"

@interface RHNavItem : UIButton

- (instancetype)initWithFrame:(CGRect)frame itemModel:(RHNavItemModel *)model;
@end
