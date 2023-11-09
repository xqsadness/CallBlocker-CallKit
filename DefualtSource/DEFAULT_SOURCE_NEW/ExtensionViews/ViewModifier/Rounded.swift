//
//  Rounded.swift
//  DefualtSource
//
//  Created by darktech4 on 06/09/2023.
//

import Foundation
import SwiftUI

struct Rounded: ViewModifier {
    private var backgroundColor: Color
    init (backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    func body (content: Content) -> some View {
        content.font(.caption)
            .padding(6)
            .background (backgroundColor)
            .clipShape (RoundedRectangle (cornerRadius: 10.0, style: .continuous))
            .foregroundColor(.white)
    }
}
