---
# NestedScrollView
---

A Nested ScrollView
---
类似今日头条多个滚动试图嵌套
---
 主要功能：
    将标题和滚动的内容封装起来，组合成一个新的组件。
---
 预览
---
 ![image](https://github.com/AllahWong/NestedScrollView/blob/master/preview.png)
----
基本使用：
----
    ALNScrollView *nestedScrollView = [[ALNScrollView alloc]initWithContentViews:tableViews];
    [nestedScrollView setFrame:self.view.bounds];
    nestedScrollView.delegate = self;
    nestedScrollView.defaultSelectedIndex = 5;
    nestedScrollView.titleSwitchAnimated = YES;
    nestedScrollView.contentSwitchAnimated = YES;
    [nestedScrollView setTitleViewFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
    [nestedScrollView setContentViewFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 70)];
    nestedScrollView.canSwitchWhenScrolling = YES;
    [nestedScrollView setTitleMinimumLineSpacing:3.0f];
    [nestedScrollView setTitleMinimumInteritemSpacing:3.0f];
    [nestedScrollView setTitleSectionInset:UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f)];
    [nestedScrollView setTitleItemSize:CGSizeMake(100, 50)];
    [nestedScrollView setContentMinimumLineSpacing:0.0f];
    [nestedScrollView setContentItemSize:CGSizeMake(nestedScrollView.contentViewFrame.size.width, nestedScrollView.contentViewFrame.size.height)];
    
    [self.view addSubview:nestedScrollView];
    
   
