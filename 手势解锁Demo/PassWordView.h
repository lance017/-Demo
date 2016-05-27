//
//  PassWordView.h
//  手势解锁Demo
//
//  Created by lance017 on 16/5/26.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

typedef NS_ENUM (NSInteger, PassWordType) {
    PassWordTypeSetting = 0,//设置密码
    PassWordTypeUsing = 1,//使用密码
};

@protocol PassWordViewDelegate <NSObject>
@optional
/**
 *  设置密码成功
 */
- (void)setPasswordSuccess;
/**
 *  使用密码成功
 */
- (void)usePasswordSuccess;
/**
 *  使用密码失败
 */
- (void)usePasswordFail;

@end

@interface PassWordView : UIView
//是否存在原有的密码
@property (nonatomic, assign) BOOL isFlag;

@property (nonatomic, assign) PassWordType type;

@property (nonatomic, assign) id<PassWordViewDelegate>delegate;

@end
