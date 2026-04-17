//
//  Untitled.swift
//  iPods
//
//  Created by Sakina Rajabova on 16/04/26.
//


import UIKit

public final class DesignFactory {
    
    // MARK: - Labels
    
    // Белый лейбл
    
    public static func makePrimaryLabel(text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = AppColor.white
        label.font = AppFonts.primary(size: size)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // Серый  лейбл
    
    public static func makeSecondaryLabel(text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = AppColor.secondary
        label.font = AppFonts.secondary(size: size)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - Buttons
        
    // Желтая кнопка
    
        public static func makePrimaryButton(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.backgroundColor = AppColor.primary
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = AppFonts.secondaryMedium(size: 20)
            button.layer.cornerRadius = 20
            button.translatesAutoresizingMaskIntoConstraints = false
    
            
            return button
        }
    }
