//
//  NormalViewController.m
//  DropDownMenuDemo
//
//  Created by Li Mingkai on 16/9/21.
//  Copyright © 2016年 com.game.lmk. All rights reserved.
//

#import "NormalViewController.h"
#import "YXTDropDownMenu.h"
#import "DataViewController.h"

@interface NormalViewController () <YXTDropDownMenuDelegate,YXTDropDownMenuDataSource>
@property (weak, nonatomic) IBOutlet YXTDropDownMenu *dropDownMenu;
@property (strong, nonatomic) NSMutableArray<NSString *> *menuTitles;

@property (strong, nonatomic) DataViewController *fenleiController;
@property (strong, nonatomic) DataViewController *paixuController;
@property (strong, nonatomic) DataViewController *shuaixuanController;

@end

@implementation NormalViewController



- (NSMutableArray<NSString *>*)menuTitles {
    if (!_menuTitles) {
        _menuTitles = [@[@"分类",@"排序",@"筛选"] mutableCopy];
    }
    return _menuTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_dropDownMenu reloadData];
    [self addChildViewCOntrollers];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YXTDropDownMenu datasource & delegate

- (NSInteger)numberOfColumnsInMenu:(YXTDropDownMenu *)dropDownMenu {
    NSLog(@"日日日日日");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
