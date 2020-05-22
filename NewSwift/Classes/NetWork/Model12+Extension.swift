//
//  Model12+Extension.swift
//  NewSwift
//
//  Created by gail on 2019/4/24.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension Observable {
    
    /// 将字典转为model
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            guard let dict = response as? [String: Any] else {
                throw self.parseError(response: response)
            }
            
            guard let model = Mapper<T>().map(JSON: dict) else {
                throw self.parseError(response: response)
            }
            return model
        }
    }
    
    /// 将字典数组转为model数组
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            guard let array = response as? [[String: Any]] else {
                throw self.parseError(response: response)
            }
            return Mapper<T>().mapArray(JSONArray: array)
        }
    }
    
    /// 抛出解析的错误
    private func parseError(response: Any) -> MoyaError {
        if let _response = response as? Response {
            return MoyaError.statusCode(_response)
        }
        
        // 解析失败时，作为服务器响应错误处理
        let data = try? JSONSerialization.data(withJSONObject: response, options: [])
        let _response = Response(statusCode: 555, data: data ?? Data())
        return MoyaError.statusCode(_response)
    }
}
