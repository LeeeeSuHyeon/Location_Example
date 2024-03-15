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
    @State var route = [CLLocationCoordinate2D(latitude: 0, longitude: 0)]
    @State var name = ""
    @State var isPresnted = false
    
    var body: some View {
        if coreLocation.location != nil {
            VStack{
                
                Text("현재 경로 : \(name)")
                
                HStack{
                    VStack{
                        Button(action: {
                            route = PathData().AIToHome
                            name = "AI -> 집"
                        }, label: {
                            Text("AI -> 집")
                        })
                        .buttonStyle(BorderedButtonStyle())
                        .padding()
                        
                        Button(action: {
                            route = PathData().homeToMin
                            name = "수집 -> 민집"
                        }, label: {
                            Text("수집 -> 민집")
                        })
                        .buttonStyle(BorderedButtonStyle())
                        .padding()
                        
                        Button(action: {
                            route = PathData().homeToAI
                            name = "집 -> AI"
                        }, label: {
                            Text("집 -> AI")
                        })
                        .buttonStyle(BorderedButtonStyle())
                        .padding()
                        
                        Button(action: {
                            route = PathData().libraryToGround
                            name = "중도 -> 운동장"
                        }, label: {
                            Text("중도 -> 운동장")
                        })
                        .buttonStyle(BorderedButtonStyle())
                        .padding()
                    }
                    .padding()
                    
                    Button(action: {
                        isPresnted = true
                    }, label: {
                        Text("AR 시작")
                    })
                    .fullScreenCover( isPresented: $isPresnted, content: {
                        ARDemoStartView(coreLocation: coreLocation, route : route)
                    })
                    .buttonStyle(BorderedButtonStyle())
                    .padding()
                }
            }
            
        }
    }
}
