//
//  PahtData.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/07.
//

import Foundation
import ARKit


struct PathData {
    // AI -> 집
    //    let route : [CLLocationCoordinate2D] = [
    //        CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
    //        CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
    //        CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
    //        CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
    //        CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
    //        CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
    //        CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
    //        CLLocationCoordinate2D(latitude: 37.455010, longitude: 127.127867)
    //    ]
    //
    // 수집 -> 민집
    //    let route : [CLLocation] = [
    //        CLLocation(latitude: 37.454971, longitude: 127.127896),
    //        CLLocation(latitude: 37.454797, longitude: 127.127906),
    //        CLLocation(latitude: 37.454806, longitude: 127.128760),
    //        CLLocation(latitude: 37.455005, longitude: 127.129023)
    //    ]
    //
    // 집 -> AI
    //    let route : [CLLocationCoordinate2D] = [
    //        CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
    //        CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
    //        CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
    //        CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
    //        CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
    //        CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
    //        CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
    //        CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315)
    //    ]
    
    // 중도 입구
    //    let route : [CLLocationCoordinate2D] = [
    //        CLLocationCoordinate2D(latitude: 37.452451, longitude: 127.132802),
    //        CLLocationCoordinate2D(latitude: 37.452640, longitude: 127.132681),
    //        CLLocationCoordinate2D(latitude: 37.452824, longitude: 127.133219)
    //
    //    ]
    
    
    
    // AI - 중도
//    let route : [CLLocationCoordinate2D] = [
//        CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
//        CLLocationCoordinate2D(latitude: 37.452451, longitude: 127.132802),
//        CLLocationCoordinate2D(latitude: 37.452640, longitude: 127.132681),
//        
//    ]
    
    // AI -> 3긱 (인도 없는 구역)
    let route : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.455287, longitude: 127.133823),
        CLLocationCoordinate2D(latitude: 37.455516, longitude: 127.133089),
        CLLocationCoordinate2D(latitude: 37.455730, longitude: 127.133485),
        
    ]
}
