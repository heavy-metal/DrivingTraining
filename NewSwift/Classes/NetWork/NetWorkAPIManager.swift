//
//  NetWorkAPIManager.swift
//  NewSwift
//
//  Created by gail on 2019/4/23.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import Moya
enum APIManager {
    case getHomeData
    case getSchoollistData(currentPage:NSInteger ,cityNumber:Int?, searchText:String)
    case getCoachListData(currentPage:NSInteger ,cityNumber:Int?, searchText:String)
    case getRegSiteData(currentPage:NSInteger ,cityNumber:Int?, searchText:String)
    case getDistrict
    case GetClassList(currentPage:NSInteger ,InsId:String)
    case submitStudentApply(sexIndex:NSInteger ,InsId:String ,name:String ,moblie:String ,applyCount:NSInteger ,remarks:String ,coachId:String ,registId:String ,classId:String)
    case getPublicData(currentPage:NSInteger ,listTypeIndex:NSInteger)
    case getInsList
    case getlLoginInfo(loginType:String ,UserName:String ,Password:String ,insId:String)
    case getStudentBasic(UserId:String ,StuId:String)
    case getCoachBasic(UserId:String ,CoachId:String)
    case getSchoolBasic(UserId:String ,InsId:String)
    case getFindStudyTimeDate(currentPage:NSInteger ,subjectIndex:NSInteger ,UserId:String ,StuId:String)
    case GetStudyStateData(UserId:String ,StuId:String)
    case GetreserveCoachList(UserId:String ,StuId:String ,CurrentPage:NSInteger)
    case FindTimeData(UserId:String ,StuId:String ,coachId:String)
    case searchCarOrderData(currentPage:NSInteger ,UserId:String ,StuId:String)
    case getOrderEvaluation(UserId:String ,OrderNo:String)
    case OrderEvaluation(UserId:String ,OrderNo:String,Quality:NSInteger ,Attitude:NSInteger,Standard:NSInteger ,Honest:NSInteger,Content:String)
    case CancelOrder(UserId:String ,OrderNo:String)
    case getBookCarOrder(UserId:String ,CoachId:String ,Date:String)
    case getOrderAddData(UserId:String ,StuId:String ,CoachId:String ,SeduIds:String)
    case getSuggestListData(currentPage:NSInteger ,UserId:String)
    case checkStudentList(currentPage:NSInteger ,index:NSInteger? ,searchText:String ,UserId:String)
    case coachDayStudySum(userId:String ,coachId:String ,studyDate:String)
    case checkAttensionList(currentPage:NSInteger ,index:NSInteger? ,searchText:String ,UserId:String)
    case coachSearchOrder(userId:String ,currentPage:NSInteger ,Date:String)
    case getCoachScheduleMonthGroup(userId:String ,coachId:String ,Year:Int ,Month:Int)
    case getCoachScheduleByDay(userId:String ,coachId:String ,currentPage:NSInteger ,dateString:String)
    case getSeduConfigs(userId:String)
    case getRegionByUserId(userId:String)
    case getSeduTimes(userId:String,ConfigId:String)
    case scheduleBuildCoachDay(UserId:String,ConfigId:String,CoachId:String,SchDate:String,Subject:String,RegionId:String)
    case checkCoachList(currentPage:NSInteger ,index:NSInteger? ,searchText:String ,UserId:String)
    case searchCarList(currentPage:NSInteger ,searchText:String ,UserId:String)
}

class NetWorkAPIManager: NSObject {
    
}

