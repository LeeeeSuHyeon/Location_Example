//
//  ImageTestView.swift
//  Location_Example
//
//  Created by 이수현 on 4/20/24.
//

import SwiftUI

struct ImageTestView: View {
    let url = "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQgByBT5IiAT_a2x9pUVb4VMoOrlzHH7Jrzj-HB5jzHlR4lNLMS"
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
            } placeholder: {
                ProgressView()
        }
    }
}

#Preview {
    ImageTestView()
}
