//
//  LFChooserView.m
//  LFChooserViewDemo
//
//  Created by LiuFeng on 16/1/20.
//  Copyright © 2016年 LiuFeng. All rights reserved.
//

#import "LFChooserView.h"

#define TABLEVIEW_HEIGHT 130
#define BUTTON_HEIGHT 40
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
typedef void(^ChooseBlock)(NSInteger indexOfDataAndButtons,NSIndexPath *indexPath);

@interface LFChooserView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSArray *cellTitles;

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger indexOfDataAndButton;
@end
@implementation LFChooserView

#pragma mark - 选择器对象的创建与配置
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.indexOfDataAndButton = 0;
        self.backgroundColor = [UIColor colorWithRed:1.000 green:0.989 blue:0.916 alpha:1.000];
    }
    return self;
}

+ (instancetype)shareChooserViewWith:(CGFloat)y{
    CGRect frame;
    CGPoint origin = frame.origin;
    origin.y = y;
    frame.origin = origin;
    
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = BUTTON_HEIGHT;
    LFChooserView *chooserView = [[LFChooserView alloc] initWithFrame:frame];
    return chooserView;
}

//设置按钮title
- (void)setTitlesOfButtonWith:(NSArray *)titles{
    for (int i=0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(dealBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        CGFloat X = SCREEN_WIDTH/3*i;
        CGFloat Y = 0;
        CGFloat W = SCREEN_WIDTH/3;
        CGFloat H = 40;
        button.frame = CGRectMake(X, Y, W, H);
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

- (void)setCellTitlesWith:(NSArray *)cellTitles{
    _cellTitles = cellTitles;
}

//button的点击事件
- (void)dealBtn:(UIButton *)button{
    self.indexOfDataAndButton = button.tag;
    [self showTableView];
}

//创建tableView
- (UITableView *)tableView{
    if (nil == _tableView) {
        CGFloat X = 0;
        CGFloat Y = BUTTON_HEIGHT;
        CGFloat W = SCREEN_WIDTH;
        CGFloat H = TABLEVIEW_HEIGHT;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(X, Y, W, H) style:UITableViewStylePlain];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor greenColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.hidden = YES;
        [self addSubview:tableView];
        
    }
    return _tableView;
}

#pragma mark - tableview代理方法的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.cellTitles[self.indexOfDataAndButton];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *title = self.cellTitles[self.indexOfDataAndButton][indexPath.row];

    cell.textLabel.text = title;
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hiddenTableView];
    if ([self.delegate respondsToSelector:@selector(chooserViewDidSelectColumnAtIndex:RowAtIndexPath:)]) {
        [self.delegate chooserViewDidSelectColumnAtIndex:self.indexOfDataAndButton RowAtIndexPath:indexPath];
    }
}

- (void)chooserViewDidSelectColumnAtIndex:(NSInteger)index RowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark - 自定义方法用于显示和隐藏tableview

//隐藏TableView
- (void)hiddenTableView{
    self.tableView.hidden = YES;
    CGRect frame = self.frame;
    frame.size.height = 40;
    self.frame = frame;
}

//显示刷新TableView
- (void)showTableView{
    self.tableView.hidden = NO;
    CGRect frame = self.frame;
    frame.size.height = 170;
    self.frame = frame;
    [self.superview bringSubviewToFront:self];
    [self.tableView reloadData];
}
@end

