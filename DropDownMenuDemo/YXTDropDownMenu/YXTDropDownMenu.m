//
//  YXTDropDownMenu.m
//  Youeryuandaquan
//
//  Created by Limingkai on 16/9/19.
//  Copyright © 2016年 sinosoft. All rights reserved.
//

#import "YXTDropDownMenu.h"


#define DefaultSeparateLineColor [UIColor colorWithRed:221.0f / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1]
#define DefaultMaskColor [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:.5]

static CGFloat const SeparateLineMargin = 10;
static CGFloat const DefaultCotentViewHeight = 200;


@interface YXTMaskView : UIView

@property (nonatomic, copy) void(^viewDidTappedHandle)(void);

@end

@implementation YXTMaskView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.viewDidTappedHandle) {
        self.viewDidTappedHandle();
    }
}

@end


@interface YXTDropDownMenu ()

@property (nonatomic, strong) YXTMaskView *maskView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *menuButtons;
@property (nonatomic, strong) NSMutableArray<UIView *> *separateLines;

@end

@implementation YXTDropDownMenu

#pragma mark - Lazy Initial

- (UIView *)maskView {
    if (!_maskView) {
        CGFloat maskViewY = 0;
        CGFloat maskViewHeight = 0;
        if ([self.superview isKindOfClass:[UITableView class]]) {

            UITableView *tableView = (UITableView *)self.superview;
            maskViewY = CGRectGetHeight(self.frame) + tableView.contentOffset.y +  + tableView.contentInset.top;
            maskViewHeight = CGRectGetHeight(self.superview.frame) - CGRectGetHeight(self.frame);
        } else {
            maskViewY = CGRectGetMaxY(self.frame);
            maskViewHeight = CGRectGetHeight(self.superview.frame) - CGRectGetMaxY(self.frame);
        }
        CGFloat maskViewWidth = CGRectGetWidth(self.superview.bounds);
        _maskView = [[YXTMaskView alloc] initWithFrame:CGRectMake(0, maskViewY, maskViewWidth, maskViewHeight)];
        _maskView.backgroundColor = _maskColor;
        __weak typeof(self) weakSelf = self;
        _maskView.viewDidTappedHandle  = ^{
            [weakSelf dismiss];
        };
    }
    return _maskView;
}

- (NSMutableArray<UIButton *> *)menuButtons {
    if (!_menuButtons) {
        _menuButtons = [NSMutableArray arrayWithCapacity:3];
    }
    return _menuButtons;
}

- (NSMutableArray<UIView *> *)separateLines {
    if (!_separateLines) {
        _separateLines = [NSMutableArray arrayWithCapacity:2];
    }
    return _separateLines;
}

#pragma mark - Initial

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        [self reloadData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.menuButtons.count == 0) {
        return;
    }
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonWidth = CGRectGetWidth(self.frame)/ self.menuButtons.count;
    CGFloat buttonHeight = CGRectGetHeight(self.frame);
    
    for (NSInteger i = 0; i < self.menuButtons.count; i++) {
        UIButton *button = self.menuButtons[i];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        buttonX = CGRectGetMaxX(button.frame);
        
        //必须得调用一下titlelabel和imageview才能获取到他们的frame，非常奇怪。。。
        button.titleLabel.backgroundColor = button.backgroundColor;
        button.imageView.backgroundColor = button.backgroundColor;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,CGRectGetWidth(button.titleLabel.frame) + 3, 0, -(CGRectGetWidth(button.titleLabel.frame) + 3));
        button.titleEdgeInsets = UIEdgeInsetsMake(0,  -(CGRectGetWidth(button.imageView.frame) + 3), 0, CGRectGetWidth(button.imageView.frame) + 3);
    }
    
    CGFloat separateLineHeight = CGRectGetHeight(self.frame) - 2 * SeparateLineMargin;
    for (NSInteger i = 0;i < self.separateLines.count;i++) {
        UIView *separateLine = self.separateLines[i];
        CGFloat separateLineX = CGRectGetMaxX(self.menuButtons[i].frame);
        separateLine.frame = CGRectMake(separateLineX,SeparateLineMargin, 1.0f, separateLineHeight);
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reloadData];
}

//- (void)didMoveToSuperview:(UIView *)newSuperview {
//    [super didMoveToSuperview:newSuperview];
//    [self reloadData];
//}

#pragma mark - Setter

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - Privats Methods

