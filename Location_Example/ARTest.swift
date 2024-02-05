import SwiftUI
import ARKit
import SceneKit

struct ARTest: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        // ARView 구성 및 설정
        
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // 업데이트 로직 추가
    }
}
