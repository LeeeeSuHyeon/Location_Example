import SwiftUI

struct ARCLViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARCLViewController {
        return ARCLViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARCLViewController, context: Context) {
        // Update code if needed
    }
}
