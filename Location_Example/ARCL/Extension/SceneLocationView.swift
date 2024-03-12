////
////  SceneLocationView.swift
////  Location_Example
////
////  Created by 이수현 on 2024/03/10.
////
//
//import Foundation
//import ARCL
//import CoreLocation
//import NMapsMap
//import SceneKit
//
//// 사용법 예시
//// SceneLocationView 클래스를 사용할 때는 NMapsMap SDK가 아닌 SceneKit을 기반으로 한 ARKit+CoreLocation 라이브러리가 필요합니다.
//
//// 코드 수정이 필요한 부분
//public extension SceneLocationView {
//
//
//    /// Adds routes to the scene and lets you specify the geometry prototype for the box.
//    /// Note: You can provide your own SCNBox prototype to base the direction nodes from.
//    ///
//    /// - Parameters:
//    ///   - routes: The CLLocation of directions
//    ///   - boxBuilder: A block that will customize how a box is built.
//    func addRoutes(routes: [NMGLatLng], location : CLLocation?, boxBuilder: BoxBuilder? = nil) {
//        // routes에 속성과 타입을 추가 후 다시 넘겨줌
////        addRoutes(polyline: routes.map { AttributedType(type: $0, attribute: "nil") }, boxBuilder: boxBuilder)
//        addRoutes(polyline: routes, location: location, boxBuilder: boxBuilder)
//        
//    }
//
//    /// Adds polylines to the scene and lets you specify the geometry prototype for the box.
//    /// Note: You can provide your own SCNBox prototype to base the direction nodes from.
//    ///
//    /// - Parameters:
//    ///   - polylines: The list of attributed CLLocation to rendered
//    ///   - Δaltitude: difference between box and current user altitude
//    ///   - boxBuilder: A block that will customize how a box is built.
//    func addRoutes(polyline: [NMGLatLng], location : CLLocation?, Δaltitude: CLLocationDistance = -2.0, boxBuilder: BoxBuilder? = nil) {
//        
//        
//        // 현재 고도를 가져옴
//        guard let altitude = location?.altitude else {
//            return assertionFailure("we don't have an elevation")
//        }
//        
//        let polyNodes = PolylineNode(polyline: polyline, altitude: altitude + Δaltitude, location : location)
//
//        polyNodes.locationNodes.forEach {
//            let locationNodeLocation = self.locationOfLocationNode($0)
//            sceneNode?.addChildNode($0)
//        }
//        
//        
//        
////        // 현재 고도를 가져옴
////        guard let altitude = location.altitude else {
////            return assertionFailure("we don't have an elevation")
////        }
//////        let polyNodes = polyline.map {
//////            PolylineNode(polyline: $0.type, altitude: altitude + Δaltitude, tag: $0.attribute, boxBuilder: boxBuilder)
//////        }
////        let polyNodes = PolylineNode(polyline: polyline, altitude: altitude + Δaltitude)
////
//////        polylineNodes.append(contentsOf: polyNodes)
////        polyNodes.locationNodes.map {
//////            $0.locationNodes.forEach {
////                let locationNodeLocation = self.locationOfLocationNode($0)
////                $0.updatePositionAndScale(setup: true, scenePosition: currentScenePosition, locationNodeLocation: locationNodeLocation, locationManager: sceneLocationManager, onCompletion: {})
////                sceneNode?.addChildNode($0)
//////            }
////        }
//    }
//
//    func removeRoutes(routes: [CLLocationCoordinate2D]) {
////        routes.forEach { route in
////            if let index = polylineNodes.firstIndex(where: { $0.polyline == route }) {
////                polylineNodes.remove(at: index)
////            }
////        }
//    }
//}
//
//
