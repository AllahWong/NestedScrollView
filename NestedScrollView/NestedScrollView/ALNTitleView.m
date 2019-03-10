//
//  ALNTitleView.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/7.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import "ALNTitleView.h"

@interface ALNTitleView ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    __weak id<ALNTitleViewDelegate> _weakDelegate;
    BOOL _switchAnimated;
}

@property (strong, nonatomic) NSIndexPath *currentSelectedIndexPath;
@property (strong, nonatomic) UICollectionViewCell <ALNTitleProtocol> *currentSelectedCell;

@end

@implementation ALNTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;

        if (@available(iOS 11.0,*)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.delegate = self;
        self.dataSource = self;
        _switchAnimated = YES;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - get currentSelectedIndex
- (NSInteger)currentSelectedIndex{
    return _currentSelectedIndexPath.row;
}

#pragma mark - titleSwitchAnimated setter and getter
- (void)setTitleSwitchAnimated:(BOOL)titleSwitchAnimated{
    _switchAnimated = titleSwitchAnimated;
}

- (BOOL)titleSwitchAnimated{
    return _switchAnimated;
}

#pragma mark - set titleViewDelegate
- (void)setTitleViewDelegate:(id<ALNTitleViewDelegate>)titleViewDelegate{
    _weakDelegate = titleViewDelegate;
    if (_weakDelegate) {
        [self registerClass:[_weakDelegate titleCellClass]
 forCellWithReuseIdentifier:NSStringFromClass([_weakDelegate titleCellClass])]; //weakDelegate不能为空
    }
}

#pragma mark - set defaultSelectedIndex
- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex{
    _defaultSelectedIndex = defaultSelectedIndex;
    [self selectItemAtIndex:defaultSelectedIndex
                   animated:NO];
}

#pragma mark - set one item
- (void)selectItemAtIndex:(NSInteger)index{

    [self selectItemAtIndex:index animated:_switchAnimated];
}

- (void)selectItemAtIndex:(NSInteger)index
                 animated:(BOOL)animated{

    [self performBatchUpdates:^{
        [self reloadData];
    } completion:^(BOOL finished) {
        self.currentSelectedIndexPath = [NSIndexPath indexPathForRow:index
                                                           inSection:0];
        
        [self scrollToItemAtIndexPath:self.currentSelectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        self.currentSelectedCell = (UICollectionViewCell <ALNTitleProtocol> *)[self cellForItemAtIndexPath:self.currentSelectedIndexPath];
        [self selectItemAtIndexPath:self.currentSelectedIndexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

        [self.currentSelectedCell selected];
    }];
}

#pragma mark - unselect one item
- (void)unselectItemAtIndex:(NSInteger)index{
    [(UICollectionViewCell <ALNTitleProtocol> *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]] unSelected];

}

#pragma mark - get titleCell
- (UICollectionViewCell <ALNTitleProtocol> *)titleCellAtIndex:(NSInteger)index{
    return (UICollectionViewCell <ALNTitleProtocol> *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - UICollectionViewDatasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [_weakDelegate respondsToSelector:@selector(numberOfItemsInTitleView:)] ? [_weakDelegate numberOfItemsInTitleView:self] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<ALNTitleProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([_weakDelegate titleCellClass])
                                                                                             forIndexPath:indexPath];
    [_weakDelegate titleView:self
             configTitleCell:cell
                    forIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentSelectedCell == nil && indexPath.row == _currentSelectedIndexPath.row) {//_currentSelectedCell当获取的cell未显示在屏幕上时获取为nil，没有及时更新选中状态
        self.currentSelectedCell = (UICollectionViewCell<ALNTitleProtocol> *)cell;
        [_currentSelectedCell selected];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<ALNTitleProtocol> *cell = (UICollectionViewCell<ALNTitleProtocol> *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selected];
    self.currentSelectedIndexPath = indexPath;
    self.currentSelectedCell = cell;

    if ([_weakDelegate respondsToSelector:@selector(titleView:didSelectItemAtIndex:)]) {
        [_weakDelegate titleView:self
            didSelectItemAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell<ALNTitleProtocol> *cell = (UICollectionViewCell<ALNTitleProtocol> *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell unSelected];
    if ([_weakDelegate respondsToSelector:@selector(titleView:didUnselectItemAtIndex:)]) {
        [_weakDelegate titleView:self
          didUnselectItemAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return _sectionInset;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _minimumLineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return _minimumInteritemSpacing;
}

#pragma mark -
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
