//
//  DataViewController.h
//  DropDownMenuDemo
//
//  Created by Li Mingkai on 16/9/21.
//  Copyright © 2016年 com.game.lmk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void(^selectedStringBlock)(NSString *string);

@end
