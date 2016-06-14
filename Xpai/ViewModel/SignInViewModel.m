//
//  SignInViewModel.m
//  Xpai
//
//  Created by zhaoqin on 6/13/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SignInViewModel.h"
#import "ReactiveCocoa.h"
#import "CLSettingConfig.h"
#import "CLUploadConfig.h"
#import "XpaiInterface.h"

@implementation SignInViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.signInIsValid = [[RACSignal combineLatest:@[RACObserve(self, serviceString), RACObserve(self, accountString), RACObserve(self, passwordString)]
                              reduce:^(NSString *serviceString, NSString *accountString, NSString *passwordString){
                                  return @(serviceString.length > 0 && accountString.length > 0 && passwordString.length > 0);
                              }]
                              distinctUntilChanged];
        
        self.signInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [CLUploadConfig sharedInstance].UserName = _accountString;
            [CLUploadConfig sharedInstance].passWord = _passwordString;
            [CLUploadConfig sharedInstance].serviceCode = _serviceString;
            
            [[CLUploadConfig sharedInstance] WriteData];
            [[CLSettingConfig sharedInstance] WriteData];
            
            [XpaiInterface connectCloud:@"http://c.zhiboyun.com/api/20140928/get_vs" u:_accountString pd:_passwordString svcd:_serviceString];
            return [RACSignal empty];

        }];
        
    }
    return self;
}

@end
