//
//  PhotoTableViewCell.swift
//  Intagleo Assignment By Naveed
//
//  Created by Muhammad  Naveed on 28/02/2021.
//  Copyright © 2021 Itagleo. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak private var thumbnail: UIImageView?
    @IBOutlet weak private var id: UILabel?
    @IBOutlet weak private var title: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(object: PhotoResponseModel)  {
        self.id?.text = object.id?.toString
        self.title?.text = object.title
        self.thumbnail?.loadImageURL(object.thumbnailURL, placeHolder: nil)
    }
}

