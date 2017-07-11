//
//  RHNavView.m
//
//
//  Created by 郭人豪 on 16/4/30.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHNavView.h"

#define BtnTag       2016
#define SVHeight     44     // scrollview高度
#define LineHeight   2      // 移动线高度
#define ItemHeight   41     // 按钮高度
#define LineOriginY  SVHeight - LineHeight - 1  // 移动线 y 点
@interface RHNavView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * lab_line;
@property (nonatomic, strong) UILabel * lab_lineH;
@property (nonatomic, strong) NSMutableArray * modelArr;
@property (nonatomic, strong) NSMutableArray * itemArr;

@end

@implementation RHNavView

- (instancetype)initWithFrame:(CGRect)frame itemModels:(NSArray<RHNavItemModel *> *)models {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:models];
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.scrollView.frame = CGRectMake(0, self.bounds.size.height - SVHeight, self.bounds.size.width, SVHeight);
    self.lab_lineH.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    [super layoutSubviews];
}

#pragma mark - create UI

- (void)addSubviews {
    
    if (_modelArr.count == 0) {
        
        return;
    }
    
    float totalItemWidth = 0;
    for (RHNavItemModel * model in _modelArr) {
        
        totalItemWidth += model.itemWidth;
    }
    
    [self addSubview:self.scrollView];
    [_scrollView addSubview:self.lab_line];
    [self addSubview:self.lab_lineH];
    RHNavItemModel * mod = _modelArr.firstObject;
    _lab_line.backgroundColor = mod.selectColor;

    if (_modelArr.count == 1) {
        
        RHNavItemModel * model = _modelArr.firstObject;
        RHNavItem * item = [[RHNavItem alloc] initWithFrame:CGRectMake((kScreen_W - model.itemWidth)/2, 0, model.itemWidth, ItemHeight) itemModel:model];
        [self itemClick:item];
        [_scrollView addSubview:item];
        [self.itemArr addObject:item];
        
        _lab_line.frame = CGRectMake(0, LineOriginY, model.lineWidth, LineHeight);
        _lab_line.center = CGPointMake(item.center.x, _lab_line.center.y);
        
    } else if (_modelArr.count == 2) {
        
        for (int i = 0; i < _modelArr.count; i++) {
            
            RHNavItemModel * model = _modelArr[i];
            RHNavItem * item = [[RHNavItem alloc] initWithFrame:CGRectMake(i * (kScreen_W/2), 0, kScreen_W/2, ItemHeight) itemModel:model];
            item.tag = BtnTag + i;
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:item];
            [self.itemArr addObject:item];
            
            if (i == 0) {
                
                _lab_line.frame = CGRectMake(0, LineOriginY, model.lineWidth, LineHeight);
                _lab_line.center = CGPointMake(item.center.x, _lab_line.center.y);
                [self itemClick:item];
            }
        }
    } else if (kScreen_W >= totalItemWidth) {
        
        for (int i = 0; i < _modelArr.count; i++) {
            
            RHNavItemModel * model = _modelArr[i];
            model.itemWidth += (kScreen_W - totalItemWidth)/_modelArr.count;
        }
        
        float originX = 0;
        
        for (int i = 0; i < _modelArr.count; i++) {
            
            RHNavItemModel * model = _modelArr[i];
            
            RHNavItem * item = [[RHNavItem alloc] initWithFrame:CGRectMake(originX, 0, model.itemWidth, ItemHeight) itemModel:model];
            item.tag = BtnTag + i;
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:item];
            [self.itemArr addObject:item];
            originX += model.itemWidth;
            
            if (i == 0) {
                
                _lab_line.frame = CGRectMake(0, LineOriginY, model.lineWidth, LineHeight);
                _lab_line.center = CGPointMake(item.center.x, _lab_line.center.y);
                [self itemClick:item];
            }
        }
    } else {
        
        _scrollView.contentSize = CGSizeMake(totalItemWidth, 44);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        float originX = 0;
        for (int i = 0; i < _modelArr.count; i++) {
            
            RHNavItemModel * model = _modelArr[i];
            RHNavItem * item = [[RHNavItem alloc] initWithFrame:CGRectMake(originX, 0, model.itemWidth, ItemHeight) itemModel:model];
            item.tag = BtnTag + i;
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:item];
            [self.itemArr addObject:item];
            originX += model.itemWidth;
            
            if (i == 0) {
                
                _lab_line.frame = CGRectMake(0, LineOriginY, model.lineWidth, LineHeight);
                _lab_line.center = CGPointMake(item.center.x, _lab_line.center.y);
                [self itemClick:item];
            }
        }
    }
}

