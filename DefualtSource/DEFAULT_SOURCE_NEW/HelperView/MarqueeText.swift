//
//  MarqueeText.swift
//  RingtoneMVVM2023
//
//  Created by CycTrung on 01/06/2023.
//

import Foundation
import SwiftUI

struct MarqueeText: View{
    @State var text: String
    var font: UIFont
    var color: Color
    var speed = 0.015
    var delay: Double = 1
    @State var storedSize: CGSize = .zero
    @State var offset: CGFloat = 0
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            Text(text)
                .font(Font(font))
                .foregroundColor(color)
                .offset(x: offset)
        }
        .disabled(true)
        .onAppear(perform: {
            let baseText = text
            (1...15).forEach { _ in
                text.append(" ")
            }
            storedSize = textSize()
            text.append(baseText)
            
            let time: Double = speed * storedSize.width
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.linear(duration: time)){
                    offset = -storedSize.width
                }
            }
        })
        .onReceive(Timer.publish(every: (speed * storedSize.width)+delay, on: .main, in: .default).autoconnect()) { _ in
            offset = 0
            withAnimation(.linear(duration: (speed * storedSize.width))){
                offset = -storedSize.width
            }
        }
    }
    
    func textSize()->CGSize{
        let fontAttributes = [NSAttributedString.Key.font: font]
        return text.size(withAttributes: fontAttributes)
    }
}
