//
//  Alerter.swift
//  DefaultProject
//
//  Created by CycTrung on 04/06/2023.
//

import Foundation
import SwiftUI

class Alerter: ObservableObject {
    static var shared = Alerter()
    @Published var alert: Alert? {
        didSet { isShowingAlert = alert != nil }
    }
    @Published var isShowingAlert = false
}
