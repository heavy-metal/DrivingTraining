//
//  SearchCarOrderListModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/8.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class SearchCarOrderListModel: Mappable {
    var code = ""
    var message = ""
    var array:[SearchCarOrderModel]?
    var page:Page?
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        array <- map["Data"]
        page <- map["Page"]
    }
}
class SearchCarOrderModel:Mappable {
    
    var orderState = ""
    var payState = ""
    var stuPjState = ""
    
    var orderId = ""
    var OrderNo = ""
    var InsId = ""
    var SchoolName = ""
    var CoachId = ""
    var CoachName = ""
    var CoachIdCard = ""
    var CoachMobile = ""
    var StuId = ""
    var StuName = ""
    var StuIdCard = ""
    var StuMobile = ""
    var Subject = "" {
        didSet{
           Subject = Subject=="" ? "暂无" : Subject
        }
    }
    var RegionId = ""
    var RegionName = "" {
        didSet{
            let str1 = CharacterSet(charactersIn: "训练场")
            RegionName = RegionName.trimmingCharacters(in: str1)
            RegionName = RegionName=="" ? "暂无" : RegionName
        }
    }
    var OrderState = 0 {
        didSet{
            if OrderState == 0 {
                orderState = "取消"
            }else if OrderState == 1 {
                orderState = "正常"
            }else{
                orderState = "关闭"
            }
        }
    }
    var PayState = 0 {
        didSet{
            if PayState == 0 {
                payState = "未支付"
            }else if PayState == 1 {
                payState = "已支付"
            }else{
                payState = "退款"
            }
        }
    }
    var BeginTime = ""
    var EndTime = ""
    var Times = ""
    var OrderDate = ""
    var AmountYF = ""
    var AmountSF = ""
    var CancelDate = ""
    var AmountTK = ""
    var SignInTime = "" {
        didSet {
            SignInTime = SignInTime=="" ? "暂无" : SignInTime
        }
    }
    var SignOutTime = ""
    var SignInTicket = ""
    var StuPjState = 9 {
        didSet{
            stuPjState = StuPjState == 0 ? "未评价" : "已评价"
        }
    }
    var CancelTimes = ""
    var PayDate = ""{
        didSet {
            PayDate = PayDate=="" ? "暂无" : PayDate
        }
    }
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        orderId <- map["ID"]
        OrderNo <- map["OrderNo"]
        InsId <- map["InsId"]
        SchoolName <- map["SchoolName"]
        CoachId <- map["CoachId"]
        CoachName <- map["CoachName"]
        CoachIdCard <- map["CoachIdCard"]
        CoachMobile <- map["CoachMobile"]
        StuId <- map["StuId"]
        StuName <- map["StuName"]
        StuIdCard <- map["StuIdCard"]
        StuMobile <- map["StuMobile"]
        Subject <- map["Subject"]
        RegionId <- map["RegionId"]
        RegionName <- map["RegionName"]
        OrderState <- map["OrderState"]
        PayState <- map["PayState"]
        BeginTime <- map["BeginTime"]
        EndTime <- map["EndTime"]
        Times <- map["Times"]
        OrderDate <- map["OrderDate"]
        AmountYF <- map["AmountYF"]
        AmountSF <- map["AmountSF"]
        CancelDate <- map["CancelDate"]
        AmountTK <- map["AmountTK"]
        SignInTime <- map["SignInTime"]
        SignOutTime <- map["SignOutTime"]
        StuPjState <- map["StuPjState"]
        CancelTimes <- map["CancelTimes"]
        PayDate <- map["PayDate"]
    }
}
