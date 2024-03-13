//
//  ARCLTest.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/09.
//

import Foundation
import UIKit
import ARCL
import CoreLocation
import MapKit
import NMapsMap

class ARCLViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    var route : [CLLocationCoordinate2D]
    var coreLocation : CoreLocationEx
    
    init(route : [CLLocationCoordinate2D], coreLocation : CoreLocationEx) {

        self.route = route
        self.coreLocation = coreLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
      super.viewDidLoad()
        
//        var pathPoints: [NMGLatLng] = []
//        for location in route {
//            let latLng = NMGLatLng(lat: location.latitude, lng: location.longitude)
//            pathPoints.append(latLng)
//        }

      sceneLocationView.run()
        for i in 0..<route.count - 1{
            addRoute(from: route[i], to: route[i+1])
        }
        
//        sceneLocationView.addRoutes(routes: pathPoints, location : coreLocation.location!)
        
        let polyline = MKPolyline(coordinates: route, count: route.count)
//        let polylines = [polyline]
//        addRoutes(polylines: polylines)

      view.addSubview(sceneLocationView)
        
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        

      sceneLocationView.frame = view.bounds
    }

}

extension ARCLViewController {
    
    /// add route by requesting walking directions from Apple Maps
    func addRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("addRoute : \(source), \(destination)")
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, _) in
            guard let response = response else { return }
            print("directinos.calculate.count : \(response.routes.count)") // 1
            print("response.routes[0].polyline : \(response.routes[0].polyline)")
            // response.routes[0].polyline : <MKRoutePolyline: 0x280fe2920>
            self.sceneLocationView.addRoutes(routes: response.routes)
        }
    }
}


extension ARCLViewController {
    

    func addRoutes(polylines : [MKPolyline]){
        print("polylines : \(polylines)") // polylines : [<MKPolyline: 0x282a4e290>]
        let poly = polylines.map{
            AttributedType(type: $0 , attribute: "path")
        }
        print("poly : \(poly)")
        
        // MKPolyline을 이용하여 나타낸 polyline type : MKPolyline 
        // polylines : [ARCL.AttributedType<__C.MKPolyline>(type: <MKPolyline: 0x281381490>, attribute: "name")]
        
        // Directions 함수를 이용해 구한 경로 사용시 polyline Type : MKRoutePolyline
//        [ARCL.AttributedType<__C.MKPolyline>(type: <MKRoutePolyline: 0x28352e530>, attribute: "")
        
        self.sceneLocationView.addRoutes(polylines: poly)
    }
    
    func addRoutes(polylines: [AttributedType<MKPolyline>],
                   Δaltitude: CLLocationDistance = -2.0,
                   boxBuilder: BoxBuilder? = nil) {
        print("ex polylines : \(polylines)")
    }
    

}


//extension SceneLocationView {
//    func addRoutes(polylines : [MKPolyline]){
//        let poly = polylines.map{
//            AttributedType(type: $0, attribute: "name")
//        }
//        print("polylines : \(poly)")
//        addRoutes(polylines: poly)
//    }
//}


