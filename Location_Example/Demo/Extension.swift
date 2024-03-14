//
//  Extension.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import UIKit
import ARKit
import SceneKit

extension SCNVector3 {
    // 현재점과 목적지 점 사이의 거리를 계산
    func distance(receiver: SCNVector3) -> Float {
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        if distance < 0 {
            return distance * -1
        } else {
            return distance
        }
    }
}
