//
//  PassWordView.m
//  手势解锁Demo
//
//  Created by lance017 on 16/5/26.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import "PassWordView.h"


@interface PassWordView ()
//所有按钮
@property (nonatomic, strong) NSMutableArray *buttonsArray;
//选中的按钮
@property (nonatomic, strong) NSMutableArray *selectButtonsArray;
//当前的点
@property (nonatomic, assign) CGPoint currentPoint;
//开始的点
@property (nonatomic, assign) CGPoint startPoint;
//结束的点
@property (nonatomic, assign) CGPoint endPoint;
//密码错误的次数
@property (nonatomic, assign) NSInteger errorFrequency;
//设置密码时，第一次设置的密码
@property (nonatomic, strong) NSString *fristPassWordStr;
//当前设置的密码
@property (nonatomic, strong) NSMutableString *passWordStr;
//提示信息的Label
@property (nonatomic, strong) UILabel * titleLabel;
//重置密码提示View
@property (nonatomic, strong) PassWordTipView *pwtView;
//绘制新的密码第几次输入
@property (nonatomic, assign) NSInteger frequency;

@end

@implementation PassWordView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.errorFrequency = 0;
        
        [self.pwtView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.centerX.equalTo(self);
            make.width.equalTo(@28);
            make.height.equalTo(@28);
        }];
        self.pwtView.hidden = YES;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.top.equalTo(self.pwtView.mas_bottom).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-10);
        }];
        
        for (NSInteger index = 0; index < 9; index ++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.tag = index + 1;
            btn.userInteractionEnabled = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            [self.buttonsArray addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置每个按钮的frame
    CGFloat margin = 15;
    // 列（和行）的个数
    int columns = 3;
    // 计算水平方向和垂直方向的间距
    CGFloat W = (self.frame.size.width - (columns+1) * margin) / columns;
    CGFloat H = W;
    CGFloat startY = CGRectGetMaxY(self.titleLabel.frame);
    for (NSInteger index = 0; index < self.buttonsArray.count; index ++) {
        UIButton* button = self.buttonsArray[index];
        NSInteger row = index / columns;
        NSInteger col = index % columns;
        CGFloat x = margin + col * (W + margin);
        CGFloat y = startY + margin + row * (H + margin);
        button.frame = CGRectMake(x, y, W, H);
    }
    if (self.type == PassWordTypeSetting) {
        if (_isFlag) {
            //有原手势密码
            self.titleLabel.text = @"请输入原手势密码";
            self.titleLabel.textColor = [UIColor blueColor];
            self.frequency = 0;
            self.errorFrequency = 0;
        }else{
            //没有原手势密码
            [self setNewPassWord];
        }
    }else{
        self.titleLabel.text = @"请输入手势密码";
        self.titleLabel.textColor = [UIColor blueColor];
        self.errorFrequency = 0;
    }
    
    
}

#pragma mark - 绘制新的解锁密码

- (void)setNewPassWord {
    self.titleLabel.text = @"绘制新的解锁图案";
    self.titleLabel.textColor = [UIColor blueColor];
    self.frequency = 1;
}

#pragma mark 抖动动画

- (void)shakeAnimationForView:(UIView *) view {
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:0.1];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}


#pragma mark - 绘图方法

