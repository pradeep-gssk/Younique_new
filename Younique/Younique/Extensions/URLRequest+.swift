//
//  URLRequest+.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/27/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import Foundation

extension URLRequest {
    init(router: Router) throws {
        
        guard let url = URL(string: router.fullPath) else {
            throw NSError(domain:"Wrong Url", code:999, userInfo:nil)
        }
        
        self.init(url: url)
        self.httpMethod = router.method.rawValue
        
        if router.headers.count > 0 {
            for (headerField, headerValue) in router.headers {
                self.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if router.parameters.count > 0 {
            let parameters = router.parameters.map { "\($0)=\($1)" }.joined(separator: "&")
            self.httpBody = parameters.data(using: .utf8, allowLossyConversion: false)
        }
    }
}

