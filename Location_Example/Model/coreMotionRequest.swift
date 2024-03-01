//
//  coreMotionRequest.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/01.
//

import Foundation

struct coreMotionRequest : Encodable {
    var accValueX : Double
    var accValueY : Double
    var accValueZ: Double
    var gyroValueX : Double
    var gyroValueY : Double
    var gyroValueZ : Double
    var magValueX : Double
    var magValueY : Double
    var magValueZ : Double
    var apValue : Double
    var time : String
}
