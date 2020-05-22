//
//  HomeNetTool.swift
//  NewSwift
//
//  Created by gail on 2017/12/15.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import Alamofire
import SwiftyJSON
public typealias Success = (_ response:[String : Any])->()
public typealias Failure = (_ error : Error)->()

class HomeNetTool: NSObject {
    
    static let provider = MoyaProvider<APIManager>()
    
    typealias result = (_ model:HomeInfoModel)->()
    typealias schooRresult = (_ page:Page ,_ array:[SchoolModel])->()
    
    class func getHomeData(Success : @escaping result, Failure:@escaping Failure) {
        
        _ = provider.rx.request(.getHomeData)
            .mapJSON()
            .asObservable()
            .mapObject(type: HomeAllInfoModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {Success((model.data)!)}
            }, onError: { (error) in
                Failure(error)
            })
    }

    class func getSchoollistData(currentPage:NSInteger ,cityNumber:Int? ,searchText:String ,Success : @escaping schooRresult , Failure:@escaping Failure){
        
        _ = provider.rx.request(.getSchoollistData(currentPage: currentPage, cityNumber: cityNumber, searchText: searchText))
            .mapJSON()
            .asObservable()
            .mapObject(type: SchoolListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {Success(model.Page!,model.Data!)}
            }, onError: { (error) in
                 Failure(error)
            })
    }
    
    class func getCoachListData(currentPage:NSInteger ,cityNumber:Int? ,searchText:String ,Success:@escaping (Page,[CoachModel])->() ,Failure:@escaping Failure) {
        
        _ = provider.rx.request(.getCoachListData(currentPage: currentPage, cityNumber: cityNumber ,searchText: searchText))
            .mapJSON()
            .asObservable()
            .mapObject(type: CoachListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.coachlistArray!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func getRegSiteData(currentPage:NSInteger ,cityNumber:Int? ,searchText:String ,Success:@escaping (Page,[RegistModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.getRegSiteData(currentPage: currentPage, cityNumber: cityNumber ,searchText: searchText))
            .mapJSON()
            .asObservable()
            .mapObject(type: RegistListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.registlistArray!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    
    class func getDistrict(Success:@escaping ([String],[Int])->()) {

        Alamofire.request(IPADRESS + PORT + "GetDistrict", method: .get, parameters: nil).validate().responseJSON { response in
            var indexArr = [NSInteger]()
            var nameArr = [String]()
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value)
                    let arr = json["Data"].arrayValue
                    for dict in arr {
                        indexArr.append(dict["District"].intValue)
                        nameArr.append(dict["Name"].stringValue)
                    }
                    Success(nameArr, indexArr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    class func GetClassList(currentPage:NSInteger ,insId:String ,Success:@escaping (Page,[ClassModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.GetClassList(currentPage: currentPage, InsId:insId))
            .mapJSON()
            .asObservable()
            .mapObject(type: ClassInfoModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.classArray!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func submitStudentApply(sexIndex:NSInteger ,insId:String ,name:String ,moblie:String ,applyCount:NSInteger ,remarks:String ,coachId:String ,registId:String ,classId:String ,Success:@escaping ()->()) {
       _ = provider.rx.request(.submitStudentApply(sexIndex: sexIndex, InsId: insId, name: name, moblie: moblie, applyCount: applyCount, remarks: remarks, coachId: coachId, registId: registId, classId: classId))
            .subscribe(onSuccess: { (response) in
                let json = JSON(response.data)
                if json["Code"].stringValue == "1" {
                    SVProgressHUD.showSuccess(withStatus: "报名成功")
                    SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                        Success()
                    })
                }else{
                    SVProgressHUD.showError(withStatus: json["Message"].stringValue)
                    SVProgressHUD.dismiss(withDelay: 1.5, completion: nil)
                }
            }) { (error) in

        }
    }
        
        
    class func getPubliclistData(currentPage:NSInteger ,getListIndex:Int ,Success : @escaping (Page,[PublicModel])->(), Failure:@escaping Failure){
        
        _ = provider.rx.request(.getPublicData(currentPage: currentPage, listTypeIndex: getListIndex))
            .mapJSON()
            .asObservable()
            .mapObject(type: PublicListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {Success(model.page!,model.publicArray!)}
            }, onError: { (error) in
                Failure(error)
            })
      
    }
    
    class func getInsListData(Success:@escaping ([SchoolModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.getInsList)
            .mapJSON()
            .asObservable()
            .mapObject(type: SchoolListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {Success(model.Data!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    //登录模块
    class func getLoginInfo(loginType:String ,UserName:String ,Password:String ,insId:String ,Success:@escaping (LoginModel)->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.getlLoginInfo(loginType: loginType, UserName: UserName, Password: Password, insId: insId))
            .mapJSON()
            .asObservable()
            .mapObject(type: LoginInfoModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {
                    Success(model.loginModel!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                Failure(error)
            })
    }
    class func getStudentBasicMessage(UserId:String ,StuId:String ,Success:@escaping (StuMessageModel)->()) {
        _ = provider.rx.request(.getStudentBasic(UserId: UserId, StuId: StuId))
            .mapJSON()
            .asObservable()
            .mapObject(type: StuBasicModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {
                    SVProgressHUD.dismiss()
                    Success(model.stuModel!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            })
    }
    
    class func getCoachBasicMessage(UserId:String ,coachId:String ,Success:@escaping (CoachMessageModel)->()) {
        _ = provider.rx.request(.getCoachBasic(UserId: UserId, CoachId: coachId))
            .mapJSON()
            .asObservable()
            .mapObject(type: CoachBasicModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {
                    SVProgressHUD.dismiss()
                    Success(model.coachModel!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            })
    }
    class func getSchoolBasicMessage(UserId:String ,insId:String ,Success:@escaping (SchoolModel)->()) {
        _ = provider.rx.request(.getSchoolBasic(UserId: UserId, InsId: insId))
            .mapJSON()
            .asObservable()
            .mapObject(type: SchoolBaseModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {
                    SVProgressHUD.dismiss()
                    Success(model.schoolModel!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            })
    }
    class func getStudentStudyTimeData(currentPage:NSInteger ,subject:NSInteger ,UserId:String ,stuId:String ,Success:@escaping (Page,[StudyTimeModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.getFindStudyTimeDate(currentPage: currentPage, subjectIndex: subject, UserId: UserId, StuId: stuId))
            .mapJSON()
            .asObservable()
            .mapObject(type: FindStudyTimeModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func GetStudyStateData(UserId:String ,stuId:String, Success:@escaping (StudyStateModel)->()){
        _ = provider.rx.request(.GetStudyStateData(UserId: UserId, StuId: stuId))
            .mapJSON()
            .asObservable()
            .mapObject(type: JsStudyStateModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1" {
                    SVProgressHUD.dismiss()
                    Success(model.studyStateModel!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            })
    }
    class func getReserveCoachList(currentPage:NSInteger  ,UserId:String ,stuId:String ,Success:@escaping (Page,[ReserveModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.GetreserveCoachList(UserId: UserId, StuId: stuId, CurrentPage: currentPage))
            .mapJSON()
            .asObservable()
            .mapObject(type: ReserveCoachListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func GetTimeData(coachId:String  ,UserId:String ,stuId:String ,Success:@escaping ([Timemodel])->()){
        _ = provider.rx.request(.FindTimeData(UserId: UserId, StuId: stuId, coachId: coachId))
            .mapJSON()
            .asObservable()
            .mapObject(type: ReserveCarTimeModel.self)
            .subscribe(onNext: { (model) in
                
                if model.code == "1"{
                    Success(model.array!)
                
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                SVProgressHUD.dismiss()
            })
    }
    
    class func GetSearchCarOrderData(currentPage:NSInteger  ,UserId:String ,stuId:String ,Success:@escaping (Page,[SearchCarOrderModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.searchCarOrderData(currentPage: currentPage, UserId: UserId, StuId: stuId))
            .mapJSON()
            .asObservable()
            .mapObject(type: SearchCarOrderListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                Failure(error)
                
            })
    }
    
    class func GetOrderEvaluation(UserId:String ,orderNo:String ,Success:@escaping (RatingStarModel)->()) {
        _ = provider.rx.request(.getOrderEvaluation(UserId: UserId, OrderNo: orderNo))
            .mapJSON()
            .asObservable()
            .mapObject(type: RatingModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.ratingStarModel!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1)
            })
    }
    class func OrderEvaluation(UserId:String ,orderNo:String ,Quality:NSInteger ,Attitude:NSInteger ,Standard:NSInteger ,Honest:NSInteger ,Content:String ,Success:@escaping ()->()){
        let content = Content=="" ? "" : Content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        _ = provider.rx.request(.OrderEvaluation(UserId: UserId, OrderNo: orderNo, Quality: Quality, Attitude: Attitude, Standard: Standard, Honest: Honest, Content: content!))
            .asObservable()
            .subscribe(onNext: { (result) in
                let json = JSON(result.data)
                if json["Code"] == "1" {
                    Success()
                }else {
                    SVProgressHUD.showError(withStatus: json["Message"].stringValue)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1)
            })
    }
    class func cancelOrder(UserId:String ,orderNo:String ,Success:@escaping ()->()) {
        _ = provider.rx.request(.CancelOrder(UserId: UserId, OrderNo: orderNo)).asObservable().mapJSON().subscribe(onNext: { (result) in
            let json = JSON(result)
            if (json["Code"]).stringValue == "1" {
//                SVProgressHUD.showSuccess(withStatus: "取消订单成功")
                Success()
            }else {
                SVProgressHUD.showError(withStatus: json["Message"].stringValue)
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: "请检查网络")
            SVProgressHUD.dismiss(withDelay: 1)
        })
    }
    
    class func getBookCarOrderData(coachId:String ,UserId:String ,date:String ,Success:@escaping ([CarChooseOrderModel])->() ,Failure:@escaping Failure){
        
        _ = provider.rx.request(.getBookCarOrder(UserId: UserId, CoachId: coachId, Date: date))
            .mapJSON()
            .asObservable()
            .mapObject(type: BookCarOrderModel.self)
            .subscribe(onNext: { (model) in
                
                if model.code == "1"{
                    Success(model.array!)
                    
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                SVProgressHUD.dismiss()
            })
    }
    
    class func getWeekCountData (stuId:String ,UserId:String ,Success:@escaping (NSInteger)->()) {
        Alamofire.request(IPADRESS + PORT + "GetStudentThisWeekYyCount", method: .get, parameters: ["UserId":UserId,"StuId":stuId]).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        let index = json?["Data"]?.intValue
                        Success(index ?? 0)
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    class func getWeekAllCountData (groupId:String ,UserId:String ,Success:@escaping (NSInteger)->()) {
        Alamofire.request(IPADRESS + PORT + "GetStudyGroupInfoByGroupId", method: .get, parameters: ["UserId":UserId,"GroupId":groupId]).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        let index = json?["Data"]?["WeekTimes"].intValue
                        Success(index ?? 0)
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func getOrderAdd(UserId:String ,StuId:String ,CoachId:String ,SeduIds:String ,Success:@escaping ()->()){
        _ = provider.rx.request(.getOrderAddData(UserId: UserId, StuId: StuId, CoachId: CoachId, SeduIds: SeduIds)).asObservable().mapJSON().subscribe(onNext: { (result) in
            let json = JSON(result)
            if (json["Code"]).stringValue == "1" {
                Success()
            }else {
                SVProgressHUD.showError(withStatus: json["Message"].stringValue)
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: "请检查网络")
            SVProgressHUD.dismiss(withDelay: 1)
        })
    }
    
    class func changePassword(url:String ,UserId:String ,InsId:String ,OldPassword:String ,NewPassword:String ,Success:@escaping ()->()){
        let urlString = IPADRESS + PORT + url + "ChangePwd"
        var params = ["UserId":UserId,"OldPassword":OldPassword,"NewPassword":NewPassword]
        if InsId != "" { params["InsId"] = InsId }
        Alamofire.request(urlString, method: .get, parameters: params).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        Success()
                        
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func addSuggest(UserId:String ,Title:String ,Type:Int ,Content:String ,Success:@escaping ()->()){
        Alamofire.request(IPADRESS + PORT + "FeedbackAdd", method: .get, parameters: ["UserId":UserId,"Title":Title,"Type":Type,"Content":Content]).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        Success()
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func getSuggestListData(UserId:String ,currentPage:NSInteger ,Success:@escaping (Page,[SuggestModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.getSuggestListData(currentPage: currentPage, UserId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: SuggestListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func upLoadQRcode(loginType:String ,TerminalNo:String ,UserId:String ,TimeStamp:String ,Success:@escaping ()->()){
        
        let url = IPADRESS + PORT + "\(loginType)QrCodeCheck"
        Alamofire.request(url, method: .get, parameters: ["UserId":UserId,"TerminalNo":TerminalNo,"TimeStamp":TimeStamp]).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        Success()
                    }else {
                        SVProgressHUD.showError(withStatus: "该二维码数据错误")
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func checkStudentList(currentPage:NSInteger ,index:NSInteger? ,searchText:String ,UserId:String ,Success:@escaping (Page,[CheckStudentModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.checkStudentList(currentPage: currentPage, index: index, searchText: searchText, UserId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: CheckStudentListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    class func GetStudentAtId (UserId:String ,Success:@escaping (String)->()) {
        Alamofire.request(IPADRESS + PORT + "GetStudentAtId", method: .get, parameters: ["UserId":UserId]).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        Success(json?["Data"]?.stringValue ?? "")
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func StudentAtAdd(UserId:String ,stuID:String ,Success:@escaping ()->()) {
        Alamofire.request(IPADRESS + PORT + "StudentAtAdd", method: .get, parameters: ["UserId":UserId,"StuId":stuID]).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        Success()
                        SVProgressHUD.showSuccess(withStatus: "关注成功")
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func coachDayStudySum(userId:String ,coachId:String ,StudyDate:String ,Success:@escaping (TeachingStatisticsModel)->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.coachDayStudySum(userId: userId, coachId: coachId, studyDate: StudyDate))
            .mapJSON()
            .asObservable()
            .mapObject(type: TeachingStatisticsModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func checkAttensionList(currentPage:NSInteger ,index:NSInteger? ,searchText:String ,UserId:String ,Success:@escaping (Page,[CheckStudentModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.checkAttensionList(currentPage: currentPage, index: index, searchText: searchText, UserId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: CheckStudentListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func studentAtDel(UserId:String ,stuID:String ,Success:@escaping ()->()){
        Alamofire.request(IPADRESS + PORT + "StudentAtDel", method: .get, parameters: ["UserId":UserId,"StuId":stuID]).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value).dictionary
                    if json?["Code"]?.stringValue == "1" {
                        Success()
                        SVProgressHUD.showSuccess(withStatus: "取消成功")
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }else {
                        SVProgressHUD.showError(withStatus: json?["Message"]?.stringValue)
                        SVProgressHUD.dismiss(withDelay: 1.5)
                    }
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "请检查网络")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
    
    class func SearchOrder(UserId:String ,currentPage:NSInteger ,Date:String ,Success:@escaping (Page,[SearchCarOrderModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.coachSearchOrder(userId: UserId, currentPage: currentPage, Date: Date))
            .mapJSON()
            .asObservable()
            .mapObject(type: SearchCarOrderListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                Failure(error)
                
            })
    }
    
    class func getCoachScheduleMonthGroup(UserId:String ,CoachId:String ,Year:Int ,Month:Int,Success:@escaping ([SchedulingModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.getCoachScheduleMonthGroup(userId: UserId, coachId: CoachId, Year: Year, Month: Month))
            .mapJSON()
            .asObservable()
            .mapObject(type: CoachSchedulingModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                Failure(error)
                
            })
    }
    
    class func getCoachScheduleByDay(UserId:String ,CoachId:String ,dateString:String ,currentPage:NSInteger ,Success:@escaping (Page,[ScheduleByDayModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.getCoachScheduleByDay(userId: UserId, coachId: CoachId, currentPage: currentPage, dateString: dateString))
            .mapJSON()
            .asObservable()
            .mapObject(type: CoachScheduleByDayModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                Failure(error)
                
            })
    }
    
    class func getSeduConfigs(UserId:String ,Success:@escaping ([SeduConfigModel])->()){
        _ = provider.rx.request(.getSeduConfigs(userId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: SeduConfigsModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                
            })
    }
    
    class func getRegionByUserId(UserId:String ,Success:@escaping ([RegionIdModel])->()) {
        _ = provider.rx.request(.getRegionByUserId(userId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: RegionByUserIdModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                
            })
    }
    
    class func GetSeduTimes(UserId:String ,ConfigId:String ,Success:@escaping ([SeduTimeModel])->()){
        _ = provider.rx.request(.getSeduTimes(userId: UserId, ConfigId: ConfigId))
            .mapJSON()
            .asObservable()
            .mapObject(type: SeduTimesModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.array!)
                }else {
                    SVProgressHUD.showError(withStatus: model.message)
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }, onError: { (error) in
                
            })
    }
    
    class func scheduleBuildCoachDay(UserId:String,ConfigId:String,CoachId:String,SchDate:String,Subject:String,RegionId:String,Success:@escaping ()->()) {
      
        _ = provider.rx.request(.scheduleBuildCoachDay(UserId: UserId, ConfigId: ConfigId, CoachId: CoachId, SchDate: SchDate, Subject: Subject, RegionId: RegionId))
            .subscribe(onSuccess: { (response) in
                let json = JSON(response.data)
                if json["Code"].stringValue == "1" {
                    SVProgressHUD.showSuccess(withStatus: "已生成排班！")
                    SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                        Success()
                    })
                }else{
                    SVProgressHUD.showError(withStatus: json["Message"].stringValue)
                    SVProgressHUD.dismiss(withDelay: 1.5, completion: nil)
                }
            }) { (error) in
                
        }
    }
    
    class func checkCoachList(currentPage:NSInteger ,index:NSInteger? ,searchText:String ,UserId:String ,Success:@escaping (Page,[CoachModel])->() ,Failure:@escaping Failure){
        _ = provider.rx.request(.checkCoachList(currentPage: currentPage, index: index, searchText: searchText, UserId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: CoachListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.coachlistArray!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
    
    class func searchCarList(currentPage:NSInteger ,searchText:String ,UserId:String ,Success:@escaping (Page,[CheckCarModel])->() ,Failure:@escaping Failure) {
        _ = provider.rx.request(.searchCarList(currentPage: currentPage, searchText: searchText, UserId: UserId))
            .mapJSON()
            .asObservable()
            .mapObject(type: CheckCarListModel.self)
            .subscribe(onNext: { (model) in
                if model.code == "1"{Success(model.page!,model.array!)}
            }, onError: { (error) in
                Failure(error)
            })
    }
}
