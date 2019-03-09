//
//  ALNTestCell.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/7.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import "ALNTestCell.h"
#import "ALNTitleProtocol.h"
#import "ALNTestModel.h"
@interface ALNTestCell ()<ALNTitleProtocol>


@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) ALNTestModel *model;

@end

@implementation ALNTestCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_titleLabel];
        self.backgroundColor = [UIColor magentaColor];
    }
    return self;
}



- (void)configure:(ALNModel *)model{
    _model = (ALNTestModel *)model;
    _titleLabel.text = ((ALNTestModel *)model).title;
    if ([_model isSelected]) {
        [self selected];
    }
    else{
        [self unSelected];
    }
}


- (void)selected{
    _titleLabel.textColor = [UIColor redColor];
    NSLog(@"%s",__func__);

}

- (void)unSelected{
    _titleLabel.textColor = [UIColor blackColor];
    NSLog(@"%s",__func__);

}

- (void)setColor:(UIColor *)corlor{
    _titleLabel.textColor = corlor;
}

@end
