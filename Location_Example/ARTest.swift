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
    
    // AR 화면을 표시할 때 처음에 호출되는 메서드
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        // ARView 구성 및 설정
        
        return arView
    }

    // 화면이 업데이트 될 때 호출되는 메서드 
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // 업데이트 로직 추가
    }
}
