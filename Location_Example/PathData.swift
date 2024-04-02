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
        let AIToHome : [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
            CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
            CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
            CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
            CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
            CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
            CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
            CLLocationCoordinate2D(latitude: 37.455010, longitude: 127.127867)
        ]
    //
    // 수집 -> 민집
        let homeToMin : [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.454971, longitude: 127.127896),
            CLLocationCoordinate2D(latitude: 37.454797, longitude: 127.127906),
            CLLocationCoordinate2D(latitude: 37.454806, longitude: 127.128760),
            CLLocationCoordinate2D(latitude: 37.455005, longitude: 127.129023)
        ]
    //
    // 집 -> AI
        let homeToAI : [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.454971, longitude: 127.127896),
            CLLocationCoordinate2D(latitude: 37.454797, longitude: 127.127906),
            CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
            CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
            CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
            CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
            CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
            CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315)
        ]
    
    // 중도 입구
    //    let route : [CLLocationCoordinate2D] = [
    //        CLLocationCoordinate2D(latitude: 37.452451, longitude: 127.132802),
    //        CLLocationCoordinate2D(latitude: 37.452640, longitude: 127.132681),
    //        CLLocationCoordinate2D(latitude: 37.452824, longitude: 127.133219)
    //
    //    ]
    
    
    
    // 집 앞
    let homeGround : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.455059, longitude: 127.127051),
        CLLocationCoordinate2D(latitude: 37.454531, longitude: 127.127373),
        CLLocationCoordinate2D(latitude: 37.454624, longitude: 127.128746),
        CLLocationCoordinate2D(latitude: 37.455425, longitude: 127.128655),
        CLLocationCoordinate2D(latitude: 37.455433, longitude: 127.127067),
        CLLocationCoordinate2D(latitude: 37.455191, longitude: 127.127072),
    ]
    
    // AI -> 3긱 (인도 없는 구역)
    let AITo3Dorm : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.455287, longitude: 127.133823),
        CLLocationCoordinate2D(latitude: 37.455516, longitude: 127.133089),
        CLLocationCoordinate2D(latitude: 37.455730, longitude: 127.133485),
    ]
    
    
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
    let route : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.452865, longitude: 127.133457),
        CLLocationCoordinate2D(latitude: 37.452643, longitude: 127.133596),
        CLLocationCoordinate2D(latitude: 37.452954, longitude: 127.134127),
        
    ]
    
    // 소요시간 
    let CLroute : [CLLocation] = [
        CLLocation(latitude: 37.452539, longitude: 127.132948),
        CLLocation(latitude: 37.452614, longitude: 127.133104),
        CLLocation(latitude: 37.452691, longitude: 127.133104),
        CLLocation(latitude: 37.452717, longitude: 127.132873),
        CLLocation(latitude: 37.452610, longitude: 127.132822),
        CLLocation(latitude: 37.452508, longitude: 127.132851),

    ]
    
    
    // 중도 주차장 -> 운동장
    let libraryToGround : [CLLocationCoordinate2D] = [
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
    
    let Dorm2ToEdu : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.455895, longitude: 127.134636),
        CLLocationCoordinate2D(latitude: 37.453854, longitude: 127.134786),
        CLLocationCoordinate2D(latitude: 37.453518, longitude: 127.134297),
        CLLocationCoordinate2D(latitude: 37.453399, longitude: 127.134004),
        CLLocationCoordinate2D(latitude: 37.453063, longitude: 127.133620),
        CLLocationCoordinate2D(latitude: 37.452353, longitude: 127.131802),
        CLLocationCoordinate2D(latitude: 37.452043, longitude: 127.131665),
    ]
    
    
    let test : [CLLocation] = [
        CLLocation(latitude: 37.450629, longitude: 127.127454),
        CLLocation(latitude: 37.450635, longitude: 127.127601),
        CLLocation(latitude: 37.451251, longitude: 127.127608),
        CLLocation(latitude: 37.451495, longitude: 127.127438),
        CLLocation(latitude: 37.451669, longitude: 127.127610),
    ]
}
