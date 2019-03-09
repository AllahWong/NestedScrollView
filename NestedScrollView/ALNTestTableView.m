//
//  ALNTestTableView.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/9.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import "ALNTestTableView.h"
#import "ALNContentProtocol.h"

@interface ALNTestTableView ()<ALNContentProtocol,UITableViewDelegate,UITableViewDataSource>



@end

@implementation ALNTestTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)configure{
    
}

- (void)selected{
    
}
- (void)unSelected{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)];
    }
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}
@end
