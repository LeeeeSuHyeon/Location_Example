//
//  GetIntermediateCordinate.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation

class GetIntermediateCoordinate {
    
    
    static func getCoordinates(route : [LocationDetails]) -> [Step] {
        var steps = [Step] ()
        
//        steps = Step().intermediateRouteInfo(leg)
        // Step()의 intermediateRouteInfo() 메서드를 호출하여 [Step] 반환
        
        for i in 0..<route.count {
            let step = Step().intermediateRouteInfo(start: route[i], end: route[i+1], name: String(i))
            steps.append(step)
        }
        return steps
    }
}
