//
//  CountryCodeViewModel.swift
//  DefualtSource
//
//  Created by darktech4 on 10/11/2023.
//

import Foundation
import SwiftUI

class CountryCodeViewModel: ObservableObject {
    static var shared = CountryCodeViewModel()
    
    //props
    @AppStorage("selectedCountryCode") var selectedCountryCode = "84"
    
}
