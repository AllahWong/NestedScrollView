//
//  ALNContentView.h
//  NestedScrollView
//
//  Created by Allah on 2019/3/7.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNContentProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class ALNContentView;

@protocol ALNContentViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInContentView:(ALNContentView *)contentView;

@optional
- (void)contentView:(ALNContentView *)contentView
didSelectItemAtIndex:(NSInteger)selectedIndex;
- (void)contentView:(ALNContentView *)contentView
didUnselectItemAtIndex:(NSInteger)unselectedIndex;
/**
 @param index ,the index will select
 @param fromIndex ,the index current selected
 @param ratio ,(the width which the will show item showed) / (the width of the item)
 */
- (void)contentView:(ALNContentView *)contentView
willSelectItemAtIndex:(NSInteger)index
    fromItemAtIndex:(NSInteger)fromIndex
          withRatio:(CGFloat)ratio;

@end
@interface ALNContentView : UICollectionView


@property (assign, nonatomic,readonly) NSInteger currentSelectedIndex;
@property (weak, nonatomic) id<ALNContentViewDelegate> contentViewDelegate;
/**
 titleSwitchAnimated :when YES,switch the item can see scrolling animation.default is YES.
 */
@property (assign, nonatomic,getter=isContentSwitchAnimated) BOOL contentSwitchAnimated; 
/**
 defaultSelectedIndex: default selectedIndex when first load,default 0
 */
@property (assign, nonatomic) NSInteger defaultSelectedIndex;
/**
 style of titles
 */
@property (assign, nonatomic) CGFloat minimumLineSpacing;
@property (assign, nonatomic) CGFloat minimumInteritemSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInset;
@property (assign, nonatomic) CGSize itemSize;

- (instancetype)initWithContentViews:(nullable NSArray<UIScrollView <ALNContentProtocol>*> *)contentViews;
- (void)selectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
