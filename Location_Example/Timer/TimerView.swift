//
//  TimerView.swift
//  Location_Example
//
//  Created by 이수현 on 3/29/24.
//

import SwiftUI
import Alamofire

struct TimerView: View {
    
    @ObservedObject var cLocation = CLocation()
    
    @State var time : Int = 0

    let route = PathData().test

    var body: some View {
        if cLocation.location != nil{
            Text("노드 간 소요시간 확인 : \(time)")
            
            VStack{
                ForEach(0..<cLocation.timeList.count, id: \.self) { index in
                    Text("노드 \(index) - 노드\(index + 1): \(self.cLocation.timeList[index])초")
                        .onAppear(){
                            if index != 0 {
                                let param = TimerRequest(
                                    point1_x: Double(route[index].coordinate.latitude),
                                    point1_y: Double(route[index].coordinate.longitude),
                                    point2_x: Double(route[index+1].coordinate.latitude),
                                    point2_y: Double(route[index+1].coordinate.longitude),
                                    takeTime: Double(self.cLocation.timeList[index])
                                )
                                print("param \(param)")
                                postData(parameter : param)
                            }
                        }
                    
                    if(route.count - 1 == index){
                        Text("모든 노드 종료")
                        
                    }
                    
                }
                .padding()
            }
            .onReceive(cLocation.timer.$seconds) { second in
                self.time = second
            }
            
            Spacer()
            TimerMap(coreLocation: cLocation, route: route)
                .frame(height: 200)
                .edgesIgnoringSafeArea(.bottom)
                
        }
    }
    
    func postData(parameter : TimerRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "https://fd54-210-119-237-65.ngrok-free.app/saveTime") else {
            print("Invalid URL")
            return
        }
        
        // Alamofire를 사용하여 GET 요청 생성
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseString { response in
            // 에러 처리
            switch response.result {
            case .success(let value):
                // 성공적인 응답 처리
//                self.responseData = value
                print("성공")
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    TimerView()
}
