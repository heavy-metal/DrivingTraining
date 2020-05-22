//
//  BSLCalendar.h
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeeksView.h"
#import "BSLMonthCollectionView.h"
@interface BSLCalendar : UICollectionViewCell

/**
 * showChineseCalendar：显示农历， 默认为YES
 */
@property (nonatomic ,assign)BOOL showChineseCalendar;

/**
 * 日期选择回调
 * year：年
 * month：月
 * day：日
 */
- (void)selectDateOfMonth:(void(^)(NSInteger year,NSInteger month,NSInteger day))selectBlock;



@property (nonatomic, strong)WeeksView *weeks;
@property (nonatomic, strong)BSLMonthCollectionView *dayView;

@end
