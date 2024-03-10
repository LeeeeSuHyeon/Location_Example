import SwiftUI
import MapKit

struct ARCLMapView: UIViewRepresentable {
//    var sourceCoordinate: CLLocationCoordinate2D
//    var destinationCoordinate: CLLocationCoordinate2D
    
    var route : [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        for i in 0..<route.count - 1 {
            // Add annotations for source and destination
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.coordinate = route[i]
            sourceAnnotation.title = "route[\(i)]"
            mapView.addAnnotation(sourceAnnotation)
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = route[i+1]
            destinationAnnotation.title = "route[\(i)]"
            mapView.addAnnotation(destinationAnnotation)
            
            // Calculate route between source and destination
            let sourcePlacemark = MKPlacemark(coordinate: route[i], addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: route[i+1], addressDictionary: nil)
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .walking
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        print("Error calculating route: \(error.localizedDescription)")
                    }
                    return
                }
                let route = response.routes[0]
                mapView.addOverlay(route.polyline)
            }
        }
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update the view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
    }
}
