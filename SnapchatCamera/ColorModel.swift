//
//  ColorModel.swift
//  testingPubNub
//
//  Created by Geemakun Storey on 8/26/15.
//  Copyright (c) 2015 StoreyOfGee. All rights reserved.
//

import Foundation
import UIKit
import GameKit

enum LowerColor: String {
    case blue, red, yellow, black, white, green, purple, orange, brown, gold, aqua, silver
}


struct ColorModel {
    let lowerColors = [
        (color: LowerColor.black.rawValue),
        (color: LowerColor.blue.rawValue),
        (color: LowerColor.red.rawValue),
        (color: LowerColor.yellow.rawValue),
        (color: LowerColor.white.rawValue),
        (color: LowerColor.green.rawValue),
        (color: LowerColor.purple.rawValue),
        (color: LowerColor.brown.rawValue),
        (color: LowerColor.orange.rawValue),
        (color: LowerColor.aqua.rawValue),
        (color: LowerColor.silver.rawValue),
        (color: LowerColor.gold.rawValue)
        
    ]    
}
