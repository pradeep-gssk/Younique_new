//
//  APIManager.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/26/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    static let shared = APIManager()
    
    func login(router: Router, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        self.requestString(router: router, success: { (access_token) in
            self.checkIfPresenter(withToken: access_token, success: {
                success()
            }, failure: { (error) in
                failure(error)
            })
        }, failure: { (error: Error) in
            failure(error)
        })
    }
    
    func checkIfPresenter(withToken token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let router = Router(endpoint: .UserInfo(access_token: token))
        
        self.requestJSON(router: router, success: { (response) in
            let json = response.dictionary
            if let isPresenter = json["presenter_status_id"] as? Int{
                if isPresenter == 3{
                    if let user = json["user"] as? [String: Any] {
                        var name = ""
                        if let value = user["first_name"] as? String {
                            name = value
                        }
                        if let value = user["last_name"] as? String {
                            if name.characters.count == 0 {
                                name = value
                            }
                            else {
                                name = "\(name) \(value)"
                            }
                        }
                        if let isUSA = json["market_id"] as? Int{
                            if isUSA == 1{
                                YQUser.shared.accessToken = token
                                YQUser.shared.userName = name
                                YQUser.shared.save()
                                success()
                                return
                            }
                        }
                    }
                }
            }
            failure(NSError(domain:notPresenter , code:999, userInfo:nil))

        }, failure: { (error: Error) in
            failure(error)
        })
    }
    
    func getCategories(router: Router, success: @escaping (_ categories: [YQCategory]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        self.requestJSON(router: router, success: { (response) in
            var categories : [YQCategory] = []
            let dispatchGroup = DispatchGroup()
            var dictionary: [String: [String: Any]] = [:]
            
            for category in response.array {
                let id = category["id"] ?? ""
                let name = (category["category_name"] as? String) ?? ""
                dictionary[name] = category
                
                dispatchGroup.enter()
                
                let router = Router(endpoint: .GetItemsByCategoryId(id: "\(id)"))
                self.requestJSON(router: router, success: { (response) in
                    
                    if response.array.count > 0 {
                        let categoryName = (response.array.first?["category_name"] as? String) ?? ""
                        if let object = dictionary[categoryName] {
                            categories.append(YQCategory.getCategoriesFrom(dictionary: object, array: response.array))
                        }
                    }
                    
                    dispatchGroup.leave()
                    
                }, failure: { (error: Error) in
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                
                let sortedCategories = categories.sorted(by: { (object1: YQCategory, object2: YQCategory) -> Bool in
                    return object1.categoryId < object2.categoryId
                })
                
                success(sortedCategories)
            })
            
        }, failure: { (error: Error) in
            failure(error)
        })
    }
    
    func requestString(router: Router, success: @escaping (_ string: String) -> Void, failure: @escaping (_ error: Error) -> Void) {
        do {
            let request = try URLRequest(router: router)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    failure(error!)
                }
                else {
                    if let data = data, let responseString = String(data: data, encoding: String.Encoding.ascii) {
                        success(responseString)
                    }
                    else {
                        failure(NSError(domain:"Wrong data", code:999, userInfo:nil))
                    }
                }
            }.resume()
        }
        catch {
            failure(error)
        }
    }
    
    func requestJSON(router: Router, success: @escaping (_ response: Response) -> Void, failure: @escaping (_ error: Error) -> Void) {
        do {
            let request = try URLRequest(router: router)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    failure(error!)
                }
                else {
                    do {
                        let response = try Response.getResponseFromData(data)
                        success(response)
                    }
                    catch {
                        failure(error)
                    }
                }
            }.resume()
        }
        catch {
            failure(error)
        }
    }
}
