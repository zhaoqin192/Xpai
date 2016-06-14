//
//  SignInViewController.m
//  Xpai
//
//  Created by zhaoqin on 6/13/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SignInViewController.h"
#import "ReactiveCocoa.h"
#import "SignInViewModel.h"
#import "XpaiInterface.h"
#import "VRCViewController.h"
#import "MBProgressHUD.H"


@interface SignInViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *serviceCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (nonatomic, strong) SignInViewModel *viewModel;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureUI];
    [self bindViewModel];

    [XpaiInterface setDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

- (void)bindViewModel {
 
    self.viewModel = [[SignInViewModel alloc] init];
    
    RAC(self.viewModel, serviceString) = self.serviceCodeTextField.rac_textSignal;
    RAC(self.viewModel, accountString) = self.accountTextField.rac_textSignal;
    RAC(self.viewModel, passwordString) = self.passwordTextField.rac_textSignal;
    RAC(self.signInButton, enabled) = self.viewModel.signInIsValid;
    
    @weakify(self)
    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.signInCommand execute:nil];
    }];
    
}

- (void)configureUI {
    self.serviceCodeTextField.delegate = self;
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.serviceCodeTextField.text = @"BDGFIGSL";
    self.accountTextField.text = @"001";
    self.passwordTextField.text = @"001";
}


#pragma mark --XpainterFaceDelegate回调
//连接成功
-(void)didConnectToServer {
    VRCViewController * VRC = [[VRCViewController alloc]init];
    VRC.isLogin = YES;
    VRC.UserName = self.viewModel.accountString;
    VRC.PassWord = self.viewModel.passwordString;
    VRC.serviceCode = self.viewModel.serviceString;
    VRC.isAcross = YES;//设置横屏
    VRC.kindOfLogin = 1;
    VRC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:VRC animated:YES completion:nil];
    NSLog(@"登录成功");
}

-(void)didDisconnect {
    NSLog(@"断开成功");
}

//连接失败
-(void)failConnectToServer:(int)failCode {
    
    if (failCode == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"查询VS地址出错";
        [hud hide:YES afterDelay:1.5f];
    }
    else if (failCode == 2) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无法连接到服务器";
        [hud hide:YES afterDelay:1.5f];
    }
    else if (failCode == 3) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名或密码错误";
        [hud hide:YES afterDelay:1.5f];
    }
    else if (failCode == 4) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"获取服务器地址出错";
        [hud hide:YES afterDelay:1.5f];
    }

}

//点击View，键盘消失，view必须是继承自UIControllerView的
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
