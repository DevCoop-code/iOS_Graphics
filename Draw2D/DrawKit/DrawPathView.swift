//
//  DrawPathView.swift
//  DrawKit
//
//  Created by HanGyo Jeong on 2018. 8. 12..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class DrawPathView: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        guard let myContext = context else {
            return
        }
        
        myContext.setLineWidth(2.0)
        
        myContext.setStrokeColor(UIColor.blue.cgColor)
        
        myContext.move(to: CGPoint.init(x: 100, y: 100))
        myContext.addLine(to: CGPoint.init(x: 150, y: 150))
        myContext.addLine(to: CGPoint.init(x: 100, y: 200))
        myContext.addLine(to: CGPoint.init(x: 50, y: 150))
        myContext.addLine(to: CGPoint.init(x: 100, y: 100))
        
        //Fill the color
        myContext.setFillColor(UIColor.red.cgColor)
        myContext.fillPath()
        
        myContext.strokePath()
    }
}
