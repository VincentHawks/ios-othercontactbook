//
//  AvatarView.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 07.04.2021.
//

import Foundation
import UIKit

@IBDesignable
class AvatarView : UIView {
    
    var firstName: String? = "Marko"
    var lastName: String? = "Polo"
    
    private var color: UIColor?
    
    override func draw(_ rect: CGRect) {
        
        if color == nil {
            color = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        }
        color!.setFill()
        color!.setStroke()
        
        let oval = UIBezierPath(ovalIn: rect)
        oval.fill()
        oval.stroke()
        
        let string = "\(firstName?.first?.uppercased() ?? "")\(lastName?.first?.uppercased() ?? "")"
        let text = NSAttributedString(string: string, attributes: [
                NSAttributedString.Key.strokeColor     : UIColor.white,
                NSAttributedString.Key.font            : UIFont.systemFont(ofSize: 48)
            ]
        )
        let textBounds = text.boundingRect(with: text.size(), options: [], context: nil)
        let origin = CGPoint(x: (rect.width - textBounds.width) / 2, y: (rect.height - textBounds.height) / 2)
        text.draw(at: origin)
    }
    
}