- (void)setup {
   
    _titleNormalColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor redColor];
    _titleFont = [UIFont systemFontOfSize:11.0f];
    _separateLineColor = DefaultSeparateLineColor;
    _maskColor = DefaultMaskColor;
    self.normalImage = [UIImage imageNamed:@"arrow_down"];
    self.selectedImage = [UIImage imageNamed:@"arrow_up"];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)reset {
    
    if ([self.superview isKindOfClass:[UITableView class]]) {
        [(UITableView *)self.superview setScrollEnabled:YES];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.maskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.maskView removeFromSuperview];
    self.maskView = nil;
    [self.menuButtons removeAllObjects];
    [self.separateLines removeAllObjects];
}

#pragma mark - IBActions

- (IBAction)buttonPressed:(UIButton *)button {
    
    if (button.isSelected) {
        button.selected = NO;
        [self dismiss];
    } else {
        [self.menuButtons enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
            [item setSelected:NO];
            [item.imageView setTintColor:self.titleNormalColor];
        }];
        
        button.selected = YES;
        [button.imageView setTintColor:self.titleSelectedColor];
        [self.maskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        
        if([self.superview isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.superview;
            [tableView setScrollEnabled:NO];
            if (self.frame.origin.y != (tableView.contentOffset.y + tableView.contentInset.top)) {
                [tableView setContentOffset:CGPointMake(0, self.frame.origin.y - tableView.contentInset.top)];
            }
        }
        [self.superview addSubview:self.maskView];
       
        if (![self.dataSource respondsToSelector:@selector(dropDownMenu:viewForColumnAtIndex:)]) {
            NSString *reason = @"未实现 dropDownMenu:viewForColumnAtIndex:";
            @throw [NSException exceptionWithName:NSGenericException reason:reason userInfo:nil];
            return;
        }
        NSInteger index = button.tag - 1000;
        UIView *contentView = [self.dataSource dropDownMenu:self viewForColumnAtIndex:index];
        CGFloat contentViewHeight = DefaultCotentViewHeight;
        if ([self.dataSource respondsToSelector:@selector(dropDownMenu:heightForColumnAtIndex:)]) {
            contentViewHeight = [self.delegate dropDownMenu:self heightForColumnAtIndex:index];
        }
        contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maskView.frame), 0);
        [self.maskView addSubview:contentView];
        [UIView animateWithDuration:0.25 animations:^{
            contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maskView.frame), contentViewHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectedAtIndex:opened:)]) {
        [self.delegate dropDownMenu:self didSelectedAtIndex:button.tag - 1000 opened:button.isSelected];
    }
    
    if (self.selectedIndexBlock) {
        self.selectedIndexBlock(button.tag - 1000,button.isSelected);
    }
}

#pragma mark - Public Methods

- (void)dismiss {
    
    [self.menuButtons enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
        [item setSelected:NO];
        [item.imageView setTintColor:_titleNormalColor];
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.maskView.subviews.firstObject.frame;
        frame.size.height = 0;
        self.maskView.subviews.firstObject.frame = frame;
    } completion:^(BOOL finished) {
        [self.maskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        if([self.superview isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.superview;
            [tableView setScrollEnabled:YES];
        }
    }];
}


- (void)reloadData {
    
    [self reset];
    
    if (self.dataSource == nil)
        return;
    NSInteger columns = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        columns = [self.dataSource numberOfColumnsInMenu:self];
    }
    if (columns == 0)
        return;
    if (![self.dataSource respondsToSelector:@selector(dropDownMenu:viewForColumnAtIndex:)]) {
        NSString *reason = @"未实现 dropDownMenu:viewForColumnAtIndex:";
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    if (![self.dataSource respondsToSelector:@selector(dropDownMenu:titleForColumnAtIndex:)]) {
        NSString *reason = @"未实现 dropDownMenu:titleForColumnAtIndex:";
        @throw [NSException exceptionWithName:NSGenericException reason:reason userInfo:nil];
        return;
    }
    for (NSInteger i = 0; i < columns; i++) {
        NSString *title = [self.dataSource dropDownMenu:self titleForColumnAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        [button.titleLabel setFont:_titleFont];
        [button setImage:self.normalImage forState:UIControlStateNormal];
        [button setImage:self.selectedImage forState:UIControlStateSelected];
        [button.imageView setTintColor:_titleNormalColor];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuButtons addObject:button];
        [self addSubview:button];
    }
    
    for (NSInteger i = 1;i < columns;i++) {
        UIView *separateLine = [UIView new];
        separateLine.backgroundColor = _separateLineColor;
        [self.separateLines addObject:separateLine];
        [self addSubview:separateLine];
    }
    [self setNeedsLayout];
    
}

@end
