//
//  ALNScrollView.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/6.
//  Copyright © 2019年 wyl. All rights reserved.
//
//
#import "ALNScrollView.h"
#import "ALNTitleView.h"
#import "ALNContentView.h"

@interface ALNScrollView()<ALNTitleViewDelegate,ALNContentViewDelegate,UIGestureRecognizerDelegate>

{
    __weak id<ALNScrollViewDelegate> _weakDelegate;
    CGRect _titleViewRect;
    CGRect _contentViewRect;
    NSInteger _countOfItems;
}

@property (strong, nonatomic) NSArray<UIScrollView<ALNContentProtocol> *> *contentViews;
@property (strong, nonatomic) ALNTitleView *titleView;
@property (strong, nonatomic) ALNContentView *contentView;
@property (assign, nonatomic,readwrite) NSInteger currentSelectedIndex;
@property (strong, nonatomic) NSMutableArray *canSwitchWhenScrollingGestures;

@end

@implementation ALNScrollView


#pragma mark - initialize
- (instancetype)initWithContentViews:(NSArray<UIScrollView <ALNContentProtocol>*> *)contentViews{

    if (self = [super init]) {
        _contentViews = [contentViews copy];
        _currentSelectedIndex = 0;
        CGFloat titleViewHeight = 50.f;
        _titleViewRect = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, titleViewHeight);
        _contentViewRect = CGRectMake(0, titleViewHeight, [[UIScreen mainScreen]bounds].size.width, 300);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)init{
    
    return [self initWithContentViews:@[[[UIScrollView<ALNContentProtocol> alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)]]];
}

#pragma mark - set Delegate
- (void)setDelegate:(id<ALNScrollViewDelegate>)delegate{
    _weakDelegate = delegate;
    _countOfItems = [_weakDelegate respondsToSelector:@selector(numberOfItemsInScrollView:)] ? MIN([_weakDelegate numberOfItemsInScrollView:self], _contentViews.count)  : 0;
    [self configTitleView];
    [self configContentView];
}


#pragma mark - titleViewFrame getter and setter
- (void)setTitleViewFrame:(CGRect)titleViewFrame{
    _titleViewRect = titleViewFrame;
    [self updateTitleViewFrame];
}

-(CGRect)titleViewFrame{
    return _titleViewRect;
}

#pragma mark - contentViewFrame setter and getter
- (void)setContentViewFrame:(CGRect)contentViewFrame{
    _contentViewRect = contentViewFrame;
    [self updateContentViewFrame];
}

-(CGRect)contentViewFrame{
    return _contentViewRect;
}

#pragma mark - titleSwitchAnimated setter and getter
- (void)setTitleSwitchAnimated:(BOOL)titleSwitchAnimated{
    self.titleView.titleSwitchAnimated = titleSwitchAnimated;
}

- (BOOL)isTitleSwitchAnimated{
    return [_titleView isTitleSwitchAnimated];
}

#pragma mark - contentSwitchAnimated setter and getter
-(void)setContentSwitchAnimated:(BOOL)contentSwitchAnimated{
    self.contentView.contentSwitchAnimated = contentSwitchAnimated;
}

-(BOOL)isContentSwitchAnimated{
    return [_contentView isContentSwitchAnimated];
}

#pragma mark - view configs
- (void)configTitleView{
    [self updateTitleViewFrame];
}

- (void)configContentView{
    [self updateContentViewFrame];
}

#pragma mark - view update
- (void)updateTitleViewFrame{
    [self.titleView setFrame:_titleViewRect];
}

- (void)updateContentViewFrame{
    [self.contentView setFrame:_contentViewRect];
}

#pragma mark - select one item
- (void)selectItemAtIndex:(NSInteger)index{
    if (_weakDelegate && [self isIndexAvaliable:index]) {
        [self.titleView selectItemAtIndex:index];
        [self.contentView selectItemAtIndex:index];
        if (index != self.currentSelectedIndex) {
            [self.titleView unselectItemAtIndex:_currentSelectedIndex];
        }
        self.currentSelectedIndex = index;
    }
}

