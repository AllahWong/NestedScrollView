//
//  ALNTestModel.h
//  NestedScrollView
//
//  Created by Allah on 2019/3/9.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALNTestModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic,getter=isSelected) BOOL selected;

@end

NS_ASSUME_NONNULL_END
