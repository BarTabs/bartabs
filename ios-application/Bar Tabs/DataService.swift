//
//  GetService.swift
//  Bar Tabs
//
//  Created by Victor Lora on 3/26/17.
//  Copyright © 2017 muhlenberg. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataService {
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let parentView: UIViewController
    var showActivityIndicator = true
    
    // Defined in AppDelegate.swift
    let url = _url
    
    init(view: UIViewController) {
        self.parentView = view
    }
    
    init(view: UIViewController, showActivityIndicator: Bool) {
        self.parentView = view
        self.showActivityIndicator = showActivityIndicator
    }
    
    func fetchData(service: String, parameters: Parameters, showActivityIndicator: Bool, completion: @escaping (_ callback:JSON) -> Void) {
        self.showActivityIndicator = showActivityIndicator
        
        URLCache.shared.removeAllCachedResponses()
        
        var authToken = ""

        if let token = UserDefaults.standard.string(forKey: "token") {
            authToken = token
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : authToken
        ]
        
        let serviceUrl = (url + service)
        
        showActivityIndicatory(uiView: parentView.view)
        
        Alamofire.request(serviceUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print(response)
            if let rawResponse = response.result.value {
                let json = JSON(rawResponse)
                
                if json["status"] != JSON.null && json["status"].intValue == 0 {
                    self.hideActivityIndicator(uiView: self.parentView.view)
                    completion(json["data"])
                } else if (json["message"] != JSON.null) {
                    self.hideActivityIndicatorCreateAlert(titleText: "Data Error", messageText: json["message"].stringValue)
                } else {
                    self.hideActivityIndicatorCreateAlert(titleText: "Data Error", messageText: "There was a problem receiving the data.")
                }
            } else {
                self.hideActivityIndicatorCreateAlert(titleText: "Data Error", messageText: "There was a problem with the request. Please try again.")
            }
        }
    }
    
    func fetchData(service: String, parameters: Parameters, completion: @escaping (_ callback:JSON) -> Void) {
        self.fetchData(service: service, parameters: parameters, showActivityIndicator: self.showActivityIndicator, completion: completion)
    }

    func post(service: String, parameters: Parameters, showActivityIndicator: Bool, completion: @escaping (_ callback:JSON) -> Void) {
        self.showActivityIndicator = showActivityIndicator
        
        URLCache.shared.removeAllCachedResponses()
        
        var authToken = ""
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            authToken = token
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : authToken
        ]
        
        let serviceUrl = (url + service)
        
        showActivityIndicatory(uiView: parentView.view)
        
        Alamofire.request(serviceUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let rawResponse = response.result.value {
                let json = JSON(rawResponse)
                
                if json["status"] != JSON.null && json["status"].intValue == 0 {
                    self.hideActivityIndicator(uiView: self.parentView.view)
                    completion(json["data"])
                } else if (json["message"] != JSON.null) {
                    self.hideActivityIndicatorCreateAlert(titleText: "Data Error", messageText: json["message"].stringValue)
                } else {
                    self.hideActivityIndicatorCreateAlert(titleText: "Data Error", messageText: "There was a problem receiving the data.")
                }
            } else {
                self.hideActivityIndicatorCreateAlert(titleText: "Data Error", messageText: "There was a problem with the request. Please try again.")
            }
        }
    }
    
    func post(service: String, parameters: Parameters, completion: @escaping (_ callback:JSON) -> Void) {
        post(service: service, parameters: parameters, showActivityIndicator: self.showActivityIndicator, completion: completion)
    }

    
    func hideActivityIndicatorCreateAlert(titleText: String, messageText: String) {
        if showActivityIndicator {
            self.hideActivityIndicator(uiView: self.parentView.view)
        }
        
        self.createAlert(titleText: titleText, messageText: messageText)
    }
    
    // Create alert function
    func createAlert(titleText: String, messageText: String) {
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        parentView.present(alert, animated: true, completion: nil)
    }
    
    // Create func for activity indicator to display on screen
    func showActivityIndicatory(uiView: UIView) {
        if (showActivityIndicator) {
            container.frame = uiView.frame
            container.center = uiView.center
            container.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
            loadingView.frame = self.CGRectMake(0, 0, 80, 80)
            loadingView.center = uiView.center
            loadingView.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
        
            activityIndicator.frame = self.CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2,
                                           y:loadingView.frame.size.height / 2);
            loadingView.addSubview(activityIndicator)
            container.addSubview(loadingView)
            uiView.addSubview(container)
            activityIndicator.startAnimating()
        }

    }
    
    // Create func for rectangular graphic container for activity indicator
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    // Create func to hide the activity indicator
    func hideActivityIndicator(uiView: UIView) {
        if showActivityIndicator {
            activityIndicator.stopAnimating()
            container.removeFromSuperview()
        }
    }
}
