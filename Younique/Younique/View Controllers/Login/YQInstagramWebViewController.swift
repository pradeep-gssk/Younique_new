//
//  YQInstagramWebViewController.swift
//  LashandCarry
//
//  Created by Krishna Pradeep on 10/26/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQInstagramWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var didFetchAccessToken: ((String) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cookies = HTTPCookieStorage.shared.cookies
        for cookie in cookies!{
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        
        self.showLoadingScreen()
        
        let fullURL = "\(AUTHURL)?client_id=\(CLIENTID)&redirect_uri=\(REDIRECTURI)&response_type=token&scope=basic"
        self.webView.loadRequest(URLRequest(url: URL(string: fullURL)!))
    }

    @IBAction func didClickCancelButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideLoadingScreen()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.url?.absoluteString
        
        if request.url!.params["error"] != nil{
            let errorAlert = UIAlertController(title: "Error: \(String(describing: request.url!.params["error_reason"]))", message: "\(String(describing: request.url!.params["error_description"])).", preferredStyle: .alert)
            
            let exitAction = UIAlertAction(title: "Okay", style: .default, handler: { (action:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            errorAlert.addAction(exitAction)
            
            self.present(errorAlert, animated: true, completion: nil)
            
            return false
        }
        
        if let range = urlString!.range(of: REDIRECTURI + "#access_token=") {
            let location = range.upperBound
            let access_token = String(urlString![location...])
            
            if let block = didFetchAccessToken {
                block(access_token)
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            return false
        }
        
        return true
    }
}

extension URL {
    var params: [String: String] {
        get {
            let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
            var items = [String: String]()
            for item in urlComponents?.queryItems ?? [] {
                items[item.name] = item.value ?? ""
            }
            return items
        }
    }
}
