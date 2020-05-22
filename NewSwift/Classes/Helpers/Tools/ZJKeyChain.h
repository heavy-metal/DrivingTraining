//
//  ZJKeyChain.h
//  KeyChainDemo
//
//  Created by gail on 2018/1/30.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface ZJKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

// save username and password to keychain
+ (void)save:(NSString *)service data:(id)data;

// load username and password from keychain
+ (id)load:(NSString *)service;

// delete username and password from keychain
+ (void)delete:(NSString *)serviece;


@end
