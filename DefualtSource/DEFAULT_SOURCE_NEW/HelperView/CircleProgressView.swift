//
//  CircleProgressView.swift
//  RingtoneMVVM2023
//
//  Created by CycTrung on 01/06/2023.
//

import Foundation
import SwiftUI

struct CircleView: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 1)
                    .stroke(Color.background, style: StrokeStyle(lineWidth: 5))
                    .rotationEffect(Angle(degrees: -90))
                Circle()
                    .trim(from: 0.0, to: progress > 0 ? progress : 0)
                    .stroke(LinearGradient(colors: [.accentColor, Color(hex: "E177E4")], startPoint: .leading, endPoint: .trailing), lineWidth:  5)
                    .rotationEffect(Angle(degrees: -90))
            }
        }
    }
}
