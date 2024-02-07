import SwiftUI
import ARKit
import SceneKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer()
                    .edgesIgnoringSafeArea(.all)
                
                UseMap(coreLocation: coreLocation)
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
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // ARView 구성 및 설정
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // 업데이트 로직 추가
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
