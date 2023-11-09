//
//  ActivityIndicatorView.swift
//  RingtoneMVVM2023
//
//  Created by CycTrung on 01/06/2023.
//

import Foundation
import SwiftUI

public struct ActivityIndicatorView: View {
    public var body: some View {
        GeometryReader { geometry in
            ForEach(0..<3, id: \.self) { index in
                ArcsIndicatorItemView(lineWidth: 2, index: index, count: 3, size: geometry.size)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct ArcsIndicatorItemView: View {
    let lineWidth: CGFloat
    let index: Int
    let count: Int
    let size: CGSize

    @State private var rotation: Double = 0

    var body: some View {
        let animation = Animation.default
            .speed(Double.random(in: 0.2...0.5))
            .repeatForever(autoreverses: false)

        return Group { () -> Path in
            var p = Path()
            p.addArc(center: CGPoint(x: size.width / 2, y: size.height / 2),
                     radius: size.width / 2 - CGFloat(index) * CGFloat(count),
                     startAngle: .degrees(0),
                     endAngle: .degrees(Double(Int.random(in: 120...300))),
                     clockwise: true)
            return p.strokedPath(.init(lineWidth: lineWidth))
        }
        .frame(width: size.width, height: size.height)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            rotation = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                withAnimation(animation) {
                    rotation = 360
                }
            }
        }
    }
}

struct CustomActivity: View {
    var hasBackground: Bool = false
    var colorBackground: Color = .black
    var opacityBackground: Double = 0.4
    var foregroundColor: Color = .accentColor
    var size: CGSize = CGSize(width: 50, height: 50)
    @State var show = true
    var body: some View {
        ZStack{
            if hasBackground{
                colorBackground
                    .ignoresSafeArea()
                    .opacity(opacityBackground)
            }
            ActivityIndicatorView()
                .frame(width: size.width, height: size.height , alignment: .center)
                .foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
