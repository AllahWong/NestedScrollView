//
//  ALNScrollView.h
//  NestedScrollView
//
//  Created by Allah on 2019/3/6.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNTitleProtocol.h"
#import "ALNContentProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class ALNScrollView;


@protocol ALNScrollViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInScrollView:(ALNScrollView *)scrollView;

/**
 title item must be subclass of UICollectionViewCell,and implement ALNTitleProtocol.

 @return the class of title item
 */
- (nonnull Class<ALNTitleProtocol>)titleCellClass;

@optional


/**
 callback when the method cellForItemAtIndexPath in titleView is excuted,you can update title item here.

 @param scrollView self
 @param titleCell currentcell returned by cellForItemAtIndexPath
 @param index indexPath.row in cellForItemAtIndexPath
 */
- (void)scrollView:(ALNScrollView *)scrollView
   configTitleCell:(UICollectionViewCell<ALNTitleProtocol> *)titleCell
          forIndex:(NSInteger)index;

- (void)scrollView:(ALNScrollView *)scrollView
didSelectItemAtIndex:(NSInteger)selectedIndex;
- (void)scrollView:(ALNScrollView *)scrollView
didUnselectItemAtIndex:(NSInteger)unselectedIndex;

/**
 @param index ,the index will select
 @param fromIndex ,the index current selected
 @param ratio ,(the width which the will show item showed) / (the width of the item)
 */
- (void)scrollView:(ALNScrollView *)scrollView
    willSelectItem:(UICollectionViewCell <ALNTitleProtocol> *)item
           atIndex:(NSInteger)index
          fromItem:(UICollectionViewCell <ALNTitleProtocol> *)fromItem
       atFromIndex:(NSInteger)fromIndex
         withRatio:(CGFloat)ratio;


@end


@interface ALNScrollView : UIView


/**
 delegate:  need to be set first
 */
@property (weak, nonatomic) id<ALNScrollViewDelegate> delegate;
@property (assign, nonatomic,readonly) NSInteger currentSelectedIndex;

/**
 titleSwitchAnimated :when YES,switch the item can see scrolling animation.default is YES.
 */
@property (assign, nonatomic,getter=isTitleSwitchAnimated) BOOL titleSwitchAnimated;
/**
 contentSwitchAnimated :when YES,switch the item can see scrolling animation.default is YES.
 */
@property (assign, nonatomic,getter=isContentSwitchAnimated) BOOL contentSwitchAnimated;

@property (assign, nonatomic) CGRect titleViewFrame;
@property (assign, nonatomic) CGRect contentViewFrame;


/**
 defaultSelectedIndex: default selectedIndex when first load,default 0
 */
@property (assign, nonatomic) NSInteger defaultSelectedIndex;

/**
 canSwitchWhenScrolling:when YES,when the sub scrollView in the contentView isScrolling ,you still can switch item by swipe.
 */
@property (assign, nonatomic,getter=isCanSwitchWhenScrolling) BOOL canSwitchWhenScrolling;  //default YES



/**
 style of titles
 */
@property (assign, nonatomic) CGFloat titleMinimumLineSpacing;
@property (assign, nonatomic) CGFloat titleMinimumInteritemSpacing;
@property (assign, nonatomic) UIEdgeInsets titleSectionInset;
@property (assign, nonatomic) CGSize titleItemSize;

/**
 style of contents
 */
@property (assign, nonatomic) CGFloat contentMinimumLineSpacing;
@property (assign, nonatomic) CGFloat contentMinimumInteritemSpacing;
@property (assign, nonatomic) UIEdgeInsets contentSectionInset;
@property (assign, nonatomic) CGSize contentItemSize;

@property (strong, nonatomic) UIColor *titleBackgroundColor;
@property (strong, nonatomic) UIColor *contentBackgroundColor;


/**
 init with contentViews
 @param contentViews the view in which is subclass of UIScrollView,and implement ALNContentProtocol Protocol
 @return self
 */
- (instancetype)initWithContentViews:(NSArray<UIScrollView <ALNContentProtocol>*> *)contentViews;
- (void)selectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
