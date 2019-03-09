//
//  ViewController.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/6.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "ALNScrollView.h"
#import "ALNTestCell.h"
#import "ALNTestContent.h"
#import "UIColor+Test.h"
#import "ALNTestTableView.h"
#import "ALNTestModel.h"

@interface ViewController ()<ALNScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _titles = [NSMutableArray array];
//    NSMutableArray *scrollViews = [NSMutableArray array];
//    NSArray *colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor grayColor],[UIColor redColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],];
//    for (int i = 0; i < 9; i++) {
//        ALNTestContent *scroll = [[ALNTestContent alloc]init];
//        scroll.backgroundColor = colors[i];
//        [scroll setFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
//        [scrollViews addObject:scroll];
//    }
//
    NSMutableArray *tableViews = [@[] mutableCopy];
    for (int i = 0; i < 9; i ++) {
        ALNTestTableView *table = [[ALNTestTableView alloc]init];
        NSMutableArray *datasArray = [NSMutableArray array];
        for (int j = 0; j < 30; j ++) {
            [datasArray addObject:[NSString stringWithFormat:@" 测试 %i ,行 %i",i ,j]];
        }
        table.datas = datasArray;
        [table setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 70)]; //frame要与contentViewFram
        [tableViews addObject:table];
        
        ALNTestModel *model = [[ALNTestModel alloc]init];
        model.title = [NSString stringWithFormat:@"%i",i];
        [_titles addObject:model];
    }
    
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
}



#pragma mark - ALNScrollViewDelegate
- (NSInteger)numberOfItemsInScrollView:(ALNScrollView *)scrollView{
    return _titles.count;
}

- (void)scrollView:(ALNScrollView *)scrollView configTitleCell:(UICollectionViewCell<ALNTitleProtocol> *)titleCell forIndex:(NSInteger)index
{
    [titleCell configure:_titles[index]];
}

- (nonnull Class<ALNTitleProtocol>)titleCellClass{
    return ALNTestCell.class;
}

- (void)scrollView:(ALNScrollView *)scrollView didSelectItemAtIndex:(NSInteger)selectedIndex{
    ((ALNTestModel *)_titles[selectedIndex]).selected = YES;

}

- (void)scrollView:(ALNScrollView *)scrollView didUnselectItemAtIndex:(NSInteger)unselectedIndex{
    ((ALNTestModel *)_titles[unselectedIndex]).selected = NO;
}

- (void)scrollView:(ALNScrollView *)scrollView willSelectItem:(Class<ALNTitleProtocol>)item atIndex:(NSInteger)index fromItem:(Class<ALNTitleProtocol>)fromItem atFromIndex:(NSInteger)fromIndex withRatio:(CGFloat)ratio{
    ALNTestCell *cell = (ALNTestCell *)item;
    [cell setColor:[self interpolationColorFrom:[UIColor blackColor] to:[UIColor redColor] percent:ratio]];
    
    ALNTestCell *fromCell = (ALNTestCell *)fromItem;
    [fromCell setColor:[self interpolationColorFrom:[UIColor redColor] to:[UIColor blackColor] percent:ratio]];
    
}

#pragma mark - Test Color
- (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from) * percent;
}

- (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.test_red to:toColor.test_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.test_green to:toColor.test_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.test_blue to:toColor.test_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.test_alpha to:toColor.test_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
