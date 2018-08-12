//
//  ThirdBezierView.swift
//  DrawKit
//
//  Created by HanGyo Jeong on 2018. 8. 12..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit
import QuartzCore

class ThirdBezierView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        guard let myContext = context else {
            return
        }
        
        myContext.setLineWidth(4.0)
        
        myContext.setStrokeColor(UIColor.blue.cgColor)
        
        myContext.move(to: CGPoint.init(x: 10, y: 10))
        myContext.addCurve(to: CGPoint.init(x: 0, y: 50),
                           control1: CGPoint.init(x: 300, y: 250),
                           control2: CGPoint.init(x: 300, y: 400))
        
        myContext.strokePath()
    }
}
