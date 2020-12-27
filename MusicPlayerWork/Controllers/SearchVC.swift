//
//  SearchVC.swift
//  MusicPlayerWork
//
//  Created by Mac on 26.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import CollectionKit

class SearchVC: UIViewController {
    let shapeLayer  = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let center = self.view.center
        
        let circularPathTrack = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi, endAngle: CGFloat(2 * CFloat.pi), clockwise: true)
        
        self.trackLayer.path = circularPathTrack.cgPath
        
        self.trackLayer.strokeColor = UIColor.black.cgColor
        self.trackLayer.lineWidth = 10
        self.trackLayer.fillColor = UIColor.clear.cgColor
        self.trackLayer.lineCap = .round
        
        self.view.layer.addSublayer(self.trackLayer)
    
        
        self.shapeLayer.path = circularPathTrack.cgPath
        
        self.shapeLayer.strokeColor = UIColor.red.cgColor
        self.shapeLayer.lineWidth = 10
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.lineCap = .round
        self.shapeLayer.strokeEnd = 0
        

        
        self.view.layer.addSublayer(self.shapeLayer)
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
    }
    @objc func tapped(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false // silinmemesi için
        
        self.shapeLayer.add(basicAnimation, forKey: "basic")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

}
