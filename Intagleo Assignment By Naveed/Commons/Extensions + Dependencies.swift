//
//  Extensions + Dependencies.swift
//  Intagleo Assignment By Naveed
//
//  Created by Muhammad  Naveed on 28/02/2021.
//  Copyright © 2021 Itagleo. All rights reserved.
//

import UIKit
import Kingfisher



// extended ImageView to load Image by URL
extension UIImageView {
    
    enum PlaceHolderType: String {
        case user = "userPlaceholder"
        case produt = "productPlaceholder"
    }
    
    func loadImageURL(_ stringURL: String?, placeHolder: PlaceHolderType?) {
        
        let url = URL(string: stringURL ?? "")
        let placeholder =  UIImage(named: placeHolder?.rawValue ?? "")
        
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        //  |> RoundCornerImageProcessor(cornerRadius: 20)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        self.image = value.image
                        print("Task done for Image: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed for Image: \(error.localizedDescription)")
                    }
                })
    }
}

//MARK:-  string extensions

extension String{
    
    func attributedString(subStr: String, color: UIColor = UIColor.red ) -> NSMutableAttributedString{
        let range = (self as NSString).range(of: subStr)
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        
        return attributedString
    }
    
}

//MARK:-  NSOBject Extension
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}



//MARK:-  sequence grouping
class Box<A> {
    var value: A
    init(_ val: A) {
        self.value = val
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: Box<[Iterator.Element]>] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.value.append(element) {
                categories[key] = Box([element])
            }
        }
        var result: [U: [Iterator.Element]] = Dictionary(minimumCapacity: categories.count)
        for (key, val) in categories {
            result[key] = val.value
        }
        return result
    }
}
//MARK:-  alert controller
extension UIAlertController {
    static func actionSheetWithItems<A : Equatable>(items : [(title : String, value : A)], currentSelection : A? = nil, action : @escaping (A) -> Void) -> UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (var title, value) in items {
            if let selection = currentSelection, value == selection {
                // Note that checkmark and space have a neutral text flow direction so this is correct for RTL
                title = "✔︎ " + title
            }
            controller.addAction(
                UIAlertAction(title: title, style: .default) {_ in
                    action(value)
                }
            )
        }
        return controller
    }
}


extension UIViewController {
//Show a basic alert
func showAlert(alertText : String = "Alert", alertMessage : String) {
    let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
//Add more actions as you see fit
self.present(alert, animated: true, completion: nil)
  }
}

extension Int {
    var toString: String {
        return "\(self)"
    }
}


//MARK:-  tableview

extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .medium)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}


