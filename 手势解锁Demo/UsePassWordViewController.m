//
//  UsePassWordViewController.m
//  手势解锁Demo
//
//  Created by lance017 on 16/5/26.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import "UsePassWordViewController.h"

@interface UsePassWordViewController ()<PassWordViewDelegate>
//绘制密码的View
@property (nonatomic, strong) PassWordView *pwView;
@end

@implementation UsePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.pwView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view);
        make.width.equalTo(@(Screen_Width));
        make.bottom.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
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

- (void)usePasswordSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码输入成功" preferredStyle:UIAlertControllerStyleAlert];
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
        _pwView.type = PassWordTypeSetting;
        [self.view addSubview:_pwView];
    }
    return _pwView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