#pragma mark - item event

- (void)itemClick:(RHNavItem *)item{
    
    NSInteger index = item.tag - BtnTag;
    
    if ([self.delegate respondsToSelector:@selector(navView:didSelectedItemAtIndex:)]) {
        
        [self.delegate navView:self didSelectedItemAtIndex:index];
    }
    [self setScrollViewContentOffsetWithItem:item];
}


#pragma mark - 重写属性set方法  实现item自动切换

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    RHNavItem * item = [self viewWithTag:BtnTag + selectedIndex];
    [self setScrollViewContentOffsetWithItem:item];
}

#pragma mark - 设置item的位置

- (void)setScrollViewContentOffsetWithItem:(RHNavItem *)item {
    
    NSInteger index = item.tag - BtnTag;
    RHNavItemModel * model = _modelArr[index];
    float scaleX = model.lineWidth / _lab_line.bounds.size.width;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _lab_line.center = CGPointMake(item.center.x, _lab_line.center.y);
            _lab_line.transform = CGAffineTransformMakeScale(scaleX, 1);
        } completion:^(BOOL finished) {
            
            _lab_line.frame = CGRectMake(item.frame.origin.x + (model.itemWidth - model.lineWidth)/2, LineOriginY, model.lineWidth, LineHeight);
        }];
    });
    
    //遍历ScrollView的RHNavItem 判断如果是当前点中的item 改变其selected属性为YES  否则改为NO
    for (RHNavItem * navItem in self.itemArr) {
        
        if (navItem != item) {
            
            navItem.selected = NO;
        } else {
            
            navItem.selected = YES;
        }
    }
    
    float totalItemWidth = 0;
    for (RHNavItemModel * model in _modelArr) {
        
        totalItemWidth += model.itemWidth;
    }
    if (kScreen_W >= totalItemWidth) {
        
        return;
    }
    
    if (item.center.x - kScreen_W/2 <= 0) {
        
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    if (item.center.x - kScreen_W/2 > 0 && _scrollView.contentSize.width - item.center.x > kScreen_W/2) {
        
        [_scrollView setContentOffset:CGPointMake(item.center.x-kScreen_W/2, 0) animated:YES];
        return;
    }
    
    if (_scrollView.contentSize.width - item.center.x <= kScreen_W/2) {
        
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - kScreen_W, 0) animated:YES];
        return;
    }
}

#pragma mark - setter and getter

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UILabel *)lab_line {
    
    if (!_lab_line) {
       
        UILabel * label = [[UILabel alloc] init];
        _lab_line = label;
    }
    return _lab_line;
}

- (UILabel *)lab_lineH {
    
    if (!_lab_lineH) {
        
        UILabel * label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        _lab_lineH = label;
    }
    return _lab_lineH;
}

- (NSMutableArray *)modelArr {
    
    if (!_modelArr) {
        
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}

- (NSMutableArray *)itemArr {
    
    if (!_itemArr) {
        
        _itemArr = [[NSMutableArray alloc] init];
    }
    return _itemArr;
}

- (void)setItemModelArr:(NSArray *)itemModelArr {
    _itemModelArr = itemModelArr;
    [self.modelArr removeAllObjects];
    [self.modelArr addObjectsFromArray:itemModelArr];
    for (int i = 0; i < _itemArr.count; i++) {
        
        RHNavItem * item = _itemArr[i];
        RHNavItemModel * model = _itemModelArr[i];
        item.titleLabel.font = model.titleFont;
        [item setTitleColor:model.normalColor forState:UIControlStateNormal];
        [item setTitleColor:model.selectColor forState:UIControlStateSelected];
        if (i == 0) {
            
            _lab_line.backgroundColor = model.selectColor;
        }
    }
}

@end
