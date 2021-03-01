//
//  PhotosAPIManager.swift
//  Intagleo Assignment By Naveed
//
//  Created by Muhammad  Naveed on 28/02/2021.
//  Copyright © 2021 Itagleo. All rights reserved.
//

import Foundation
import Alamofire






class PhotosAPIManager: BaseAPIManager {
    
   
    private var endPoint = EndPoint.self
    
    
    
    

    
    func photoList(completion: @escaping (ResultAPI<[PhotoResponseModel], String>) -> Void)  {
        
        let url = baseURL + endPoint.photos.rawValue
        let request = sessionManager.request(url, method: .get, parameters: nil)
        request.responseDecodable(of: [PhotoResponseModel].self){ (response) in
            switch response.result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }

    
}
