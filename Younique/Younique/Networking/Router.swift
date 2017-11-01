//
//  Router.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/26/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

enum Provider {
    case facebook
    case instagram
    
    func getProvider() -> String {
        switch self {
        case .facebook:
            return "Facebook"
        case .instagram:
            return "Instagram"
        }
    }
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]

enum Endpoint {
    case Login(email: String, password: String)
    case SocialLogin(type: Provider, token: String)
    case UserInfo(access_token: String)
    case GetCategories
    case GetItemsByCategoryId(id: String)
}

class Router: NSObject {
    var endpoint: Endpoint
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
        super.init()
    }
    
    var method: HTTPMethod {
        switch self.endpoint {
        case .Login, .SocialLogin:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self.endpoint {
        case .Login: return "users/login"
        case .SocialLogin: return "login/oauth"
        case .UserInfo: return "presenters"
        case .GetCategories: return "items/categories/mobile"
        case .GetItemsByCategoryId(let id): return "items/categories/\(id)/mobile"
        }
    }
    
    var parameters: Parameters {
        switch self.endpoint{
        case .Login(let email, let password):
            let parameters: Parameters = [
                "email": email,
                "password": password
            ]
            return parameters
        case .SocialLogin(let type, let token):
            let parameters: Parameters = [
                "provider": type.getProvider(),
                "token": token
            ]
            return parameters
        default:
            return [:]
        }
    }
    
    var headers: HTTPHeaders {
        switch self.endpoint {
        case .Login, .SocialLogin: return ["Content-Type": "application/x-www-form-urlencoded"]
        case .UserInfo(let access_token):
            return [ "Authorization": "Bearer \(access_token)",
                "X-MICROTIME": String(describing: getCurrentMillis())]
        default:
            return [ "Authorization": "Bearer \(YQUser.shared.accessToken)",
                "X-MICROTIME": String(describing: getCurrentMillis())]
        }
    }
    
    var fullPath: String {
        return "\(baseUrl)\(self.path)"
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
}
