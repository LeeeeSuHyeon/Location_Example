import SwiftUI
import ARKit
import RealityKit
import ARCL

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation: CoreLocationEx
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer(coreLocation: coreLocation)
                .edgesIgnoringSafeArea(.all)

                NaverMap(coreLocation : coreLocation)
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
    
    @ObservedObject var coreLocation: CoreLocationEx
    
    let route = PathData().route
    
    
//    @Binding var modelName: String
    
    // 2.
    func makeUIView(context: Context) -> ARSCNView {
        
        //ARCL
        LocationNode()
        
        // ARSCNView 인스턴스 생성
        let arView = ARSCNView()
        
        // ARScene 생성
        let scene = SCNScene()

        // ARScene을 ARSCNView에 할당
        arView.scene = scene
        
        drawRoute(on: scene, userLocation: coreLocation.location!, routeCoordinates: route)
        
        // 3.
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravityAndHeading // y축은 중력과 평행하게 정렬되고 z축과 x축은 나침반 방향으로 정렬
        
        config.planeDetection = [.horizontal, .vertical]
        
        // 텍스트를 띄울 위치 설정
        let location = CLLocationCoordinate2D(latitude: 37.454959, longitude: 127.128080)
        let anchor = ARGeoAnchor(name: "name", coordinate: location)
        arView.session.add(anchor: anchor)
        
        
        // 4.
        arView.session.run(config)
        
        // ARSession의 delegate를 설정
//        arView.session.delegate = context.coordinator
                
        return arView
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, ARSessionDelegate {
//        var parent: ARViewContainer
//        
//        init(_ parent: ARViewContainer) {
//            self.parent = parent
//            super.init()
//        }
//        
//        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//            guard let arView = session.delegate as? ARSCNView else { return }
//            let scene = arView.scene
//            
//            for geoAnchor in anchors.compactMap({ $0 as? ARGeoAnchor }) {
//                if let placemarkNode = Entity.placemarkNode(for: geoAnchor, in: arView) {
//                    scene.rootNode.addChildNode(placemarkNode)
//                }
//            }
//        }
//    }

    
    

    
    func updateUIView(_ arView: ARSCNView, context: Context) {
        
        // 이전에 추가된 경로 노드를 모두 제거합니다.
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        let scene = arView.scene
        drawRoute(on: scene, userLocation: coreLocation.location!, routeCoordinates: route)
    }
    
    func drawRoute(on scene: SCNScene, userLocation: CLLocation, routeCoordinates: [CLLocationCoordinate2D]) {
        // 경로를 표시할 노드 생성
        let routeNode = SCNNode()
        
        // 상대적 위치 배열 (현재 위치부터 시작)
        var relativeRoute : [SCNVector3] = [SCNVector3(x: 0, y: 0, z: 0)]
        
        // 사용자의 현재 위치를 SCNVector3로 변환 (x : 수평(경도), y : 수직(위도), z : 깊이(거리)) -> 일반적인 좌표쳬계와 다르게 해석됨

        // 경로 노드에 경로의 각 좌표를 추가
        for i in 0..<routeCoordinates.count - 1 {
            let coordinate = routeCoordinates[i]
            let nextCoordinate = routeCoordinates[i+1]
 
            // 사용자의 현재 위치와 경로 좌표 사이의 거리와 방향을 계산하여 오일러 각도로 변환
            let distance = userLocation.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            
            // 경로 좌표와 사용자 위치의 차이를 이용하여 방향을 계산 (atan2)
            let a = cos(nextCoordinate.longitude.toRadians() - nextCoordinate.longitude.toRadians()) * cos(coordinate.latitude.toRadians())
            
            let b = cos(coordinate.latitude.toRadians()) * sin(nextCoordinate.latitude.toRadians()) - sin(coordinate.latitude.toRadians()) * cos(nextCoordinate.latitude.toRadians()) * cos(nextCoordinate.longitude.toRadians() - coordinate.longitude.toRadians())
            
            let direction = atan2(a, b).toDegrees() // 라디안 -> 각도로 변환
    

            
            // 경로 노드의 위치 설정 (현재 카메라의 방향에 따라 부호를 다르게 해야 함)
            let routeNodePosition = SCNVector3(x: Float(distance * cos(direction)),
                                               y: 0,
                                               z: Float(-distance * sin(direction)))
            
            // 상대적 위치 배열에 추가
            relativeRoute.append(routeNodePosition)
        }
        print("drawRoute - relativeRoute : \(relativeRoute)")
        
        let ex : [SCNVector3] = [
            SCNVector3(x: 1, y: -1, z: 0),
            SCNVector3(x: 1, y: -1, z: -1),
            SCNVector3(x: 1, y: -1, z: -2)
        ]
        
        // 상대적인 좌표를 사용하여 경로 노드에 선을 추가
        let pathLine = SCNNode(geometry: SCNGeometry.line(from: relativeRoute, thickness: 0.8))
        routeNode.addChildNode(pathLine)
        
        
        // Scene에 경로 노드 추가
        scene.rootNode.addChildNode(routeNode)
    }
    
    // 건물 위 이미지 띄우기
    func LocationNode(){
        var sceneLocationView = SceneLocationView()
        
        // 공원
        let coordinate = CLLocationCoordinate2D(latitude: 37.454978, longitude: 127.128323)
        let address = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "gachon")!

        let annotationNode = LocationAnnotationNode(location: address, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
        // 뒷길
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.132851)
        let address1 = CLLocation(coordinate: coordinate, altitude: 300)
        let image1 = UIImage(named: "gachon")!

        let annotationNode1 = LocationAnnotationNode(location: address1, image: image1)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)
    }
}

