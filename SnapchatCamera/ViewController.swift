//
//  ViewController.swift
//  SnapchatCamera
//
//  Created by Geemakun Storey on 8/26/15.
//  Copyright (c) 2015 StoreyOfGee. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Eve"
        let view1 : View1 = View1(nibName: "View1", bundle: nil)
        let view2 : View2 = View2(nibName: "View2", bundle: nil)
        let view3 : View3 = View3(nibName: "View3", bundle: nil)
        
        self.addChildViewController(view1)
        self.scrollView.addSubview(view1.view)
        view1.didMove(toParentViewController: self)
        
        self.addChildViewController(view2)
        self.scrollView.addSubview(view2.view)
        view2.didMove(toParentViewController: self)
        
        self.addChildViewController(view3)
        self.scrollView.addSubview(view3.view)
        view3.didMove(toParentViewController: self)
        
        var v2Frame : CGRect = view2.view.frame
        v2Frame.origin.x = self.view.frame.width
        view2.view.frame = v2Frame
        
        var v3Frame : CGRect = view3.view.frame
        v3Frame.origin.x = self.view.frame.width * 2
        view3.view.frame = v3Frame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

