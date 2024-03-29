//
//  TimerView.swift
//  Location_Example
//
//  Created by 이수현 on 3/29/24.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var cLocation = CLocation()
    
    @State var time : Int = 0

    let route = PathData().CLroute

    var body: some View {
        if cLocation.location != nil{
            Text("노드 간 소요시간 확인 : \(time)")
            
            VStack{
                ForEach(0..<cLocation.timeList.count, id: \.self) { index in
                    Text("노드 \(index+1): \(self.cLocation.timeList[index])")
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
}

#Preview {
    TimerView()
}