- (void)drawRect:(CGRect)rect {
    if (self.selectedbuttonsArray.count==0)return;
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [[UIColor blueColor] set];
    for (NSInteger index = 0; index < self.selectButtonsArray.count; index ++) {
        UIButton *button = self.selectButtonsArray[index];
        if (index == 0) {
            [path moveToPoint:button.center];
        }else {
            [path addLineToPoint:button.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

#pragma mark - 触摸方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    self.startPoint = point;
    for (NSInteger index = 0; index < self.buttonsArray.count; index ++ ) {
        UIButton *button = self.buttonsArray[index];
        if (CGRectContainsPoint(button.frame, point) && !button.selected) {
            button.selected = YES;
            [self.selectButtonsArray addObject:button];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    self.currentPoint = point;
    for (NSInteger index = 0; index < self.buttonsArray.count; index ++ ) {
        UIButton *button = self.buttonsArray[index];
        if (CGRectContainsPoint(button.frame, point) && !button.selected) {
            button.selected = YES;
            [self.selectButtonsArray addObject:button];
            break;
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    for (NSInteger index = 0; index < self.buttonsArray.count; index ++ ) {
        UIButton *button = self.buttonsArray[index];
        if (CGRectContainsPoint(button.frame, point) && !button.selected) {
            button.selected = YES;
            [self.selectButtonsArray addObject:button];
        }
    }
    [self setNeedsDisplay];
    for (UIButton *button in self.buttonsArray) {
        if (CGRectContainsPoint(button.frame, self.startPoint)) {
            [self judgePassword];
            break;
        }
    }
}

#pragma mark - 将绘制的图案拼接成字符串，传递到ViewController界面

- (void)judgePassword {
    self.passWordStr = [[NSMutableString alloc]init];
    [self.selectButtonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [self.passWordStr appendFormat:@"%@",@(button.tag)];
    }];
    //判断是什么状态
    if (self.type == PassWordTypeSetting) {
        //设置密码
        [self checkPassword];
    }else{
        //使用密码
        [self usePassword];
    }
    
    for (UIButton *btn in self.selectedbuttonsArray) {
        btn.selected = NO;
    }
    [self.selectButtonsArray removeAllObjects];
}

#pragma mark - 设置密码

- (void)checkPassword {
    if (self.frequency == 0) {
        //输入原手势密码
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"PassWord"] isEqualToString:self.passWordStr]) {
            //与原手势密码相同,绘制新的解锁密码
            [self setNewPassWord];
        }else{
            //密码错误
            if (self.errorFrequency == 4) {
                //输入错误五次
                [self.delegate usePasswordFail];
            }else{
                self.errorFrequency ++;
                [UIView animateWithDuration:1.0f animations:^{
                    self.titleLabel.text = [NSString stringWithFormat:@"输入密码错误，还可以输入%zi次",5 - self.errorFrequency];
                    self.titleLabel.textColor = [UIColor redColor];
                } completion:^(BOOL finished) {
                    [self shakeAnimationForView:self.titleLabel];
                }];
            }
        }
    }else if (self.frequency == 1) {
        //第一次绘制图案
        if (self.passWordStr.length < 4) {
            //绘制的图案小于四个
            [UIView animateWithDuration:1.0f animations:^{
                self.titleLabel.text = @"至少连接4个点，请重新输入";
                self.titleLabel.textColor = [UIColor redColor];
            } completion:^(BOOL finished) {
                [self shakeAnimationForView:self.titleLabel];
            }];
        }else{
            //绘制的图案合法
            self.titleLabel.text = @"再次绘制解锁图案";
            self.titleLabel.textColor = [UIColor blueColor];
            self.fristPassWordStr = self.passWordStr;
            self.frequency = 2;
            self.pwtView.hidden = NO;
            [self.pwtView setForViewDifferentColorToPassword:self.passWordStr];
        }
    }else if (self.frequency == 2) {
        //第二次绘制图案
        if ([self.fristPassWordStr isEqualToString:self.passWordStr]) {
            
            //与第一次绘制的密码相同,保存
            [[NSUserDefaults standardUserDefaults]setObject:self.passWordStr forKey:@"PassWord"];
            [self.delegate setPasswordSuccess];
            self.pwtView.hidden = YES;
        }else{
            //与第一次绘制的密码不相同
            [UIView animateWithDuration:1.0f animations:^{
                self.titleLabel.text = @"与上一次绘制不一致，请重新绘制";
                self.titleLabel.textColor = [UIColor redColor];
            } completion:^(BOOL finished) {
                [self shakeAnimationForView:self.titleLabel];
            }];
        }
    }
}

#pragma mark - 使用密码
- (void)usePassword {
    //输入原手势密码
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"PassWord"] isEqualToString:self.passWordStr]) {
        //与原手势密码相同,绘制新的解锁密码
        [self setNewPassWord];
    }else{
        //密码错误
        if (self.errorFrequency == 4) {
            //输入错误五次
            [self.delegate usePasswordFail];
        }else{
            self.errorFrequency ++;
            [UIView animateWithDuration:1.0f animations:^{
                self.titleLabel.text = [NSString stringWithFormat:@"输入密码错误，还可以输入%zi次",5 - self.errorFrequency];
                self.titleLabel.textColor = [UIColor redColor];
            } completion:^(BOOL finished) {
                [self shakeAnimationForView:self.titleLabel];
            }];
        }
    }
}


#pragma mark - Getting With Setting

- (NSMutableArray *)buttonsArray{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}
- (NSMutableArray *)selectedbuttonsArray{
    if (!_selectButtonsArray) {
        _selectButtonsArray = [NSMutableArray array];
    }
    return _selectButtonsArray;
}
- (PassWordTipView *)pwtView {
    if (!_pwtView) {
        _pwtView = [[PassWordTipView alloc]init];
        [self addSubview:_pwtView];
    }
    return _pwtView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
