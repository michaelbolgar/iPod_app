//
//  UIViewController.swift
//  iPods
//
//  Created by Hoshimov Matin on 17/04/26.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: -> Function Hide Keyboard
    func addKeyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
