import SwiftUI
import CoreLocation

struct ARCLViewControllerWrapper: UIViewControllerRepresentable {
    
    var start : CLLocationCoordinate2D
    var end : CLLocationCoordinate2D
    
    
    func makeUIViewController(context: Context) -> ARCLViewController {
        return ARCLViewController(start: start, end: end)
    }
    
    func updateUIViewController(_ uiViewController: ARCLViewController, context: Context) {
        // Update code if needed
    }
}
