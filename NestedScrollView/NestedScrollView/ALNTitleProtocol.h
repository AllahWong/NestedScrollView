//
//  ALNTitleProtocol.h
//  NestedScrollView
//
//  Created by Allah on 2019/3/7.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALNTitleProtocol <NSObject>

- (void)configure:(ALNModel *)model;

- (void)selected;
- (void)unSelected;

@end

NS_ASSUME_NONNULL_END
