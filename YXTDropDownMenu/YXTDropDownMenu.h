//
//  YXTDropDownMenu.h
//  Youeryuandaquan
//
//  Created by Limingkai on 16/9/19.
//  Copyright © 2016年 sinosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXTDropDownMenu;

@protocol YXTDropDownMenuDataSource <NSObject>

@required

- (NSInteger)numberOfColumnsInMenu:(YXTDropDownMenu *)dropDownMenu;
- (NSString *)dropDownMenu:(YXTDropDownMenu *)dropDownMenu titleForColumnAtIndex:(NSInteger)index;
- (UIView *)dropDownMenu:(YXTDropDownMenu *)dropDownMenu viewForColumnAtIndex:(NSInteger)index;

@end

@protocol YXTDropDownMenuDelegate <NSObject>

- (CGFloat)dropDownMenu:(YXTDropDownMenu *)dropDownMenu heightForColumnAtIndex:(NSInteger)index;
- (void)dropDownMenu:(YXTDropDownMenu *)dropDownMenu didSelectedAtIndex:(NSInteger)index opened:(BOOL)isOpened;

@end

typedef void(^SelectedIndexHandle)(NSInteger index,BOOL isOpened);

@interface YXTDropDownMenu : UIView

@property (nonatomic, weak) IBOutlet id <YXTDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <YXTDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIColor *separateLineColor;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, copy) SelectedIndexHandle selectedIndexBlock;

- (void)reloadData;
- (void)dismiss;

@end
