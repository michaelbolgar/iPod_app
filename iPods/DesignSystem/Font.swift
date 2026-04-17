//
//  Untitled.swift
//  iPods
//
//  Created by Sakina Rajabova on 16/04/26.
//

import UIKit

public enum AppFonts {
    
    // MARK: - Primary Font (Bodoni 72)
    
    public enum PrimaryStyle {
        case regular
        case bold
        
        var fontName: String {
            switch self {
            case .regular: return "BodoniSvtyTwoITCTT-Book"
            case .bold: return "BodoniSvtyTwoITCTT-Bold"
            }
        }
    }
    
    public static func primary(_ style: PrimaryStyle = .bold, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.fontName, size: size) else {
        
            return .systemFont(ofSize: size, weight: style == .bold ? .bold : .regular)
        }
        return font
   }
    
    // MARK: - Secondary Font (SF Pro)
    
    public enum SecondaryStyle {
        case regular
        case medium
        case semibold
        case thin
        
        var weight: UIFont.Weight {
            switch self {
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .thin: return .thin
            }
        }
    }
    
    public static func secondary(_ style: SecondaryStyle = .regular, size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: style.weight)
    }
    
    
   //  Fonts to use:
    
    public static func primary(size: CGFloat) -> UIFont {                   // Bodoni 72 - Book
        return primary(.regular, size: size)
    }
    
    public static func primaryBold(size: CGFloat) -> UIFont {              // Bodoni 72 - Bold
        return primary(.bold, size: size)
    }
    
    public static func secondary(size: CGFloat) -> UIFont {               // SF Pro - Regular
        return secondary(.regular, size: size)
    }
    
    public static func secondaryThin(size: CGFloat) -> UIFont {          // SF Pro - Thin
        return secondary(.thin, size: size)
    }
    
    public static func secondaryMedium(size: CGFloat) -> UIFont {       // SF Pro - Medium
        return secondary(.medium, size: size)
    }
}
