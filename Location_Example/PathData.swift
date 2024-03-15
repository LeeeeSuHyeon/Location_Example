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
//            CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
//            CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
//            CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
//            CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
//            CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
//            CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
//            CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
//            CLLocationCoordinate2D(latitude: 37.455010, longitude: 127.127867)
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
//    let route : [CLLocationCoordinate2D] = [
//        CLLocationCoordinate2D(latitude: 37.455287, longitude: 127.133823),
//        CLLocationCoordinate2D(latitude: 37.455516, longitude: 127.133089),
//        CLLocationCoordinate2D(latitude: 37.455730, longitude: 127.133485),
//        
//    ]
    
    
    // AI 뒷길 -> 집
//    let route : [CLLocationCoordinate2D] = [
//        CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
//        CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
//        CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
//        CLLocationCoordinate2D(latitude: 37.455074, longitude: 127.130708),
//        CLLocationCoordinate2D(latitude: 37.454772, longitude: 127.130626),
//        CLLocationCoordinate2D(latitude: 37.454856, longitude: 127.130042),
//        CLLocationCoordinate2D(latitude: 37.455252, longitude: 127.129341),
//        CLLocationCoordinate2D(latitude: 37.454806, longitude: 127.128760),
//        CLLocationCoordinate2D(latitude: 37.454797, longitude: 127.127906),
//        CLLocationCoordinate2D(latitude: 37.454971, longitude: 127.127896),
//    ]
    
    
    // 중도 주차장 -> 학생회관
//    let route : [CLLocationCoordinate2D] = [
//        CLLocationCoordinate2D(latitude: 37.452865, longitude: 127.133457),
//        CLLocationCoordinate2D(latitude: 37.452643, longitude: 127.133596),
//        CLLocationCoordinate2D(latitude: 37.452954, longitude: 127.134127),
//        
//    ]
    
    
    // 중도 주차장 -> 운동장
    let route : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.452643, longitude: 127.133596),
        CLLocationCoordinate2D(latitude: 37.452976, longitude: 127.133416),
        CLLocationCoordinate2D(latitude: 37.453414, longitude: 127.134030),
        CLLocationCoordinate2D(latitude: 37.453743, longitude: 127.134703),
        CLLocationCoordinate2D(latitude: 37.454960, longitude: 127.135190)
    ]
    
    // 중도 -> 집
//    let route : [CLLocationCoordinate2D] = [
//        CLLocationCoordinate2D(latitude: 37.452643, longitude: 127.133596),
//        CLLocationCoordinate2D(latitude: 37.452976, longitude: 127.133416),
//        CLLocationCoordinate2D(latitude: 37.453414, longitude: 127.134030),
//        CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
//        CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
//        CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
//        CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
//        CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
//        CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
//        CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
//        CLLocationCoordinate2D(latitude: 37.455010, longitude: 127.127867)
//    ]
}
