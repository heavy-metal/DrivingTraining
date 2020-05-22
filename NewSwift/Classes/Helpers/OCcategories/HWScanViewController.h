//
//  HWScanViewController.h
//  HWScanTest
//
//  Created by sxmaps_w on 2017/2/18.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnScanStringDelegate <NSObject>

- (void)ReturnScanCode:(NSString *)code;

@end


@interface HWScanViewController : UIViewController

@property (nonatomic, weak) id <ReturnScanStringDelegate> delegate;

@end
