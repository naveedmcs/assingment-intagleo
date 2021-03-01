//
//  BaseAPIManager.swift
//  Intagleo Assignment By Naveed
//
//  Created by Muhammad  Naveed on 28/02/2021.
//  Copyright © 2021 Itagleo. All rights reserved.
//

import Foundation
import Alamofire




class BaseAPIManager {
    enum  EndPoint: String {
        case photos = "photos"
    }
    
    var baseURL = "https://jsonplaceholder.typicode.com/"
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        //       configuration.requestCachePolicy = .returnCacheDataElseLoad
        //       let responseCacher = ResponseCacher(behavior: .modify { _, response in
        //         let userInfo = ["date": Date()]
        //         return CachedURLResponse(
        //           response: response.response,
        //           data: response.data,
        //           userInfo: userInfo,
        //           storagePolicy: .allowed)
        //       })
        
        let networkLogger = AlamoFireNetworkLogger()
        
        // let interceptor = GitRequestInterceptor()
        
        return Session(
            configuration: configuration,
            //interceptor: interceptor,
            // cachedResponseHandler: responseCacher,
            eventMonitors: [networkLogger])
    }()
    
    
    
    
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = []
        headers.update(HTTPHeader(name: "Content-Type", value: "multipart/form-data"))
        return headers
        
    }
}







//MARK:-
enum ResultAPI<T,String>{
    case failure(String)
    case success(T)
}


class AlamoFireNetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "@nvd.mcs.networklogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data?.prettyPrintedJSONString else {
            return
        }
        
        print("API Response:\n\(data) ")
    }
}

extension Data {
    
    
    var prettyPrintedJSONString: NSString? {
        
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}