extension SCNGeometry {
    static func line(from points: [SCNVector3], thickness: CGFloat) -> SCNGeometry {
        var vertices: [SCNVector3] = [] // 사각형의 꼭지점을 저장할 배열
        var normals : SCNVector3  // 법선 벡터
        var indices: [Int32] = [] // 정점 인덱스를 저장할 배열

        // 직사각형의 정점과 법선 벡터를 계산합니다.
        for i in 0..<points.count - 1 {
            let point = points[i]

            // 직선 세그먼트에 대한 수직 벡터를 계산합니다.
            let nextPoint = points[i+1]
            let diffVector = nextPoint - point // 방향벡터를 구함
            let perpendicularVector = SCNVector3(-diffVector.z, 0, diffVector.x).normalized()

            // 직사각형의 네 꼭지점을 계산합니다.
            let halfThickness = Float(thickness) / 2.0
            
            let topLeft = point + perpendicularVector * halfThickness
            let topRight = nextPoint + perpendicularVector * halfThickness
            let bottomLeft = point - perpendicularVector * halfThickness
            let bottomRight = nextPoint - perpendicularVector * halfThickness
   

            // 정점을 추가합니다.
            vertices.append(contentsOf: [topLeft, topRight, bottomRight, bottomLeft])
            
            // 법선을 추가합니다.
            normals = SCNVector3(0, -1, 0)

            // 정점 인덱스를 추가합니다.
            let baseIndex = Int32(i * 4)
            indices.append(contentsOf: [baseIndex, baseIndex + 1, baseIndex + 2, baseIndex, baseIndex + 2, baseIndex + 3])
        }

        // Geometry sources를 생성 -> vertex 속성인 새 지오메트리 소스 semantic 반환
        let vertexSource = SCNGeometrySource(vertices: vertices)
//        let normalSource = SCNGeometrySource(normals: normals)

        // Geometry element를 생성합니다.
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        /*
         Geometry를 생성
         - sources : 기하학의 정점과 그 속성에 설명하는 객체 배열
         - elements : 기하학의 정점을 연결하는 방법을 설명하는 객체 배열
         */
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
//        let geometry = SCNGeometry(sources: [vertexSource, normalSource], elements: [element])
        
        // Geometry에 적절한 머티리얼을 설정합니다.
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue // 원하는 색상을 설정합니다.

        geometry.materials = [material]
        
        return geometry
    }
}

// 벡터 덧셈 및 곱셈을 추가하는 확장
extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
//        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
        return SCNVector3(lhs.x + rhs.x, -2, lhs.z + rhs.z)
    }
    
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
//        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
        return SCNVector3(lhs.x - rhs.x, -2, lhs.z - rhs.z)
    }

    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
//        return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
        return SCNVector3(lhs.x * rhs, -2, lhs.z * rhs)
    }

    func normalized() -> SCNVector3 {
        let length = sqrt(x * x + y * y + z * z)
        return SCNVector3(x / length, y / length, z / length)
    }
}


extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
