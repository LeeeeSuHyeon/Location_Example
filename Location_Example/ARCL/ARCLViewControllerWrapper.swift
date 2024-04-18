import SwiftUI
import CoreLocation

struct ARCLViewControllerWrapper: UIViewControllerRepresentable {
    
    var path : [Node]
    var coreLocation : CoreLocationEx
    
    
    func makeUIViewController(context: Context) -> ARCLViewController {
        return ARCLViewController(path: path, coreLocation : coreLocation)
    }
    
    func updateUIViewController(_ uiViewController: ARCLViewController, context: Context) {
        // Update code if needed
    }
}
