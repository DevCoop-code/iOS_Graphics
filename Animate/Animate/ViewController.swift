//
//  ViewController.swift
//  Animate
//
//  Created by HanGyo Jeong on 2018. 8. 12..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit
import DrawKit

class ViewController: UIViewController {

    var scaleFactor: CGFloat = 2
    var angle: Double = 180
    var box: boxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        box = boxView(frame: self.view.frame)
        
        self.view.addSubview(box)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

