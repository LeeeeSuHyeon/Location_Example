//
//  ARViewController.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import UIKit
import CoreLocation
import SceneKit
import AVFoundation
import ARKit
import SceneKit.ModelIO // usdz 파일을 가져오기 위한 프레임워크

class ARDemoViewController : UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    
    var coreLocation: CoreLocationEx
    
    var route : [CLLocationCoordinate2D]        // 경로 노드의 위치 배열
    
    var currentLocation: CLLocationCoordinate2D? // 현재 위치
//    var destination: CLLocationCoordinate2D?     // 목적지 주소
    var sourcePosition = SCNVector3()            // 출발지 상대적 위치
    var previousPosition = SCNVector3()       // 이전 노드의 포지션 -> 중간 노드를 배치할 때 사용
    var stepData = [Step]()                      // 출발지와 목적지 사이 중간 위치들
    
    var routeDetail : [LocationDetails] = [] // route의 디테일 설정
    
    // 화살표 노드 배열
    var middleNodeLocation = [SCNNode]()
    
    // 화살표 노드를 생성한 루트 인덱스
    var createdRouteIndex = [Int]()
    var nextRoute = 0

    init(coreLocation : CoreLocationEx, route : [CLLocationCoordinate2D]){
        self.coreLocation = coreLocation
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeARView()               // ARSCNView 생성
        createButton()             // 버튼 생성
        prepare(route: route)      // Detail 설정
        checkCameraAccess()        // 카메라 엑세스 권한 환인
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // ARSCNView 생성
    private func makeARView(){
        // ARSCNView 생성
       sceneView = ARSCNView(frame: view.bounds)
        
        // ARSCNView를 UIViewController에 추가
        view.addSubview(sceneView)
        
        // ARSCNView의 delegate 설정
        sceneView.delegate = self
        
    } // end of makeARView()
    
    // Detail 설정
    func prepare(route : [CLLocationCoordinate2D]){
        var detail : LocationDetails
        
        for i in 0..<route.count {
            detail = LocationDetails(lat: route[i].latitude, lng: route[i].longitude, name: String(i))
            routeDetail.append(detail)
        }
        currentLocation = coreLocation.location?.coordinate // 시작 위치를 현재 위치로 설정
//        destination = route.last                   // 도착지를 목적지 경로의 마지막 위치로 설정
    }
    
    // 카메라 엑세스 확인 메서드
    private func checkCameraAccess() {
        
        // 현재 앱이 카메라 엑세스 허용했으면 getIntermediateCordinates() 호출하여 중간 좌표를 가져옴
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            getIntermediateCoordinates()
            
        // 카메라 엑세스를 허용하지 않았으면 사용자에게 권한 요청
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                // 권한 허용
                if granted {
                    self.getIntermediateCoordinates()
                // 권한 거부
                } else {
//                        self.alert(info: AlertConstants.cameraAccessErrorMessage)
                    print("checkCameraAccess : 권한 거부")
                }
            })
        }
    } // end of checkCameraAccess()
    
    
    // 중간 노드들의 정보를 계산하고 가져오는 메서드
    private func getIntermediateCoordinates() {
        // 중간 노드(Steps)를 받아옴 -> CLLocationCoordinate2D 형식으로 보내서 [Step] 형식으로 변환해야 함
        let steps = GetIntermediateCoordinate.getCoordinates(route : routeDetail)
        self.stepData = steps
        arConfigurationInitialize()
//        arViewSetup()
          
    } // end of getIntermediateCordinates()
    
    
    // AR 환경 초기화 메서드
    private func arConfigurationInitialize() {
        if  ARWorldTrackingConfiguration.isSupported { // 장치가 ARWorldTrackingConfiguration 지원하는지 확인
            let configuration = ARWorldTrackingConfiguration() // AR 환경 설정
            configuration.worldAlignment = .gravityAndHeading // 중력과 디바이스의 방향에 따라 정렬
            configuration.planeDetection = .horizontal // 평면 감지 활성화 -> AR 경로를 바닥에 표시하기 위해 설정
            sceneView.session.run(configuration) // AR 세션 시작
            
            placeSourceNode() // 출발지 노드 배치
            createArrowNode(currentLocation: currentLocation!, firstLocation: route[0], secondLocation: route[1])
        } else {
//            alert(info: AlertConstants.arErrorMessage) // AR 에러 메시지
            print("arConfigurationInitialize - Error")
        }
    } // end of arConfigurationInitialize()
    
    // CoreLocation() Class 에서 현재 위치 변경 시 호출될 메서드
    func changeLocation(location : CLLocationCoordinate2D){
        // 일정 거리 이내에 있는 루트 노드만 생성 (20m)
        let boundary = 20
        
        // nextRoute 번째 노드까지의 거리를 구하여 boundary 이내이고 cre
        
        
        if createdRouteIndex.isEmpty {
            placeSourceNode()
            createdRouteIndex.append(0)
            nextRoute += 1
        }
        else if createdRouteIndex.count == route.count - 1 {   // 마지막 경로의 전 노드를 생성했다면
            placeDestinationNode()
            createdRouteIndex.append(route.count - 1)
        }

        else if createdRouteIndex.count < route.count && !createdRouteIndex.contains(nextRoute) {
            
        }
    }
    
    
    // AR 뷰 설정