#pragma mark - set defaultSelectedIndex
- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex{
    if ([self isIndexAvaliable:defaultSelectedIndex]) {
        _defaultSelectedIndex = defaultSelectedIndex;
        self.titleView.defaultSelectedIndex = defaultSelectedIndex;
        self.contentView.defaultSelectedIndex = defaultSelectedIndex;
    }
}

#pragma mark - set title style
- (void)setTitleMinimumLineSpacing:(CGFloat)titleMinimumLineSpacing{
    [self.titleView setMinimumLineSpacing:titleMinimumLineSpacing];
}

- (void)setTitleSectionInset:(UIEdgeInsets)titleSectionInset{
    [self.titleView setSectionInset:titleSectionInset];
}

- (void)setTitleMinimumInteritemSpacing:(CGFloat)titleMinimumInteritemSpacing{
    [self.titleView setMinimumInteritemSpacing:titleMinimumInteritemSpacing];
}

- (void)setTitleItemSize:(CGSize)titleItemSize{
    [self.titleView setItemSize:titleItemSize];
}

#pragma mark - set content style
- (void)setContentMinimumLineSpacing:(CGFloat)contentMinimumLineSpacing{
    [self.contentView setMinimumLineSpacing:contentMinimumLineSpacing];
}

-(void)setContentMinimumInteritemSpacing:(CGFloat)contentMinimumInteritemSpacing{
    [self.contentView setMinimumInteritemSpacing:contentMinimumInteritemSpacing];
}

- (void)setContentSectionInset:(UIEdgeInsets)contentSectionInset{
    [self.contentView setSectionInset:contentSectionInset];
}

- (void)setContentItemSize:(CGSize)contentItemSize{
    [self.contentView setItemSize:contentItemSize];
}

