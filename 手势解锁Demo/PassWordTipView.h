//
//  PassWordTipView.h
//  手势解锁Demo
//
//  Created by lance017 on 16/5/27.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordTipView : UIView
/**
 *  根据绘制的密码给View标注不同的颜色
 *
 *  @param password 绘制的密码
 */
- (void)setForViewDifferentColorToPassword:(NSString *)password;

@end
