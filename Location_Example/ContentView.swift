//
//  ContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

// 위치 환경 구축
import SwiftUI


struct ContentView: View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State var myMap : NaverMap?
    @State var isPresented: Bool = false
    @State var start = ""
    @State var end = ""
    
    var body: some View {
        if coreLocation.location != nil {
            VStack{
                HStack{
                    VStack{
                        TextField("출발 위치를 입력하시오.", text: $start)
                            .padding()
                            .border(.black)
                        TextField("도착 위치를 입력하시오.", text: $end) // 서버에서 ai == ai공하관 == AI 작업 필요
                            .padding()
                            .border(.black)
                    }
                    .padding(.leading, 20)
                    
                    
                    VStack{
                        // 위치 검색 버튼
                        Button {
                            //                        Search(myMap, end)
                        } label: {
                            Text("Search")
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .frame(width: 100, height: 30)
                        
                        // ar 이동 버튼
                        Button {
                            isPresented.toggle()
                        } label: {
                            Label("AR", systemImage: "arkit")
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .frame(width: 100, height: 30)
                        
                        // 3.
                        .fullScreenCover(isPresented: $isPresented, content: {
                            ARTest(isPresented: $isPresented, coreLocation: coreLocation)
                        })
                    }
                    .onAppear() {
                        // ContentView가 로드되고 나면 coreLocation을 참조하여 NaverMap을 생성
                        myMap = NaverMap(coreLocation: coreLocation, route: PathData().route)
                    }
                }
                
                NaMapView(coreLocation: coreLocation, route: PathData().route)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        else {
            ProgressView() // 혹은 다른 로딩 인디케이터를 사용할 수 있습니다.
        }
    }
}




#Preview {
    ContentView()
}

