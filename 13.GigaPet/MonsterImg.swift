//
//  MonsterImg.swift
//  13.GigaPet
//
//  Created by Shuang Wu on 30/05/2017.
//  Copyright © 2017 Shuang Wu. All rights reserved.
//

import Foundation
import UIKit
import CoreFoundation


class MonsterImg: UIImageView {
   
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        playIdleAnimation()
    }
    
    func playAttackAnimation() {
        var attackArray = [UIImage]()
        for x in 1...8 {
            let att = UIImage(named:"ch1attack\(x).png")
            attackArray.append(att!)
        }
        self.animationImages = attackArray
        self.animationDuration = 1.6
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
    func playIdleAnimation() {
        //create an array of images that the animation consists of
        var imgArray = [UIImage]()
        for x in 1...4 {
            let img = UIImage(named:"ch1idle\(x).png")
            imgArray.append(img!)
        }
        
        //put it into the UIimage and then animate via these lines
        self.animationImages = imgArray
        self.animationDuration = 0.8
        
        //setting repeatcount to zero means it will repeat infinitely
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeadAnimation(){
        self.image = UIImage(named: "ch1dead5.png")
        
        var deadArray = [UIImage]()
        for x in 1...4 {
            let dead = UIImage(named:"ch1dead\(x).png")
            deadArray.append(dead!)
        }
        
        self.animationImages = deadArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    

}
