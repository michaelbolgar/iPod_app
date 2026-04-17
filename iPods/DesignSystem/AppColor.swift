//
//  DesignSystem.swift
//  DesignSystem
//
//  Created by Sakina Rajabova on 16/04/26.
//

import Foundation

import UIKit

public enum AppColor {
    
    // Colors to use:
    
    public static let primary = UIColor(hex: "#F59E0C")     // Yellow
    public static let secondary = UIColor(hex: "#A3A3A3")  // Gray
    public static let white = UIColor(hex: "#FFFFFF")     // White
    public static let background = UIColor.black         // Black
    
}

// MARK: - UIColor + HEX
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
