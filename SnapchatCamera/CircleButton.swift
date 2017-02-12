//
//  CircleButton.swift
//  SnapchatCamera
//
//  Created by Geemakun Storey on 8/26/15.
//  Copyright (c) 2015 StoreyOfGee. All rights reserved.
//

import UIKit
@IBDesignable
class CircleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet{
            setUpView()
        }
    }
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    func setUpView() {
        layer.cornerRadius = cornerRadius
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
