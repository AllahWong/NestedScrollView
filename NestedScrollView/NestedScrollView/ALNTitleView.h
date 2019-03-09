//
//  ALNTitleView.h
//  NestedScrollView
//
//  Created by Allah on 2019/3/7.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNTitleProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class ALNTitleView;


@protocol ALNTitleViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInTitleView:(ALNTitleView *)titleView;
/**
 title item must be subclass of UICollectionViewCell,and implement ALNTitleProtocol.
 
 @return the class of title item
 */
- (nonnull Class<ALNTitleProtocol>)titleCellClass;

@optional
/**
 callback when the method cellForItemAtIndexPath in titleView is excuted,you can update title item here.
 
 @param titleView self
 @param titleCell currentcell returned by cellForItemAtIndexPath
 @param index indexPath.row in cellForItemAtIndexPath
 */
- (void)titleView:(ALNTitleView *)titleView
  configTitleCell:(UICollectionViewCell<ALNTitleProtocol> *)titleCell
         forIndex:(NSInteger)index;
- (void)titleView:(ALNTitleView *)titleView
didSelectItemAtIndex:(NSInteger)selectedIndex;
- (void)titleView:(ALNTitleView *)titleView
didUnselectItemAtIndex:(NSInteger)unselectedIndex;

@end

@interface ALNTitleView : UICollectionView

@property (weak, nonatomic) id<ALNTitleViewDelegate> titleViewDelegate;
@property (assign, nonatomic,readonly) NSInteger currentSelectedIndex;
/**
 titleSwitchAnimated :when YES,switch the item can see scrolling animation.default is YES.
 */
@property (assign, nonatomic,getter=isTitleSwitchAnimated) BOOL titleSwitchAnimated;
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


- (void)selectItemAtIndex:(NSInteger)index;
- (void)unselectItemAtIndex:(NSInteger)index;
- (UICollectionViewCell <ALNTitleProtocol> *)titleCellAtIndex:(NSInteger)index;





@end

NS_ASSUME_NONNULL_END
