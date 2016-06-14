//
//  SignInViewModel.h
//  Xpai
//
//  Created by zhaoqin on 6/13/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class RACCommand;

@interface SignInViewModel : NSObject

@property (nonatomic, strong) NSString *serviceString;
@property (nonatomic, strong) NSString *accountString;
@property (nonatomic, strong) NSString *passwordString;
@property (nonatomic, strong) RACSignal *signInIsValid;
@property (nonatomic, strong) RACCommand *signInCommand;

@end
