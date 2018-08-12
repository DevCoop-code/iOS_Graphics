//
//  MyDrawView.swift
//  DrawKit
//
//  Created by HanGyo Jeong on 2018. 8. 12..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class MyDrawView: UIView {

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        /*
         Draw the line
         */
        
        //set the width
        context!.setLineWidth(2.0)
        
        //Make Color Reference
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColor.init(colorSpace: colorSpace, components: components)
        
        //Indicate the color
        context!.setStrokeColor(color!)
        
        let startPoint = CGPoint.init(x: 30, y: 30)
        let endPoint = CGPoint.init(x: 300, y: 400)
        
        context!.move(to: startPoint)
        context!.addLine(to: endPoint)
        
        context!.strokePath()
    }
}
