//
//  ALNContentView.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/7.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import "ALNContentView.h"

@interface ALNContentView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>

{
    __weak id<ALNContentViewDelegate> _weakDelegate;
    NSInteger _countOfItems;
    BOOL _switchAnimated;
}
@property (strong, nonatomic) NSMutableArray<UIScrollView *> *contentViews;     
@property (assign, nonatomic,readwrite) NSInteger currentSelectedIndex;


@end

@implementation ALNContentView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - initialize
- (instancetype)initWithContentViews:(nullable NSArray<UIScrollView<ALNContentProtocol> *> *)contentViews{
  
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _contentViews = [contentViews mutableCopy];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        if (@available(iOS 11.0,*)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:UICollectionViewCell.class
 forCellWithReuseIdentifier:NSStringFromClass(self.class)];
        self.pagingEnabled = YES;
        
        [self addObserver:self forKeyPath:@"contentOffset"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        _switchAnimated = YES;
    }
    
    return self;
}

- (instancetype)init{
    return [self initWithContentViews:nil];
}

#pragma  set Delegate
- (void)setContentViewDelegate:(id<ALNContentViewDelegate>)contentViewDelegate{
    _weakDelegate = contentViewDelegate;
}

#pragma mark - contentSwitchAnimated setter and getter
- (void)setContentSwitchAnimated:(BOOL)contentSwitchAnimated{
    _switchAnimated = contentSwitchAnimated;
}

- (BOOL)isContentSwitchAnimated{
    return _switchAnimated;
}

#pragma mark - set defaultSelectedIndex
- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex{
    _defaultSelectedIndex = defaultSelectedIndex;
    [self selectItemAtIndex:defaultSelectedIndex
                   animated:NO];
}

#pragma mark - select one item
- (void)selectItemAtIndex:(NSInteger)index{
    [self selectItemAtIndex:index
                   animated:_switchAnimated];
}

- (void)selectItemAtIndex:(NSInteger)index
                 animated:(BOOL)animated{
    [self performBatchUpdates:^{
        [self reloadData];
    } completion:^(BOOL finished) {
        self.currentSelectedIndex = index;
        
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }];
}

#pragma mark - UICollectionViewDatasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    _countOfItems = [_weakDelegate respondsToSelector:@selector(numberOfItemsInContentView:)] ? MIN([_weakDelegate numberOfItemsInContentView:self], _contentViews.count) : 0;
    return _countOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class)
                                                                           forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIScrollView<ALNContentProtocol> *scrollView = (UIScrollView<ALNContentProtocol> *)_contentViews[indexPath.row];
    [scrollView configure];
    [cell.contentView addSubview:scrollView];
    return cell;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (index != _currentSelectedIndex) {
        if ([_weakDelegate respondsToSelector:@selector(contentView:didUnselectItemAtIndex:)]) {
            [_weakDelegate contentView:self didUnselectItemAtIndex:_currentSelectedIndex];
        }
        if ([_weakDelegate respondsToSelector:@selector(contentView:didSelectItemAtIndex:)]) {
            [_weakDelegate contentView:self didSelectItemAtIndex:index];
        }
        self.currentSelectedIndex = index;
    }
}

#pragma mark - kvo -observe "contentOffset"
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (self.isDragging || self.isTracking) {
            if ([_weakDelegate respondsToSelector:@selector(contentView:willSelectItemAtIndex:fromItemAtIndex:withRatio:)]) {
                CGFloat ratio = (contentOffset.x - self.currentSelectedIndex * CGRectGetWidth(self.frame)) / CGRectGetWidth(self.frame);
            
                NSInteger from = self.currentSelectedIndex;
                NSInteger to = from + 1;
                if (ratio > 0) {//向右滑动to = from + 1
                    if (to == _countOfItems) {
                        return;
                    }
                }
                else{//向左滑动to = from - 1
                    if (from == 0) {
                        return;
                    }
                    to = from - 1;
                }

                [_weakDelegate contentView:self willSelectItemAtIndex:to fromItemAtIndex:from  withRatio:ratio];
                NSInteger index = contentOffset.x / CGRectGetWidth(self.frame);
                if (index != _currentSelectedIndex) {
                    if ([_weakDelegate respondsToSelector:@selector(contentView:didUnselectItemAtIndex:)]) {
                        [_weakDelegate contentView:self didUnselectItemAtIndex:_currentSelectedIndex];
                    }
                    if ([_weakDelegate respondsToSelector:@selector(contentView:didSelectItemAtIndex:)]) {
                        [_weakDelegate contentView:self didSelectItemAtIndex:index];
                    }
                    self.currentSelectedIndex = index;
                }
            }
        }
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

#pragma mark - dealloc
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"%s",__func__);
}

@end
