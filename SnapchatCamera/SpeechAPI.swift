//
//  SpeechAPI.swift
//  SnapchatCamera
//
//  Created by Geemakun Storey on 8/26/15.
//  Copyright (c) 2015 StoreyOfGee. All rights reserved.
//

import Foundation

protocol SpeechAPIRequest {
    func requestAuthorization()
}

protocol SpeechAPIStartRecording {
    func startRecording()
}
