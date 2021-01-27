//
//  Globals.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/27/21.
//

import Foundation
import UIKit

// MARK: - GLOBAL CONSTANTS -

/// Standard Padding = 24
let standardPadding: CGFloat = 24

// MARK: - Custom Color -
/// Custom Color allows easy access to the Assets folder.
enum CustomColor: String {
    case black = "Black"
    case coral = "Coral"
    case green = "Green"
    case white = "White"
    case blue = "Blue"
}

extension UIColor {
    static func customColor(_ color: CustomColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}
