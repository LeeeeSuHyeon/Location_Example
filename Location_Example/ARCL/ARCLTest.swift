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
    
    var start : CLLocationCoordinate2D
    var end : CLLocationCoordinate2D
    
    init(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        self.start = start
        self.end = end
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
      super.viewDidLoad()

      sceneLocationView.run()
        addRoute(from: start, to: end)
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
            self.sceneLocationView.addRoutes(routes: response.routes)
        }
    }
}
