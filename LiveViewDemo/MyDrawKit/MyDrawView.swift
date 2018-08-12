

import UIKit
import QuartzCore

@IBDesignable
class MyDrawView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.white
    @IBInspectable var endColor: UIColor = UIColor.red
    @IBInspectable var endRadius: CGFloat = 200
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorspace,
                                  colors: [startColor.cgColor, endColor.cgColor] as CFArray,
                                  locations: locations)
        
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        
        let startRadius: CGFloat = 0
        
        startPoint.x = 210
        startPoint.y = 180
        endPoint.x = 210
        endPoint.y = 200
        
        guard let currentContext = context else {
            return
        }
        
        currentContext.drawRadialGradient(gradient!,
                                          startCenter: startPoint,
                                          startRadius: startRadius,
                                          endCenter: endPoint,
                                          endRadius: endRadius,
                                          options: .drawsBeforeStartLocation)
    }
}
