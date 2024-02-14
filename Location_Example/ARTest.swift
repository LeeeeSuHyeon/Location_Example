import SwiftUI
import ARKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State private var modelName : String =  "Usdz/rightArrow"
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer(modelName: $modelName)
                    .edgesIgnoringSafeArea(.all)
                
//                UseMap(coreLocation: coreLocation)
            }
           
            
            Button(){
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .background(.ultraThinMaterial) // .ultraThinMaterial 속성을 이용하여 버튼 뒤를 가리지 않도록 설정
                    .clipShape(Circle())
            }
            .padding(24)
        }
        
    }
}


struct ARViewContainer: UIViewRepresentable {
    @Binding var modelName: String
        // 2.
        func makeUIView(context: Context) -> ARView {
            // 2.a
            let arView = ARView(frame: .zero)
            
            // 3.
            let config = ARWorldTrackingConfiguration()
                    // 3.a
            config.planeDetection = [.horizontal,.vertical]
                    // 3.b
            config.environmentTexturing = .automatic
            
            // 4.
            arView.session.run(config)
            return arView
        }

    func updateUIView(_ uiView: ARView, context: Context) {
        // 1.
        let anchorEntity = AnchorEntity(plane: .any)
        
        // 2.
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") else{
            print("Error - Failed to find model file in bundle.")
            return
        }
        guard let modelEntity = try? Entity.loadModel(contentsOf: modelURL) else {
            print("Error - Failed to load model named \(modelName)")
            return
        }
        
//        modelEntity.scale = [0.1, 0.1, 0.1]        // 엔티티 크기 조절
//        modelEntity.transform.translation = SIMD3<Float>(1, 1, 1) // 엔티티 위치 조절
        
        
        // 모델 재질 설정
//        let material = SimpleMaterial(color: .blue, isMetallic: false)
//        modelEntity.model?.materials = [material]

        
        // 3.
        anchorEntity.addChild(modelEntity)
        
        // 4.
        uiView.scene.addAnchor(anchorEntity)
    }
}


//struct ARViewContainer: UIViewRepresentable {
//    
//    // AR 화면을 표시할 때 처음에 호출되는 메서드
//    func makeUIView(context: Context) -> ARSCNView {
//        let arView = ARSCNView(frame: .zero)
//        
//        // ARView 구성 및 설정
//        
//        return arView
//    }
//
//    // 화면이 업데이트 될 때 호출되는 메서드 
//    func updateUIView(_ uiView: ARSCNView, context: Context) {
//        // 업데이트 로직 추가
//    }
//}
