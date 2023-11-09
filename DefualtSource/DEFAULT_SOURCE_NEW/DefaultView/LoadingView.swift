//
//  LoadingView.swift
//  DefualtSource
//
//  Created by darktech4 on 07/09/2023.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack{
            if show{
                Group{
                    Rectangle()
                        .fill(.black.opacity(0.2))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .animation(.easeIn(duration: 0.25), value: show)
    }
}
