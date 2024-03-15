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

class ARDemoViewController : UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    
    var coreLocation: CoreLocationEx
    
    var route = PathData().route
    
    var source: CLLocationCoordinate2D?         // 출발지 주소
    var destination: CLLocationCoordinate2D?    // 목적지 주소
    var sourcePosition = SCNVector3()           // 출발지 상대적 위치
    var destinationPosition = SCNVector3()      // 목적지 상대적 위치
    var stepData = [Step]()                     // 출발지와 목적지 사이 중간 위치들
    
    var routeDetail : [LocationDetails] = [] // route의 디테일 설정

    init(coreLocation : CoreLocationEx){
        self.coreLocation = coreLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeARView()               // ARSCNView 생성
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
//        source = coreLocation.location?.coordinate // 시작 위치를 현재 위치로 설정
        source = route.first
        destination = route.last                   // 도착지를 목적지 경로의 마지막 위치로 설정
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
//        print("getIntermediateCoordinates - steps : \(steps)")
        arConfigurationInitialize()
        arViewSetup()
          
    } // end of getIntermediateCordinates()
    
    
    // AR 환경 초기화 메서드
    private func arConfigurationInitialize() {
        if  ARWorldTrackingConfiguration.isSupported { // 장치가 ARWorldTrackingConfiguration 지원하는지 확인
            let configuration = ARWorldTrackingConfiguration() // AR 환경 설정
            configuration.worldAlignment = .gravityAndHeading // 중력과 디바이스의 방향에 따라 정렬
            configuration.planeDetection = .horizontal // 평면 감지 활성화 -> AR 경로를 바닥에 표시하기 위해 설정
            sceneView.session.run(configuration) // AR 세션 시작
        } else {
//            alert(info: AlertConstants.arErrorMessage) // AR 에러 메시지
            print("arConfigurationInitialize - Error")
        }
    } // end of arConfigurationInitialize()
    
    
    // AR 뷰 설정
    private func arViewSetup() {
        placeSourceNode() // 출발지 노드 배치
        if let source = source, let destination = destination {
            // 경로 노드마다 띄울 텍스트 설정
            for intermediateLocation in stepData.enumerated() {
                var text = "\(TextNodeConstant.direction) : " + intermediateLocation.element.locationName
                text += "\n \(TextNodeConstant.distance) :" + intermediateLocation.element.distance
                text += " \n \(TextNodeConstant.duration) : " + intermediateLocation.element.duration
                placeDestinationNode(source: source, destination: intermediateLocation.element.endLocation, text: text)
            }
            placeDestinationNode(source: source, destination: destination, text: TextNodeConstant.destination)
        }
    } // end of arViewSetup()
    
    
    // 출발지 노드 AR 환경에 배치
    private func placeSourceNode() {
        let box = SCNBox(width: ArkitNodeDimension.sourceNodeWidth, height: ArkitNodeDimension.sourceNodeHeight, length: ArkitNodeDimension.sourceNodeLength, chamferRadius: ArkitNodeDimension.sourceChamferRadius)
        let sourceNode = SCNNode(geometry: box)
        sourceNode.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        
        // sourceNode의 상대적 위치를 경로의 첫번째 노드의 위치로 변경하고 sourcePosition 변경
//        sourceNode.position = SCNVector3(0, -(ArkitNodeDimension.nodeYPosition), 0)

        let firstNode = route[0]    // 경로의 첫번째 위치를 가져옴
        // 사용자 현재 위치부터 첫번째 노도 사이의 거리를 구함
        let distance = distanceBetweenCoordinate(source: coreLocation.location!.coordinate, destination: firstNode)
        let transformationMatrix = transformMatrix(source: coreLocation.location!.coordinate, destination: firstNode, distance: distance, text: "Start")
        sourceNode.transform = transformationMatrix     // 출발지 노드 위치 설정
        sourcePosition = sourceNode.position    // AR 경로 실린더의 시작 위치 설정
        
        // 출발지 텍스트 설정
        let directionTextNode = placeDirectionText(textPosition: sourcePosition, text: "Start")
        sourceNode.addChildNode(directionTextNode)
        
        sceneView.scene.rootNode.addChildNode(sourceNode)
        

    } // end of placeSourceNode()
    
    
    // 목적지 노드를 AR 환경에 배치
    private func placeDestinationNode(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, text: String) {
//        print("placeDestinationNode - Source : \(source), destination : \(destination)")
            let distance = distanceBetweenCoordinate(source: source, destination: destination)
            let destinationNode = SCNNode(geometry: intermediateNodeGeometry())
            let  transformationMatrix = transformMatrix(source: source, destination: destination, distance: distance, text: text)
            destinationNode.transform = transformationMatrix
            sceneView.scene.rootNode.addChildNode(destinationNode)
            placeCylinder(source: sourcePosition, destination: destinationNode.position)
            let directionTextNode = placeDirectionText(textPosition: destinationNode.position, text: text)
            destinationNode.addChildNode(directionTextNode)
            sourcePosition = destinationNode.position
    } // end of placeDestinationNode()
    
    
    // 두 좌표 간 거리 계산
    private func distanceBetweenCoordinate(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double {
            let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
            let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            let distance = sourceLocation.distance(from: destinationLocation)
            return distance
    } // end of distanceBetweenCoordinate()
    
    
    // 중간노드의 기하학 모양 정의, 노드 생성
    private func intermediateNodeGeometry() -> SCNBox {
        let intermediateBox = SCNBox(width: ArkitNodeDimension.destinationNodeWidth, height: ArkitNodeDimension.destinationNodeHeight, length: ArkitNodeDimension.destinationNodeLength, chamferRadius: ArkitNodeDimension.destinationChamferRadius)
        intermediateBox.firstMaterial?.diffuse.contents = UIColor.purple
        return intermediateBox
    } // end of itermediateNodeGeometry
    
    
    // 출발지와 목적지 사이의 변환 행렬 계산 후 노드 위치 방향 설정
    private func transformMatrix(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, distance: Double, text: String) -> SCNMatrix4 {
       let translation = SCNMatrix4MakeTranslation(0, 0, Float(-distance)) // 이동행렬
        
        // SCNMatrix4MakeRotation(회전량, x, y, z)
        // y축 기준으로 베어링 각도 만큼 회전 -> 베어링은 시계 방향 기준, rotation은 반시계 기준이라 음수를 붙임 
        let rotation = SCNMatrix4MakeRotation(-1 * (Float(source.calculateBearing(coordinate: destination))), 0, 1, 0)
        let transformationMatrix = SCNMatrix4Mult(translation, rotation)
        return (transformationMatrix)
    } // end of tansformMatrix
    
    
    // 출발지와 목적지 사이에 실린더 노드 배치하는 역할
    private func placeCylinder(source: SCNVector3, destination: SCNVector3) {
        let height = source.distance(receiver: destination)
        let cylinder = SCNCylinder(radius: ArkitNodeDimension.cylinderRadius, height: CGFloat(height))
//        let cylinder = SCNBox(width: 0.1, height: 0.1, length: CGFloat(height), chamferRadius: 0)
        
        cylinder.firstMaterial?.diffuse.contents = UIColor.blue
        cylinder.firstMaterial?.transparency = 0.5 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
        let node = SCNNode(geometry: cylinder)
//        node.position = SCNVector3((source.x + destination.x) / 2, Float(-(ArkitNodeDimension.nodeYPosition)), (source.z + destination.z) / 2))
        node.position = SCNVector3((source.x + destination.x) / 2, -2, (source.z + destination.z) / 2)
        let dirVector = SCNVector3Make(destination.x - source.x, destination.y - source.y, destination.z - source.z)
        let yAngle = atan(dirVector.x / dirVector.z)
        node.eulerAngles.x = .pi / 2
        node.eulerAngles.y = yAngle
        sceneView.scene.rootNode.addChildNode(node)
    } // end of placeCylinder 
    
    
    
    // 3D 텍스트 노드를 생성 후 방향 제어
    private func placeDirectionText(textPosition: SCNVector3, text: String) -> SCNNode {
        let textNode = SCNNode(geometry: getIntermediateNodeText(text: text))
        textNode.constraints = [SCNBillboardConstraint()]
        return textNode
    } // end of placeDirectionText
    
    
    // 3D 텍스트 객체 생성 함수
    private func getIntermediateNodeText(text: String) -> SCNText {
        let intermediateNodeText = SCNText(string: text, extrusionDepth: ArkitNodeDimension.textDepth)
        intermediateNodeText.font = UIFont(name: "Optima", size: ArkitNodeDimension.textSize)
        intermediateNodeText.firstMaterial?.diffuse.contents = UIColor.red
        intermediateNodeText.containerFrame = CGRect(x: 0.0, y: 0.0, width: 20, height: 5)
        intermediateNodeText.isWrapped = true
        return intermediateNodeText
    } // end of getIntermediateNodeText
}
