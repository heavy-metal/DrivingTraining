//
//  Const.swift
//  NewSwift
//
//  Created by gail on 2017/12/11.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

let GlobalColor : UIColor = {
    return  UIColor(red: 64/255.0, green: 194/255.0, blue: 187/255.0, alpha: 1)
}()

let grayBackColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)

let headViewHeight:CGFloat = SCREEN_HEIGHT*3/10

let LINE_SPACE:CGFloat = SCREEN_WIDTH * 0.007 //首页collectview的间距

let COLLECTVIEW_HEIGHT = (SCREEN_WIDTH-LINE_SPACE*5)/4*2 + LINE_SPACE*3 //collectview高度

let statusBarHeight = UIApplication.shared.statusBarFrame.height

let NavBarHeight:CGFloat = statusBarHeight + 44

let tabBarHeight:CGFloat = NavBarHeight == 88 ? 49 + 34 : 49

let SCREEN_WIDTH = UIScreen.main.bounds.width

let SCREEN_HEIGHT = UIScreen.main.bounds.height

var IPADRESS = "http://125.89.196.8:2059"

//var IPADRESS = UserDefaults.standard.object(forKey: "SELECT_URL") as! String

var PORT = "/MobileHttp.aspx?Cmd="

var homeDataUrl = IPADRESS + PORT + "GetAppHome"

var schoolListUrl = IPADRESS + PORT + "GetInsList" + "&PageSize=10"

var coachListUrl = IPADRESS + PORT + "GetCoachList" + "&PageSize=10"

var RegSiteUrl = IPADRESS + PORT + "GetRegSiteList" + "&PageSize=10"

var DistrictUrl = IPADRESS + PORT + "GetDistrict"

var ClassListUrl = IPADRESS + PORT + "GetClassList" + "&PageSize=10"

var sumitStudentApplyUrl = IPADRESS + PORT + "StudentApply&FromType=3"//提交报名信息

var publicListUrl = IPADRESS + PORT + "GetInfoList" + "&PageSize=10"

var insListUrl = IPADRESS + PORT + "GetInsList" + "&PageSize=999" + "&CurrentPage=1"

var stuBaseUrl = IPADRESS + PORT + "GetStudentInfo"

var coachBaseUrl = IPADRESS + PORT + "GetCoachInfo"

var schoolBaseUrl = IPADRESS + PORT + "GetInsInfo"

var findStudyTimeUrl = IPADRESS + PORT + "GetStudyList" + "&PageSize=10"

var studyStateUrl = IPADRESS + PORT + "GetStudyState"

var reserveCoachUrl = IPADRESS + PORT + "SearchStuAppCoach" + "&PageSize=10"

var FindTimeUrl = IPADRESS + PORT + "GetCoachScheduleXDayGroup"

var searchCarOrderUrl = IPADRESS + PORT + "SearchOrder" + "&PageSize=10"

var getOrderEvaluationUrl = IPADRESS + PORT + "GetOrderEvaluationByOrderNo"

var OrderEvaluationUrl = IPADRESS + PORT + "OrderEvaluation"

var CancelOrderUrl = IPADRESS + PORT + "OrderCancel"

var aboutCarOrderUrl = IPADRESS + PORT + "GetCoachScheduleKyByDay"

var getWeekCountUrl = IPADRESS + PORT + "GetStudentThisWeekYyCount"

var getWeekAllCountUrl = IPADRESS + PORT + "GetStudyGroupInfoByGroupId"

var getOrderAddUrl = IPADRESS + PORT + "OrderAdd"

var feedbackAddUrl = IPADRESS + PORT + "FeedbackAdd"

var feedbackListUrl = IPADRESS + PORT + "GetFeedbackList" + "&PageSize=10"

var checkStudentListUrl = IPADRESS + PORT + "SearchStudent" + "&PageSize=10"

var coachDayStudySumUrl = IPADRESS + PORT + "CoachDayStudySum"

var didAttentionListUrl = IPADRESS + PORT + "GetStudentAt" + "&PageSize=10"

var coachSearchOrderUrl = IPADRESS + PORT + "SearchOrder" + "&PageSize=10"

var coachScheduleMonthGroup = IPADRESS + PORT + "GetCoachScheduleMonthGroup"

var coachScheduleByDayUrl = IPADRESS + PORT + "GetCoachScheduleByDay" + "&PageSize=10"

var seduConfigsUrl = IPADRESS + PORT + "GetSeduConfigs"

var regionByUserIdUrl = IPADRESS + PORT + "GetRegionByUserId"

var seduTimesUrl = IPADRESS + PORT + "GetSeduTimes"

var scheduleBuildCoachDayUrl = IPADRESS + PORT + "ScheduleBuildCoachDay"

var checkCoachListUrl = IPADRESS + PORT + "SearchCoach" + "&PageSize=10"

var searchCarUrl = IPADRESS + PORT + "SearchCar" + "&PageSize=10"

