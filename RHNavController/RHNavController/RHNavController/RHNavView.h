//
//  RHNavView.h
//  
//
//  Created by 郭人豪 on 16/4/30.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHNavItem.h"

#define kScreen_W [UIScreen mainScreen].bounds.size.width
#define kScreen_H [UIScreen mainScreen].bounds.size.height

@protocol RHNavViewDelegate;
@interface RHNavView : UIView

@property (nonatomic, weak) id<RHNavViewDelegate> delegate;
@property (nonatomic, strong) NSArray * itemModelArr;
@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame itemModels:(NSArray<RHNavItemModel *> *)models;

@end
@protocol RHNavViewDelegate <NSObject>

@optional
- (void)navView:(RHNavView *)navView didSelectedItemAtIndex:(NSInteger)index;
@end
