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

class ARCLViewController: UIViewController {
  var sceneLocationView = SceneLocationView()
    let path = PathData().route
    
    override func viewDidLoad() {
      super.viewDidLoad()

      sceneLocationView.run()

        if let route =  createSingleRoute(from: path){
            sceneLocationView.addRoutes(routes: [route])
        }
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
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, _) in
            guard let response = response else { return }
            self.sceneLocationView.addRoutes(routes: response.routes)
        }
    }
    
    func createSingleRoute(from coordinates: [CLLocationCoordinate2D]) -> MKRoute? {
        guard coordinates.count >= 2 else {
            print("Coordinates should have at least two points.")
            return nil
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: coordinates.first!)
        let destinationPlacemark = MKPlacemark(coordinate: coordinates.last!)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destinationItem
        request.transportType = .walking
        
        var route: MKRoute?
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response, let calculatedRoute = response.routes.first else {
                if let error = error {
                    print("Error calculating route: \(error.localizedDescription)")
                } else {
                    print("Unknown error calculating route.")
                }
                return
            }
            // Assign the calculated route
            route = calculatedRoute
        }
        
        return route
    }
}

