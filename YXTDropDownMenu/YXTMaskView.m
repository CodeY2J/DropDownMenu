//
//  YXTCoverView.m
//  Youeryuandaquan
//
//  Created by Limingkai on 16/9/19.
//  Copyright © 2016年 sinosoft. All rights reserved.
//

#import "YXTMaskView.h"

@implementation YXTMaskView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.viewDidTappedHandle) {
        self.viewDidTappedHandle();
    }
}

@end
