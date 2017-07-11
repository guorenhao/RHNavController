//
//  RHNavController.m
//  
//
//  Created by 郭人豪 on 16/4/30.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHNavController.h"
#import "RHNavView.h"

// 标题默认未选中颜色
#define NORMAL_COLOR [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0]
// 标题默认选中颜色
#define SELECT_COLOR [UIColor colorWithRed:243/255.0 green:83/255.0 blue:33/255.0 alpha:1.0]

#define RHNAV_COLLECTION_CELL @"RHNav_Collection_Cell_ID"

@interface RHNavController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RHNavViewDelegate>

@property (nonatomic, strong) NSMutableArray * controllerArr;
@property (nonatomic, strong) NSMutableArray * modelArr;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) RHNavView * navView;
// 是否手动拖拽collectionView
@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, assign) CGFloat navViewH;
@end

@implementation RHNavController

- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers itemTitles:(NSArray<NSString *> *)titles {
    
    self = [super init];
    
    if (self) {
        
        [self.controllerArr addObjectsFromArray:controllers];
        for (int i = 0; i < titles.count; i++) {
            
            RHNavItemModel * model = [[RHNavItemModel alloc] initWithTitle:titles[i] font:[UIFont systemFontOfSize:15] normalColor:NORMAL_COLOR selectColor:SELECT_COLOR];
            [self.modelArr addObject:model];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllers];
    [self addSubviews];
}

#pragma mark - 添加子控制器

- (void)addChildViewControllers {
    
    for (int i = 0; i < self.controllerArr.count; i++) {
        
        UIViewController * vc = (UIViewController *)self.controllerArr[i];
        [self addChildViewController:vc];
    }
}

#pragma mark - add subviews

- (void)addSubviews {
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collectionView];
}

#pragma mark - navView delegate

- (void)navView:(RHNavView *)navView didSelectedItemAtIndex:(NSInteger)index {
    
    _isDrag = NO;
    [_collectionView setContentOffset:CGPointMake(kScreen_W * index, 0) animated:YES];
    _selectedIndex = index;
}

#pragma mark - collectionView dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.controllerArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:RHNAV_COLLECTION_CELL forIndexPath:indexPath];
    if (indexPath.row < self.controllerArr.count) {
        
        UIViewController * controller = self.controllerArr[indexPath.row];
        controller.view.frame = cell.contentView.bounds;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:controller.view];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreen_W, self.view.bounds.size.height - _navViewH);
}

//翻页中，是否手动翻页都会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isDrag) {
        
        if (scrollView == _collectionView) {
            
            NSInteger selectIndex = (_collectionView.contentOffset.x + kScreen_W / 2) / kScreen_W;
            _navView.selectedIndex = selectIndex;
            _selectedIndex = selectIndex;
        }
    }
}
//开始翻页，只有手动开始翻页才会触发的方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _isDrag = YES;
}

#pragma mark - setter and getter

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //两列之间的距离
        flowLayout.minimumInteritemSpacing = 0;
        //两行之间的距离
        flowLayout.minimumLineSpacing = 0;
        
        UICollectionView * collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor whiteColor];
        collection.dataSource = self;
        collection.delegate = self;
        //设置翻页
        collection.pagingEnabled = YES;
        //反弹
        collection.bounces = NO;
        //水平滚动条
        collection.showsHorizontalScrollIndicator = NO;
        [collection registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:RHNAV_COLLECTION_CELL];
        _collectionView = collection;
    }
    return _collectionView;
}

- (RHNavView *)navView {
    
    if (!_navView) {
        
        RHNavView * navView = [[RHNavView alloc] initWithFrame:CGRectZero itemModels:self.modelArr];
        navView.delegate = self;
        _navView = navView;
    }
    return _navView;
}

- (NSMutableArray *)controllerArr {
    
    if (!_controllerArr) {
        
        _controllerArr = [[NSMutableArray alloc] init];
    }
    return _controllerArr;
}

- (NSMutableArray *)modelArr {
    
    if (!_modelArr) {
        
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}

- (void)setParentController:(UIViewController *)parentController {
    
    parentController.automaticallyAdjustsScrollViewInsets = NO;
    [parentController addChildViewController:self];
    [parentController.view addSubview:self.view];
    CGFloat originY = 0;
    if (parentController.navigationController) {
        
        _navViewH = 44;
        if (parentController.navigationController.navigationBar.isTranslucent) {
            
            originY = 64;
        } else {
            
            originY = 0;
        }
    } else {
        
        _navViewH = 64;
    }
    self.navView.frame = CGRectMake(0, originY, kScreen_W, _navViewH);
    self.collectionView.frame = CGRectMake(0, _navViewH + originY, kScreen_W, self.view.bounds.size.height - _navViewH - originY);
    [self.collectionView reloadData];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    self.navView.backgroundColor = tintColor;
}

- (void)setItemNormalColor:(UIColor *)itemNormalColor {
    _itemNormalColor = itemNormalColor;
    for (RHNavItemModel * model in _modelArr) {
        
        model.normalColor = itemNormalColor;
    }
    _navView.itemModelArr = _modelArr;
}

- (void)setItemSelectColor:(UIColor *)itemSelectColor {
    _itemSelectColor = itemSelectColor;
    for (RHNavItemModel * model in _modelArr) {
        
        model.selectColor = itemSelectColor;
    }
    _navView.itemModelArr = _modelArr;
}

- (void)setItemFont:(UIFont *)itemFont {
    _itemFont = itemFont;
    for (RHNavItemModel * model in _modelArr) {
        
        model.titleFont = _itemFont;
    }
    _navView.itemModelArr = _modelArr;
}

@end
