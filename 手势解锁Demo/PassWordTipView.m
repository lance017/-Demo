//
//  PassWordTipView.m
//  手势解锁Demo
//
//  Created by lance017 on 16/5/27.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import "PassWordTipView.h"

@interface PassWordTipView ()
//view数组
@property (nonatomic, strong) NSMutableArray * viewsArray;

@end

@implementation PassWordTipView

- (NSMutableArray *)viewsArray {
    if (!_viewsArray) {
        _viewsArray = [[NSMutableArray alloc]init];
    }
    return _viewsArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        for (NSInteger index = 0; index < 9; index ++) {
            UIView *view = [[UIView alloc]init];
            view.tag = index + 1;
            [self.viewsArray addObject:view];
            [self addSubview:view];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger columns = 3;
    for (NSInteger index = 0; index < self.viewsArray.count; index ++) {
        UIView *view = self.viewsArray[index];
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 3.5;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.masksToBounds = YES;
        NSInteger row = index / columns;
        NSInteger col = index % columns;
        CGFloat x = col * (7 + 3.5);
        CGFloat y = row * (7 + 3.5);
        view.frame = CGRectMake(x, y, 7, 7);
    }
}

- (void)setForViewDifferentColorToPassword:(NSString *)password {
    for (NSInteger index = 0; index < password.length; index ++) {
        NSString *str = [password substringWithRange:NSMakeRange(index, 1)];
        UIView *view = self.viewsArray[[str integerValue] - 1];
        view.layer.borderWidth = 0;
        view.backgroundColor = [UIColor blueColor];
    }
}


@end
