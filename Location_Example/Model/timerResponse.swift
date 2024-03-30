//
//  timerResponse.swift
//  Location_Example
//
//  Created by 이수현 on 3/30/24.
//

import Foundation

struct TimerRequest : Encodable {
    var point1_x : Double
    var point1_y : Double
    var point2_x : Double
    var point2_y : Double
    var takeTime : Double
}
