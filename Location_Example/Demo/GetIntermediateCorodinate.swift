//
//  GetIntermediateCordinate.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import CoreLocation


class GetIntermediateCoordinate {
    static func getCoordinates(route : [LocationDetails]) -> [Step] {
        var steps = [Step] ()
        
        // 경로의 첫지점부터 마지막 지점까지
        for i in 0..<route.count - 1{
            let next = i+2 == route.count ? 0 : i+2 // 마지막 경로의 next는 route[0]으로 표시
            let step = Step().intermediateRouteInfo(
                start: route[i],
                end: route[i+1],
                next: route[next],
                name: String(i+1)
            )
            
            steps.append(step)
        }
        return steps
    }
}


struct Step {
    var startLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // 단계별 출발지 위치
    var endLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // 단계별 목적지 위치
    var nextLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // 단계별 목적지 다음 위치
    var locationName: String = "" // 단계의 위치 이름
    
    
    
    func intermediateRouteInfo(start : LocationDetails, end : LocationDetails, next : LocationDetails, name : String) -> Step {
        let startLocation = CLLocationCoordinate2D(latitude: start.lat, longitude: start.lng)
        
        let endLocation = CLLocationCoordinate2D(latitude: end.lat, longitude: end.lng)
        
        let nextLocation = CLLocationCoordinate2D(latitude: next.lat, longitude: next.lng)
        
        // 중간 노드 사이의 이동 거리, 소요 시간, 목적지 위치, 단계의 위치 이름을 계산하고 Step 구조로 변경 후 반환하는 코드 필요
        
        return Step(startLocation: startLocation, endLocation: endLocation, nextLocation: nextLocation, locationName: name)
    }
}
