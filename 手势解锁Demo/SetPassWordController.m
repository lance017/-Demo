//
//  SetPassWordController.m
//  手势解锁Demo
//
//  Created by lance017 on 16/5/26.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import "SetPassWordController.h"

@interface SetPassWordController ()<PassWordViewDelegate>
//绘制密码的View
@property (nonatomic, strong) PassWordView *pwView;
@end

@implementation SetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.pwView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view);
        make.width.equalTo(@(Screen_Width));
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - PassWordView Delegate

- (void)usePasswordFail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你已经输入密码错误到达五次" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setPasswordSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码设置成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getting With Setting

- (PassWordView *)pwView {
    if (!_pwView) {
        _pwView = [[PassWordView alloc]init];
        _pwView.delegate = self;
        //控制是否存在原有的密码  YES 存在 NO 不存在
        _pwView.isFlag = self.isFlag;
        _pwView.type = PassWordTypeSetting;
        [self.view addSubview:_pwView];
    }
    return _pwView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