extension APIManager: TargetType {
    var baseURL: URL {
        switch self {
        case .getHomeData: return URL(string: IPADRESS + PORT + "GetAppHome")!//homeDataUrl
        case .getSchoollistData(_): return URL(string: IPADRESS + PORT + "GetInsList" + "&PageSize=10")!//schoolListUrl
        case .getCoachListData(_): return URL(string: IPADRESS + PORT + "GetCoachList" + "&PageSize=10")!//coachListUrl
        case .getRegSiteData(_): return URL(string: IPADRESS + PORT + "GetRegSiteList" + "&PageSize=10")!//RegSiteUrl
        case .getDistrict: return URL(string: IPADRESS + PORT + "GetDistrict")!
        case .GetClassList: return URL(string: IPADRESS + PORT + "GetClassList" + "&PageSize=10")!
        case .submitStudentApply(_): return URL(string: IPADRESS + PORT + "StudentApply&FromType=3")!
        case .getPublicData(_): return URL(string: IPADRESS + PORT + "GetInfoList" + "&PageSize=10")!
        case .getInsList: return URL(string: IPADRESS + PORT + "GetInsList" + "&PageSize=999" + "&CurrentPage=1")!
        case .getlLoginInfo(let loginType, _, _, _): return URL(string: IPADRESS + PORT + "\(loginType)&LoginType=3")!
        case .getStudentBasic(_): return URL(string: IPADRESS + PORT + "GetStudentInfo")!
        case .getCoachBasic(_): return URL(string: IPADRESS + PORT + "GetCoachInfo")!
        case .getSchoolBasic(_): return URL(string: IPADRESS + PORT + "GetInsInfo")!
        case .getFindStudyTimeDate(_): return URL(string: IPADRESS + PORT + "GetStudyList" + "&PageSize=10")!
        case .GetStudyStateData(_): return URL(string: IPADRESS + PORT + "GetStudyState")!
        case .GetreserveCoachList(_): return URL(string: IPADRESS + PORT + "SearchStuAppCoach" + "&PageSize=10")!
        case .FindTimeData(_): return URL(string: IPADRESS + PORT + "GetCoachScheduleXDayGroup")!
        case .searchCarOrderData(_): return URL(string: IPADRESS + PORT + "SearchOrder" + "&PageSize=10")!
        case .getOrderEvaluation(_): return URL(string: IPADRESS + PORT + "GetOrderEvaluationByOrderNo")!
        case .OrderEvaluation(_): return URL(string: IPADRESS + PORT + "OrderEvaluation")!
        case .CancelOrder(_): return URL(string: IPADRESS + PORT + "OrderCancel")!
        case .getBookCarOrder(_): return URL(string: IPADRESS + PORT + "GetCoachScheduleKyByDay")!
            
        case .getOrderAddData(_): return URL(string: IPADRESS + PORT + "OrderAdd")!
            
        case .getSuggestListData: return URL(string: IPADRESS + PORT + "GetFeedbackList" + "&PageSize=10")!
            
        case .checkStudentList(_): return URL(string: IPADRESS + PORT + "SearchStudent" + "&PageSize=10")!
        
        case .coachDayStudySum(_): return URL(string: IPADRESS + PORT + "CoachDayStudySum")!
        case .checkAttensionList(_) : return URL(string: IPADRESS + PORT + "GetStudentAt" + "&PageSize=10")!
        case .coachSearchOrder(_) : return URL(string: IPADRESS + PORT + "SearchOrder" + "&PageSize=10")!
            case .getCoachScheduleMonthGroup(_) : return URL(string: IPADRESS + PORT + "GetCoachScheduleMonthGroup")!
        case .getCoachScheduleByDay(_): return URL(string: IPADRESS + PORT + "GetCoachScheduleByDay" + "&PageSize=10")!
        case .getSeduConfigs(_): return URL(string: IPADRESS + PORT + "GetSeduConfigs")!
        case .getRegionByUserId(_): return URL(string: IPADRESS + PORT + "GetRegionByUserId")!
            
        case .getSeduTimes(_): return URL(string: IPADRESS + PORT + "GetSeduTimes")!
            
        case .scheduleBuildCoachDay(_): return URL(string: IPADRESS + PORT + "ScheduleBuildCoachDay")!
        case .checkCoachList(_): return URL(string: IPADRESS + PORT + "SearchCoach" + "&PageSize=10")!
            
        case .searchCarList(_): return URL(string: IPADRESS + PORT + "SearchCar" + "&PageSize=10")!
            
        }
    }
   
