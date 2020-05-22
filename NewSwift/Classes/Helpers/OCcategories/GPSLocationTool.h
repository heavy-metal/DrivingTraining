//
//  GPSLocationTool.h
//  清远驾培
//
//  Created by gail on 2017/8/24.
//  Copyright © 2017年 XNX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface GPSLocationTool : NSObject

/**
 *  public:原生地图获取坐标转化为真实坐标
 *
 *  @param latLng 原生坐标点
 *
 *  @return 真实坐标点
 */
+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D)latLng;


/**
 *  @brief  中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;
@end
