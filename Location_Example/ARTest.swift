import SwiftUI
import ARKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State private var modelName : String =  "CC0_-_Arrow_5"
    
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer(
                    modelName: $modelName
                )
                .edgesIgnoringSafeArea(.all)

                NaverMap()
//                 UseMap(coreLocation: coreLocation)
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
    func makeUIView(context: Context) -> ARSCNView {
        
        // ARSCNView 인스턴스 생성
        let arView = ARSCNView()
        
        // ARScene 생성
        let scene = SCNScene()
        
        // Scene에 3D 객체 추가
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3(0, 0, -0.5)
        scene.rootNode.addChildNode(boxNode)

        // ARScene을 ARSCNView에 할당
       arView.scene = scene
        
        // 3.
        let config = ARWorldTrackingConfiguration()
        // 3.a
//        config.planeDetection = [.horizontal, .vertical]
//        // 3.b
//        config.environmentTexturing = .automatic
        
        // 4.
        arView.session.run(config)
                
        return arView
    }


    
    func updateUIView(_ arView: ARSCNView, context: Context) {
//            // 5.a
//            let anchorEntity = AnchorEntity(plane: .any)
//
//            // 6.
//        guard let modelEntity = try? Entity.loadModel(named: modelName) else {
//            print("Failed to load model entity")
//            return
//        }
//
//            // 7.
//            anchorEntity.addChild(modelEntity)
//
//            // 8.
//            uiView.scene.addAnchor(anchorEntity)
        
        }
        
    }

