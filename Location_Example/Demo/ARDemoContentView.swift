//
//  ARDemoContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import SwiftUI
import CoreLocation

struct ARDemoContentView: View {
    @ObservedObject var coreLocation = CoreLocationEx()
    @State var path = [CLLocationCoordinate2D(latitude: 0, longitude: 0)]
    @State var name = ""
    @State var isPresnted = false
    
    var body: some View {
        if coreLocation.location != nil {
            VStack{
                
                Text("현재 경로 : \(name)")
                
                HStack{
                    VStack{
                        Button(action: {
                            path = PathData().AIToHome
                            name = "AI -> 집"
                        }, label: {
                            Text("AI -> 집")
                        })
                        .padding()
                        
                        Button(action: {
                            path = PathData().homeToMin
                            name = "수집 -> 민집"
                        }, label: {
                            Text("수집 -> 민집")
                        })
                        .padding()
                        
                        Button(action: {
                            path = PathData().homeToAI
                            name = "집 -> AI"
                        }, label: {
                            Text("집 -> AI")
                        })
                        .padding()
                        
                        Button(action: {
                            path = PathData().libraryToGround
                            name = "중도 -> 운동장"
                        }, label: {
                            Text("중도 -> 운동장")
                        })
                        .padding()
                    }
                    .padding()
                    
                    Button(action: {
                        isPresnted = true
                    }, label: {
                        Text("AR 시작")
                    })
                    .fullScreenCover( isPresented: $isPresnted, content: {
                        ARDemoVCWrapper(coreLocation: coreLocation, route : path)
                    })
                }
            }
            
        }
    }
}
