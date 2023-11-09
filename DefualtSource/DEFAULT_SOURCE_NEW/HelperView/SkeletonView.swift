//
//  SkeletonView.swift
//  RingtoneMVVM2023
//
//  Created by CycTrung on 01/06/2023.
//

import Foundation
import SwiftUI

struct SkeletonView<Content>: View where Content: View {
    @State var alpha = 0.5
    var views: Content
    
    init(@ViewBuilder content: () -> Content) {
           self.views = content()
       }
    var body: some View {
        ZStack{
            views
        }
        .opacity(alpha)
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 3).repeatForever()){
                if alpha == 0.5{
                    alpha = 1
                }else{
                    alpha = 0.5
                }
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
