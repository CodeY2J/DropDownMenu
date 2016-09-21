//
//  WithTableViewController.m
//  DropDownMenuDemo
//
//  Created by Li Mingkai on 16/9/21.
//  Copyright © 2016年 com.game.lmk. All rights reserved.
//

#import "WithTableViewController.h"
#import "YXTDropDownMenu.h"
#import "DataViewController.h"

@interface WithTableViewController () <YXTDropDownMenuDelegate,YXTDropDownMenuDataSource>

@property (strong, nonatomic) NSMutableArray<NSString *> *menuTitles;

@property (strong, nonatomic) YXTDropDownMenu *dropDownMenu;
@property (strong, nonatomic) DataViewController *fenleiController;
@property (strong, nonatomic) DataViewController *paixuController;
@property (strong, nonatomic) DataViewController *shuaixuanController;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation WithTableViewController {
    BOOL _isLoad;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16"];
    }
    return _dataArray;
}

- (NSMutableArray<NSString *>*)menuTitles {
    if (!_menuTitles) {
        _menuTitles = [@[@"分类",@"排序",@"筛选"] mutableCopy];
    }
    return _menuTitles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dropDownMenu = [[YXTDropDownMenu alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), 40.0f)];
    _dropDownMenu.titleNormalColor = [UIColor greenColor];
    _dropDownMenu.titleSelectedColor = [UIColor blueColor];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self addChildViewCOntrollers];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isLoad) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 180)];
        imageView.image = [UIImage imageNamed:@"fanbingbing"];
        [self.tableView setTableHeaderView:imageView];
        
        _isLoad = YES;
    }
}

- (void)addChildViewCOntrollers {
    __weak typeof(self) weakSelf = self;
    _fenleiController = [[DataViewController alloc] init];
    _fenleiController.dataArray = @[@"快餐便当",@"特色菜系",@"异国料理",@"小吃夜宵"];
    _fenleiController.selectedStringBlock = ^(NSString *string) {
        weakSelf.menuTitles[0] = string;
        [weakSelf.dropDownMenu reloadData];
    };
    
    _paixuController = [[DataViewController alloc] init];
    _paixuController.dataArray = @[@"智能排序",@"距离最近",@"销量最高",@"人气最高"];
    _paixuController.selectedStringBlock = ^(NSString *string) {
        weakSelf.menuTitles[1] = string;
        [weakSelf.dropDownMenu reloadData];
    };
    
    _shuaixuanController = [[DataViewController alloc] init];
    _shuaixuanController.dataArray = @[@"品牌",@"新店",@"开发票",@"准时达"];
    _shuaixuanController.selectedStringBlock = ^(NSString *string) {
        weakSelf.menuTitles[2] = string;
        [weakSelf.dropDownMenu reloadData];
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _dropDownMenu;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YXTDropDownMenu datasource & delegate

- (NSInteger)numberOfColumnsInMenu:(YXTDropDownMenu *)dropDownMenu {
    return self.menuTitles.count;
}
- (NSString *)dropDownMenu:(YXTDropDownMenu *)dropDownMenu titleForColumnAtIndex:(NSInteger)index {
    return self.menuTitles[index];
}
- (UIView *)dropDownMenu:(YXTDropDownMenu *)dropDownMenu viewForColumnAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return _fenleiController.view;
        case 1:
            return _paixuController.view;
        case 2:
            return _shuaixuanController.view;
        default:
            break;
    }
    return nil;
}

- (CGFloat)dropDownMenu:(YXTDropDownMenu *)dropDownMenu heightForColumnAtIndex:(NSInteger)index {
    return 250.0f;
}

- (void)dropDownMenu:(YXTDropDownMenu *)dropDownMenu didSelectedAtIndex:(NSInteger)index opened:(BOOL)isOpened {
    NSLog(@"selected index is %ld,is open %d",index,isOpened);
}

@end