    var task: Task {
        var params:[String:Any]?
        switch self {
        case .getHomeData: params = nil
            
        case .getSchoollistData(let currentPage,let cityNumber,let searchText):
            params = ["CurrentPage":"\(currentPage)","Name":"\(searchText)"]
            if cityNumber != nil {params?["District"] = cityNumber}
            
        case .getCoachListData(let currentPage,let cityNumber,let searchText):
            params = ["CurrentPage":"\(currentPage)","Name":"\(searchText)"]
            if cityNumber != nil {params?["District"] = cityNumber}
            
        case .getRegSiteData(let currentPage,let cityNumber,let searchText):
            params = ["CurrentPage":"\(currentPage)","Name":"\(searchText)"]
            if cityNumber != nil {params?["District"] = cityNumber}
            
        case .getDistrict: params = nil
            
        case .GetClassList(let currentPage ,let InsId):
            params = ["CurrentPage":"\(currentPage)" ,"InsId":"\(InsId)"]
        
        case .submitStudentApply(let sexIndex,let InsId,let name,let moblie, let applyCount,let remarks,let coachId,let registId,let classId):
            params = ["Sex":sexIndex ,"InsId":InsId ,"StuName":name ,"Mobile":moblie ,"ApplyCount":applyCount ,"Remark":remarks]
            if coachId != "" {params?["CoachId"] = coachId}
            if registId != "" {params?["RegSiteId"] = registId}
            if classId != "" {params?["ClassId"] = classId}
            
        case .getPublicData(let currentPage ,let listTypeIndex): params = ["CurrentPage":currentPage ,"InfoType":listTypeIndex]
            
        case .getInsList: params = nil
            
        case .getlLoginInfo(_, let UserName, let Password, let insId):
            params = ["UserName":"\(UserName)","Password":"\(Password)"]
            if insId != "" {params?["InsId"] = insId}
            
        case .getStudentBasic(let userId ,let stuId): params = ["UserId":"\(userId)" ,"StuId":"\(stuId)"]
        case .getCoachBasic(let UserId, let CoachId): params = ["UserId":"\(UserId)" ,"CoachId":"\(CoachId)"]
        case .getSchoolBasic(let UserId, let InsId): params = ["UserId":"\(UserId)" ,"InsId":"\(InsId)"]
        case .getFindStudyTimeDate(let currentPage, let subjectIndex, let UserId, let StuId): params = ["UserId":"\(UserId)" ,"StuId":"\(StuId)","CurrentPage":"\(currentPage)" ,"Subject":"\(subjectIndex)"]
        case .GetStudyStateData(let userId ,let stuId): params = ["UserId":"\(userId)" ,"StuId":"\(stuId)"]
        case .GetreserveCoachList(let UserId, let StuId, let CurrentPage): params = ["UserId":"\(UserId)" ,"StuId":"\(StuId)","CurrentPage":"\(CurrentPage)"]
            
        case .FindTimeData(let UserId, let StuId, let coachId):
            params = ["UserId":UserId ,"StuId":StuId ,"CoachId":coachId]
            
        case .searchCarOrderData(let currentPage, let UserId, let StuId): params = ["CurrentPage":currentPage ,"UserId":"\(UserId)" ,"StuId":"\(StuId)"]
            
        case .getOrderEvaluation(let UserId, let OrderNo): params = ["UserId":"\(UserId)" ,"OrderNo":"\(OrderNo)"]
        case .OrderEvaluation(let UserId, let OrderNo,let Quality, let Attitude,let Standard, let Honest,let Content) : params = ["UserId":"\(UserId)" ,"OrderNo":"\(OrderNo)","Quality":Quality ,"Attitude":Attitude,"Standard":Standard ,"Honest":Honest,"Content":"\(Content)"]
        
         
        case .CancelOrder(let UserId, let OrderNo):  params = ["UserId":"\(UserId)" ,"OrderNo":"\(OrderNo)"]
            
        case .getBookCarOrder(let UserId, let CoachId, let Date): params = ["UserId":UserId ,"CoachId":CoachId ,"SchDate":Date]
            
        case .getOrderAddData(let UserId, let StuId, let CoachId, let SeduIds):  params = ["UserId":UserId ,"StuId":StuId ,"CoachId":CoachId ,"SeduIds":SeduIds]
            
        case .getSuggestListData(let currentPage, let UserId):  params = ["CurrentPage":currentPage ,"UserId":UserId]
            
        case .checkStudentList(let currentPage, let index, let searchText, let UserId):
            params = ["CurrentPage":currentPage,"UserId":UserId]
            if searchText != ""{
                if index == 0 {
                    params?["StuName"] = searchText
                }else if index == 1 {
                    params?["Mobile"] = searchText
                }else if index == 2 {
                    params?["IdCard"] = searchText
                }
            }
        case .coachDayStudySum(let userId ,let coachId , let studyDate): params = ["UserId":userId ,"CoachId":coachId ,"StudyDate":studyDate]
            
            
        case .checkAttensionList(let currentPage, let index, let searchText, let UserId):
            params = ["CurrentPage":currentPage,"UserId":UserId]
            if searchText != ""{
                if index == 0 {
                    params?["StuName"] = searchText
                }else if index == 1 {
                    params?["Mobile"] = searchText
                }else if index == 2 {
                    params?["IdCard"] = searchText
                }
            }
        case .coachSearchOrder(let userId, let currentPage, let Date): params = ["CurrentPage":currentPage,"UserId":userId ,"TrainDate":Date]
        case .getCoachScheduleMonthGroup(let userId, let coachId, let Year, let Month):
            params = ["UserId":userId ,"CoachId":coachId ,"Year":Year ,"Month":Month]
        case .getCoachScheduleByDay(let userId, let coachId, let currentPage, let dateString):
            params = ["UserId":userId ,"CoachId":coachId ,"CurrentPage":currentPage ,"SchDate":dateString]
        case .getSeduConfigs(let userId): params = ["UserId":userId]
        case .getRegionByUserId(let userId): params = ["UserId":userId]
            
        case .getSeduTimes(let userId ,let ConfigId): params = ["UserId":userId,"ConfigId":ConfigId]
            
        case .scheduleBuildCoachDay(let UserId, let ConfigId, let CoachId, let SchDate, let Subject, let RegionId):
            params = ["UserId":UserId ,"CoachId":CoachId ,"ConfigId":ConfigId ,"SchDate":SchDate,"Subject":Subject,"RegionId":RegionId]
            
        case .checkCoachList(let currentPage, let index, let searchText, let UserId):
            params = ["CurrentPage":currentPage,"UserId":UserId]
            if searchText != ""{
                if index == 0 {
                    params?["CoachName"] = searchText
                }else if index == 1 {
                    params?["Mobile"] = searchText
                }else if index == 2 {
                    params?["IdCard"] = searchText
                }
            }
        case .searchCarList(let currentPage, let searchText, let UserId):
             params = ["UserId":UserId ,"CurrentPage":currentPage ,"LicNum":searchText]
        }
        return .requestParameters(parameters: params ?? ["":""], encoding: URLEncoding.default)
    }
    
    var path: String {
        return ""
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
         return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
}