//    private func arViewSetup() {
//        placeSourceNode() // 출발지 노드 배치
//
//        if let currentLocation = currentLocation {
//            // 경로 노드마다 띄울 텍스트 설정
//            for i in 0..<stepData.count - 1 {
//                let text = "Step : " + stepData[i].locationName
//                placeMiddleNode(currentLocation: currentLocation, start : stepData[i].startLocation, end: stepData[i].endLocation, next : stepData[i].nextLocation, text: text)
//            }
//        }
//        placeDestinationNode()  // 목적지 노드 배치
//    } // end of arViewSetup()
    
    
    // 출발지 노드 AR 환경에 배치
    private func placeSourceNode() {
        
        let sourceNode = makeUsdzNode(fileName: "Pin", scale: 0.1, middle: false)
//        let file = "Pin"
//        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "usdz") else {
//                fatalError()
//        }
//        let scene = try? SCNScene(url: fileUrl, options: nil)
//        let sourceNode = SCNNode()
//
//        
//        if let scene = scene {
//            for child in scene.rootNode.childNodes {
//                child.scale = SCNVector3(0.1, 0.1, 0.1)
//                
//                // usdz 파일 이미지를 y축 방향으로 90도 회전 (항상 카메라를 봐라 보도록 설정)
//                child.eulerAngles.y = .pi / 2
//                sourceNode.addChildNode(child)
//            }
//        }
        
        let source = self.currentLocation!   // 현재 위치
        let firstNode = route[0]    // 경로의 첫번째 위치를 가져옴
        
        // 사용자 현재 위치부터 첫번째 노도 사이의 거리를 구함
        let distance = distanceBetweenCoordinate(source: source, destination: firstNode)
        let transformMatrix = transformMatrix(source: source, destination: firstNode, distance: distance)
        sourceNode.transform = transformMatrix     // 출발지 노드 위치 설정
        
        sourcePosition = sourceNode.position    // AR 경로 실린더의 시작 위치 설정
        
        // 출발지 텍스트 설정
        let directionTextNode = placeDirectionText(textPosition: sourcePosition, text: "Start", isMiddle: false)
        sourceNode.addChildNode(directionTextNode)
        
        sceneView.scene.rootNode.addChildNode(sourceNode)

    } // end of placeSourceNode()
    
    
    // 마지막 도착지 노드 AR 환경에 배치
    private func placeDestinationNode(){

        let imageName = "pin"
        // 1. SCNPlane을 생성하고 "name" 이미지를 텍스쳐로 설정합니다.
       let plane = SCNPlane(width: 10, height: 10) // 크기 설정
       plane.firstMaterial?.diffuse.contents = UIImage(named: imageName)

       // 2. SCNNode를 생성하고 위에서 만든 SCNPlane을 geometry로 설정합니다.
       let destinationNode = SCNNode(geometry: plane)
        
        let source = coreLocation.location!.coordinate  // 현재 위치
        let lastNode = route.last! // 목적지 위치

        // 현재위치와 목적지 위치까지의 상대좌표를 구함
        let distance = distanceBetweenCoordinate(source: source, destination: lastNode)
        let transformationMatrix = transformMatrix(source: source, destination: lastNode, distance: distance)
        
        
        destinationNode.transform = transformationMatrix
        sceneView.scene.rootNode.addChildNode(destinationNode)
        
        // 경로의 마지막 전 노드와 마지막 노드까지의 실린더 설정
//        let cylinder = placeCylinder(source: sourcePosition, destination: destinationNode.position)
//        sceneView.scene.rootNode.addChildNode(cylinder)
        
        let directionTextNode = placeDirectionText(textPosition: destinationNode.position, text: "Destination", isMiddle: false)
        
        // 목적지 텍스트 설정
        destinationNode.addChildNode(directionTextNode)
        
        sceneView.scene.rootNode.addChildNode(destinationNode)
        

    } // end of placeSourceNode()
    
    
    // 목적지 노드를 AR 환경에 배치
