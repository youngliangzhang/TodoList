//
//  TLView.swift
//  TodoList
//
//  Created by Sky on 9/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class TLView: UIView {
    @IBInspectable var CornerRadius: CGFloat = 0
    @IBInspectable var BorderWidth: CGFloat = 0
    @IBInspectable var BorderColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = CornerRadius
        layer.borderWidth = BorderWidth
        layer.borderColor = BorderColor.cgColor
    }
}
