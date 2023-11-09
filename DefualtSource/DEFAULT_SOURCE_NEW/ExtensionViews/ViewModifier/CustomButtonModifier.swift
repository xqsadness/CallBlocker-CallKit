//
//  CustomButtonModifier.swift
//  DefualtSource
//
//  Created by darktech4 on 06/09/2023.
//

import Foundation
import SwiftUI

struct CustomButtonModifier: ViewModifier {
    var backgroundColor: Color
    var textColor: Color
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
    }
}
