//
//  boxView.swift
//  DrawKit
//
//  Created by HanGyo Jeong on 2018. 8. 12..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit

@IBDesignable
open class boxView: UIView {

    open override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        guard let myContext = context else {
            return
        }
        
        myContext.setLineWidth(2.0)
        myContext.setStrokeColor(UIColor.blue.cgColor)
        
        let rectangle = CGRect.init(x: 20, y: 20, width: 45, height: 45)
        
        myContext.addRect(rectangle)
        
        myContext.strokePath()
        
        myContext.setFillColor(UIColor.red.cgColor)
        myContext.fill(rectangle)
    }

}
