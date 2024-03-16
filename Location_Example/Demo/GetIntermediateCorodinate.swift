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
        
        // arViewSetup() - stepData.enumrated()에서 첫번째 노드부터 다음 노드까지의 경로를 구하기 위해 0 번째 노드를 빼고 step 생성
        for i in 0..<route.count{
            let step = Step().intermediateRouteInfo(end: route[i], name: String(i+1))
            steps.append(step)
        }
        return steps
    }
}