//    private func placeMiddleNode(currentLocation: CLLocationCoordinate2D, start :CLLocationCoordinate2D, end: CLLocationCoordinate2D, next: CLLocationCoordinate2D, text: String) {
//        print("placeMiddleNode - currentLocation : \(currentLocation), start : \(start) end : \(end)")
//        let distance = distanceBetweenCoordinate(source: currentLocation, destination: end)
//        let middleNode = intermediateNodeGeometry()
//        let transformationMatrix = transformMatrix(source: currentLocation, destination: end, distance: distance)
//        middleNode.transform = transformationMatrix
//
//        let cylinder = placeCylinder(source: sourcePosition, destination: middleNode.position)
//        
//        // 도착지와 다음 노드 사이의 거리를 구함
//        let nextDistance = distanceBetweenCoordinate(source: end, destination: next)
//        var newText = "\(text)"
//        newText += "\n \(String(format: "%.1f", nextDistance))M"
//        
//        // 다음 노드의 상대 좌표를 구함
//        let nextTransformationMatrix = transformMatrix(source: currentLocation, destination: next, distance: nextDistance)
//        let nextNode = SCNNode()
//        nextNode.transform = nextTransformationMatrix
//        
//        // 화살표 노드 방향 설정 
////        middleNode.eulerAngles.y = rotateArrowImage(cylinder.eulerAngles.y, middleNode, nextNode.position)
//        
//        // 텍스트
//        let directionTextNode = placeDirectionText(textPosition: middleNode.position, text: newText, isMiddle: true)
//        
//        middleNode.addChildNode(directionTextNode)
//
//        // ARScene에 노드 추가
//        sceneView.scene.rootNode.addChildNode(middleNode)
//        sceneView.scene.rootNode.addChildNode(cylinder)
//        
//        sourcePosition = middleNode.position
//        
//        
//    } // end of placeDestinationNode()
    
    
    // 두 좌표 간 거리 계산
    private func distanceBetweenCoordinate(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double {
            let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
            let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            let distance = sourceLocation.distance(from: destinationLocation)
            return distance
    } // end of distanceBetweenCoordinate()
    
    
    // 중간노드의 기하학 모양 정의, 노드 생성
    private func intermediateNodeGeometry() -> SCNNode {
//        let intermediateBox = SCNBox(width: ArkitNodeDimension.destinationNodeWidth, height: ArkitNodeDimension.destinationNodeHeight, length: ArkitNodeDimension.destinationNodeLength, chamferRadius: ArkitNodeDimension.destinationChamferRadius)
        
        let file = "right"
        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "usdz") else {
                fatalError()
        }
        let scene = try? SCNScene(url: fileUrl, options: nil)
        let sourceNode = SCNNode()

        
        if let scene = scene {
            for child in scene.rootNode.childNodes {
                child.scale = SCNVector3(0.2, 0.2, 0.2)
                sourceNode.addChildNode(child)
            }
        }
//        intermediateBox.firstMaterial?.diffuse.contents = UIColor.purple
        return sourceNode
    } // end of itermediateNodeGeometry
    
    
    // 출발지와 목적지 사이의 변환 행렬 계산 후 노드 위치 방향 설정
    private func transformMatrix(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, distance: Double) -> SCNMatrix4 {
       let translation = SCNMatrix4MakeTranslation(0, 0, Float(-distance)) // 이동행렬
        
        // SCNMatrix4MakeRotation(회전량, x, y, z)
        // y축 기준으로 베어링 각도 만큼 회전 -> 베어링은 시계 방향 기준, rotation은 반시계 기준이라 음수를 붙임 , 회전각에 시작위치-첫번째 노드의 회전을 더함
        let rotation = SCNMatrix4MakeRotation(-1 * (Float(source.calculateBearing(coordinate: destination))), 0, 1, 0)
        
        let transformationMatrix = SCNMatrix4Mult(translation, rotation)
        return (transformationMatrix)
    } // end of tansformMatrix
    
    
    // 출발지와 목적지 사이에 실린더 노드 배치하는 역할
