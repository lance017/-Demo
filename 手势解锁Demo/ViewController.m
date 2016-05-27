//
//  ViewController.m
//  手势解锁Demo
//
//  Created by lance017 on 16/5/26.
//  Copyright © 2016年 lance017. All rights reserved.
//

#import "ViewController.h"
#import "Theme.h"
#import "SetPassWordController.h"
#import "UsePassWordViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArray = @[@"设置密码",@"使用密码",@"清除密码"];
    
    for (NSInteger index = 0; index < 3; index ++ ) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2-50, 100 + index * 60, 100, 40)];
        button.tag = 100 + index;
        [button setTitle:titleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}


/**
 *  按钮的点击事件
 *
 *  @param button 传递的按钮
 */
- (void)click:(UIButton *)button {
    if (button.tag == 100) {
        SetPassWordController *setP = [[SetPassWordController alloc]init];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"PassWord"] == nil) {
            setP.isFlag = NO;
        }else{
            setP.isFlag = YES;
        }
        [self.navigationController pushViewController:setP animated:YES];
        
    }else if (button.tag == 101) {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"PassWord"] == nil) {
            //没有设置密码
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先设置密码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            //使用密码
            UsePassWordViewController *useP = [[UsePassWordViewController alloc]init];
            [self.navigationController pushViewController:useP animated:YES];
        }
    }else{
        //清除手势密码
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"PassWord"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码清除成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
