//
//  Step.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//


import Foundation
import CoreLocation

struct Step {
    var distance: String = "" // 경로의 이동 거리
    var duration: String = "" // 경로의 소요 시간
    var endLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // 목적지 위치
    var locationName: String = "" // 단계의 위치 이름
    
    func intermediateRouteInfo(_ leg: [String: Any]) -> [Step] {
        var steps = [Step] ()
        
        // 중간 노드 사이의 이동 거리, 소요 시간, 목적지 위치, 단계의 위치 이름을 계산하고 Step 구조로 변경 후 반환하는 코드 필요
        
        return steps
    }
}