//    private func placeCylinder(source: SCNVector3, destination: SCNVector3) -> SCNNode{
//        let height = source.distance(receiver: destination)
//        let cylinder = SCNCylinder(radius: ArkitNodeDimension.cylinderRadius, height: CGFloat(height))
////        let cylinder = SCNBox(width: 0.1, height: 0.1, length: CGFloat(height), chamferRadius: 0)
//        
//        cylinder.firstMaterial?.diffuse.contents = UIColor.blue
//        cylinder.firstMaterial?.transparency = 0.5 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
//        let node = SCNNode(geometry: cylinder)
////        node.position = SCNVector3((source.x + destination.x) / 2, Float(-(ArkitNodeDimension.nodsition)), (source.z + destination.z) / 2))
//        
//        // 실린더 노드의 위치를 출발지와 목적지 중간으로 배치
//        node.position = SCNVector3((source.x + destination.x) / 2, -2, (source.z + destination.z) / 2)
//        
//        // 출발지와 목적지 사이의 회전각을 구함
//        let dirVector = SCNVector3Make(destination.x - source.x, destination.y - source.y, destination.z - source.z)
//        let yAngle = atan(dirVector.x / dirVector.z)
//        node.eulerAngles.x = .pi / 2
//        node.eulerAngles.y = yAngle
//
//        return node
//    } // end of placeCylinder
    
    
    // 회전 방향 판별 및 이미지 회전
