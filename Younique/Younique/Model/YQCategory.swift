//
//  YQCategory.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/29/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQCategory: NSObject, NSCopying {
    var categoryId: String = ""
    var title: String = ""
    var items = [YQItem]()
    
    override init() {
        
    }
    
    init(categoryId: String, title: String, items: [YQItem]) {
        self.categoryId = categoryId
        self.title = title
        self.items = items
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return YQCategory(categoryId: categoryId, title: title, items: items)
    }
    
    class func getCategoriesFrom(dictionary: [String: Any], array: [[String: Any]]) -> YQCategory {
        let category = YQCategory()
        category.categoryId = "\(dictionary["id"] ?? "")"
        category.title = (dictionary["category_name"] as? String) ?? ""
        
        var items : [YQItem] = []
        
        for object in array {
            let item = YQItem()
            item.itemId = "\((object["id"] as? NSNumber) ?? 0)"
            item.itemUrl = (object["image_url"] as? String) ?? ""
            item.itemName = (object["name"] as? String) ?? ""
            item.itemPrice = (object["price"] as? CGFloat) ?? 0.0
            item.itemSku = (object["sku"] as? String) ?? ""
            items.append(item)
        }
        
        category.items = items
        return category
    }
}
