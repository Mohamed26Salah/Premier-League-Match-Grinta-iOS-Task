//
//  Bundle + UnitTest.swift
//  Premier-League-Match-Grinta-iOS-TaskTests
//
//  Created by Mohamed Salah on 14/10/2023.
//

import Foundation
import Foundation
extension Bundle {
    public class var unitTest: Bundle {
        return Bundle(for: MatchViewModelTest.self)
    }
}
