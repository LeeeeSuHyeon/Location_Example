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
        var start = route[0]
        
        // 경로의 첫지점부터 마지막 지점까지
        for i in 0..<route.count - 1{
            let step = Step().intermediateRouteInfo(
                start: start,
                end: route[i+1],
                name: String(i+1)
            )
            start = route[i]
            
            steps.append(step)
        }
        return steps
    }
}
