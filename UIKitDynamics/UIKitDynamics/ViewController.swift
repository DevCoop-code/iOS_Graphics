//
//  ViewController.swift
//  UIKitDynamics
//
//  Created by HanGyo Jeong on 2018. 8. 25..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var blueBoxView: UIView?
    var redBoxView: UIView?
    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var frameRect = CGRect.init(x: 10, y: 20, width: 80, height: 80)
        blueBoxView = UIView(frame: frameRect)
        blueBoxView?.backgroundColor = UIColor.blue
        
        frameRect = CGRect.init(x: 150, y: 20, width: 60, height: 60)
        redBoxView = UIView(frame: frameRect)
        redBoxView?.backgroundColor = UIColor.red
        
        self.view.addSubview(blueBoxView!)
        self.view.addSubview(redBoxView!)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //Adjust Gravity to Blue and RedBox View
        let gravity = UIGravityBehavior(items: [blueBoxView!, redBoxView!])
        let vector = CGVector.init(dx: 0.0, dy: 1.0)
        gravity.gravityDirection = vector
        
        //Adjust Collision
        let collision = UICollisionBehavior(items: [blueBoxView!, redBoxView!])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        //control the elasticity attribute
        let behavior = UIDynamicItemBehavior(items: [blueBoxView!])
        behavior.elasticity = 0.5
        
        animator?.addBehavior(behavior)
        animator?.addBehavior(gravity)
        animator?.addBehavior(collision)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