//    func rotateArrowImage(_ previousAngle : Float, _ node: SCNNode, _ next : SCNVector3) -> Float {
//        
//        // 출발지와 목적지 사이의 회전각을 구함
//        let dirVector = SCNVector3Make(next.x - node.position.x, next.y - node.position.y, next.z - node.position.z)
//        let yAngle = atan(dirVector.x / dirVector.z)
//        
//        // arrow.usdz 이미지가 원래 오른방향을 가리키고 있으므로 -를 붙여줌
//        print("node.eulerAngles.y : \(node.eulerAngles.y), yAngle : \(yAngle), previousAngle : \(previousAngle)")
//        node.eulerAngles.y = yAngle > 0 ? node.eulerAngles.y : 180
////        node.eulerAngles.y += yAngle + previousAngle
////        node.eulerAngles.y = .pi / 2
//        return node.eulerAngles.y
//    }

    
    
    
    // 3D 텍스트 노드를 생성 후 방향 제어
    private func placeDirectionText(textPosition: SCNVector3, text: String, isMiddle : Bool) -> SCNNode {
        let textNode = SCNNode(geometry: getIntermediateNodeText(text: text, isMiddle : isMiddle))
        textNode.constraints = [SCNBillboardConstraint()]
        return textNode
    } // end of placeDirectionText
    
    
    // 3D 텍스트 객체 생성 함수
    private func getIntermediateNodeText(text: String, isMiddle : Bool) -> SCNText {
        let intermediateNodeText = SCNText(string: text, extrusionDepth: ArkitNodeDimension.textDepth)
        intermediateNodeText.font = UIFont(name: "Helvetica", size: ArkitNodeDimension.textSize)
        intermediateNodeText.firstMaterial?.diffuse.contents = UIColor.red
        let width = 10
        let height = isMiddle ? 3 : 7
        intermediateNodeText.containerFrame = CGRect(x: -(width / 4), y: 0, width: width, height: height)
        intermediateNodeText.isWrapped = true
        return intermediateNodeText
    } // end of getIntermediateNodeText
    
    
    // 중간 화살표 노드 생성 함수
    func createArrowNode(currentLocation : CLLocationCoordinate2D, firstLocation : CLLocationCoordinate2D, secondLocation : CLLocationCoordinate2D){
        
        // 현재 위치부터 시작 노드까지의 거리와 상대 좌표
        let firstDistance = distanceBetweenCoordinate(source: currentLocation, destination: firstLocation)
        let firstTransformation = transformMatrix(source: currentLocation, destination: firstLocation, distance: firstDistance)
        let firstNode = makeUsdzNode(fileName: "threeArrows", scale: 0.05, middle : false)
        firstNode.transform = firstTransformation
        let firstPosition = firstNode.position
        
        // 현재 위치부터 다음 노드까지의 거리와 상대 좌표
        let secondDistance = distanceBetweenCoordinate(source: currentLocation, destination: secondLocation)
        let secondTransformation = transformMatrix(source: currentLocation, destination: secondLocation, distance: secondDistance)
        let secondNode = makeUsdzNode(fileName: "threeArrows", scale: 0.05, middle: false)
        secondNode.transform = secondTransformation
        let secondPosition = secondNode.position
        
        // 두 노드 사이의 방향 벡터 계산
        let dirVector = SCNVector3Make(secondPosition.x - firstPosition.x,
                                       secondPosition.y - firstPosition.y,
                                       secondPosition.z - firstPosition.z)
        
        // 공통 회전각 - 각 화살표 노드의 오일러 회전 y 값
        let yAngle = atan(dirVector.x / dirVector.z)

        // 두 노드 사이의 거리 계산
        let distanceBetweenNodes = firstPosition.distance(receiver: secondPosition)

        // 각 화살표 노드의 간격 계산 (5m 당 1개)
        let interval = distanceBetweenNodes / Float(5)
        let stepSize = Float(5) / distanceBetweenNodes

        // 첫 번째 화살표 노드의 위치 계산
        var currentNodePosition = firstPosition

        // 첫 번째 화살표 노드를 제외한 나머지 화살표 노드 생성
        for i in 1...Int(interval) {
            // 다음 화살표 노드의 위치 계산
            let fraction = stepSize * Float(i)
            let intermediatePosition = SCNVector3(
                x: firstPosition.x + fraction * dirVector.x,
                y: firstPosition.y + fraction * dirVector.y,
                z: firstPosition.z + fraction * dirVector.z
            )

            // 화살표 노드 생성 및 추가
            let node = makeUsdzNode(fileName: "middleArrow", scale: 0.01, middle: true)
            node.position = intermediatePosition
            node.childNodes.map { $0.eulerAngles.y = yAngle }
//            middleNodeLocation.append(node)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    // usdz 파일 노드 생성
    private func makeUsdzNode(fileName : String, scale : Float, middle : Bool) -> SCNNode {
        let file = fileName
        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "usdz") else {
            fatalError()
        }
        let scene = try? SCNScene(url: fileUrl, options: nil)
        let node = SCNNode()
        
        if let scene = scene {
            for child in scene.rootNode.childNodes {
                child.scale = SCNVector3(scale, scale, scale)
                if middle {
                    child.eulerAngles.x = .pi / 2

                }
                else {
                    child.eulerAngles.y = .pi / 2
                }
                
                node.addChildNode(child)
            }
        }
        return node
    }
}



// AR Off 버튼 추가
extension ARDemoViewController {
    // AR 화면을 닫는 메서드
     @objc func dismissARView() {
         dismiss(animated: true, completion: nil)
     }

     func createButton() {
         
         // AR 화면을 닫는 버튼 추가
         let closeButton = UIButton(type: .system)
         closeButton.backgroundColor = .white
         closeButton.setTitle("AR 종료", for: .normal)
         closeButton.addTarget(self, action: #selector(dismissARView), for: .touchUpInside)
         view.addSubview(closeButton)
         
         // 버튼 레이아웃 설정
         closeButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), // 오른쪽 여백 16
             closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16), // 상단 여백 16
             closeButton.widthAnchor.constraint(equalToConstant: 80),
             closeButton.heightAnchor.constraint(equalToConstant: 40)
         ])

     }
}
