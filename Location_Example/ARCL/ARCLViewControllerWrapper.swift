import SwiftUI
import CoreLocation

struct ARCLViewControllerWrapper: UIViewControllerRepresentable {
    
    var route : [CLLocationCoordinate2D]
    var coreLocation : CoreLocationEx
    
    
    func makeUIViewController(context: Context) -> ARCLViewController {
        return ARCLViewController(route: route, coreLocation : coreLocation)
    }
    
    func updateUIViewController(_ uiViewController: ARCLViewController, context: Context) {
        // Update code if needed
    }
}
