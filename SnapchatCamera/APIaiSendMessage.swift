//
//  APIaiSendMessage.swift
//  SnapchatCamera
//
//  Created by Geemakun Storey on 2017-02-11.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import Foundation
import UIKit

//func sendText() {
//    let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
//
//    
//    let request = ApiAI.shared().textRequest()
//    
//    if let text = self.textField?.text {
//        request?.query = [text]
//    } else {
//        request?.query = [""]
//    }
//    
//    request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
//        let resultNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultNavigationController
//        
//        resultNavigationController.response = response as AnyObject?
//        
//        self.present(resultNavigationController, animated: true, completion: nil)
//        
//        hud.hide(animated: true)
//        }, failure: { (request, error) -> Void in
//            hud.hide(animated: true)
//    });
//    
//    ApiAI.shared().enqueue(request)
//    
//}