#pragma mark - set backgroundColor
-(void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor{
    self.titleView.backgroundColor = titleBackgroundColor;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor{
    self.contentView.backgroundColor = contentBackgroundColor;
}

#pragma mark - set canSwitchWhenScrolling
- (void)setCanSwitchWhenScrolling:(BOOL)canSwitchWhenScrolling{
    if (_canSwitchWhenScrolling != canSwitchWhenScrolling) {
        if (!canSwitchWhenScrolling) {
            for (UISwipeGestureRecognizer *gesure in _canSwitchWhenScrollingGestures) {
                [self removeGestureRecognizer:gesure];
            }
            [_canSwitchWhenScrollingGestures removeAllObjects];
        }
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeLeft.delegate = self;
        [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRight.delegate = self;
        [self addGestureRecognizer:swipeRight];
        [self.canSwitchWhenScrollingGestures addObjectsFromArray:@[swipeLeft,swipeRight]];
    }
    _canSwitchWhenScrolling = canSwitchWhenScrolling;
}

#pragma mark - Swipe Gestures
- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture{
    if (_currentSelectedIndex == _contentViews.count - 1) {
        return;
    }
    
    UIScrollView *currentScrollView = (UIScrollView *)_contentViews[_currentSelectedIndex];
    if (currentScrollView.decelerating || currentScrollView.dragging) {
        currentScrollView.scrollEnabled = NO;
        [self selectItemAtIndex:_currentSelectedIndex + 1];
        
        currentScrollView.scrollEnabled = YES;
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture{
    if (_currentSelectedIndex == 0) {
        return;
    }
    
    UIScrollView *currentScrollView = (UIScrollView *)_contentViews[_currentSelectedIndex];
    if (currentScrollView.decelerating || currentScrollView.dragging) {
        currentScrollView.scrollEnabled = NO;
        [self selectItemAtIndex:_currentSelectedIndex - 1];
        
        currentScrollView.scrollEnabled = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - ALNTitleViewDelegate
- (NSInteger)numberOfItemsInTitleView:(ALNTitleView *)titleView{
    return _countOfItems;
}


- (nonnull Class<ALNTitleProtocol>)titleCellClass{
    return [_weakDelegate respondsToSelector:@selector(titleCellClass)] ? [_weakDelegate titleCellClass] : nil;
}


- (void)titleView:(ALNTitleView *)titleView
  configTitleCell:(UICollectionViewCell<ALNTitleProtocol> *)titleCell
         forIndex:(NSInteger)index{
    if ([_weakDelegate respondsToSelector:@selector(scrollView:configTitleCell:forIndex:)]) {
        [_weakDelegate scrollView:self
                  configTitleCell:titleCell
                         forIndex:index];
    }
}

- (void)titleView:(ALNTitleView *)titleView
didSelectItemAtIndex:(NSInteger)selectedIndex{
    if ([_weakDelegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
        [_weakDelegate scrollView:self
             didSelectItemAtIndex:selectedIndex];
    }
    //contentView offset
    [self.contentView selectItemAtIndex:selectedIndex];
    self.currentSelectedIndex = selectedIndex;
}


- (void)titleView:(ALNTitleView *)titleView
didUnselectItemAtIndex:(NSInteger)unselectedIndex{
    if ([_weakDelegate respondsToSelector:@selector(scrollView:didUnselectItemAtIndex:)]) {
        [_weakDelegate scrollView:self
           didUnselectItemAtIndex:unselectedIndex];
    }
}

- (void)contentView:(ALNContentView *)contentView
didSelectItemAtIndex:(NSInteger)selectedIndex{
    [self.titleView selectItemAtIndex:selectedIndex];
    if ([_weakDelegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
        [_weakDelegate scrollView:self
             didSelectItemAtIndex:selectedIndex];
    }
    self.currentSelectedIndex = selectedIndex;
}

- (void)contentView:(ALNContentView *)contentView
didUnselectItemAtIndex:(NSInteger)unselectedIndex{
    [self.titleView unselectItemAtIndex:unselectedIndex];
    if ([_weakDelegate respondsToSelector:@selector(scrollView:didUnselectItemAtIndex:)]) {
        [_weakDelegate scrollView:self
           didUnselectItemAtIndex:unselectedIndex];
    }
}

- (void)contentView:(ALNContentView *)contentView willSelectItemAtIndex:(NSInteger)index fromItemAtIndex:(NSInteger)fromIndex withRatio:(CGFloat)ratio{
    if ([_weakDelegate respondsToSelector:@selector(scrollView:willSelectItem:atIndex:fromItem:atFromIndex:withRatio:)]) {
        [_weakDelegate scrollView:self willSelectItem:[self.titleView titleCellAtIndex:index] atIndex:index fromItem:[self.titleView titleCellAtIndex:fromIndex] atFromIndex:fromIndex withRatio:fabs(ratio)];
    }
}

#pragma mark - ALNContentViewDelegate
- (NSInteger)numberOfItemsInContentView:(ALNContentView *)contentView{
    return _countOfItems;
}

- (BOOL)isIndexAvaliable:(NSInteger)index{
    return index < _countOfItems;
}

#pragma mark - lazy load
- (ALNTitleView *)titleView{
    if (!_titleView && _weakDelegate) {
        //0
        _titleView = [[ALNTitleView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        _titleView.titleViewDelegate = self;
        //4
        [self addSubview:_titleView];
    }
    return _titleView;
}

- (ALNContentView *)contentView{
    if (!_contentView && _weakDelegate) {
        _contentView = [[ALNContentView alloc]initWithContentViews:_contentViews];
        _contentView.contentViewDelegate = self;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (NSMutableArray *)canSwitchWhenScrollingGestures{
    if (!_canSwitchWhenScrollingGestures) {
        _canSwitchWhenScrollingGestures = [NSMutableArray array];
    }
    return _canSwitchWhenScrollingGestures;
}

#pragma mark - dealloc
- (void)dealloc{
    NSLog(@"%s",__func__);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
