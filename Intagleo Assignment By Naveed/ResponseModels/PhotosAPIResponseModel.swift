//
//  PhotosAPIResponseModel.swift
//  Intagleo Assignment By Naveed
//
//  Created by Muhammad  Naveed on 28/02/2021.
//  Copyright © 2021 Itagleo. All rights reserved.
//

import Foundation


struct PhotoResponseModel: Decodable, Hashable{
    let albumID, id: Int?
    let title: String?
    let url, thumbnailURL: String?
  
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(albumID)
        hasher.combine(title)
        hasher.combine(url)
        hasher.combine(thumbnailURL)
    }
}

//typealias Photos = [PhotoResponseModel]
