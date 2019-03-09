//
//  ALNContentProtocol.h
//  NestedScrollView
//
//  Created by Allah on 2019/3/8.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALNContentProtocol <NSObject>

- (void)configure;

- (void)selected;
- (void)unSelected;

@end

NS_ASSUME_NONNULL_END
