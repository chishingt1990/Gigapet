//
//  Snail.swift
//  13.GigaPet
//
//  Created by Shuang Wu on 03/06/2017.
//  Copyright © 2017 Shuang Wu. All rights reserved.
//

import Foundation
import UIKit
import CoreFoundation

class Mole: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        playAppearAnimation()
    }
    
    func playAppearAnimation() {
        var appearArray = [UIImage]()
        for x in 1...6 {
            let appear = UIImage(named: "ch2appear\(x).png")
            appearArray.append(appear!)
        }
        
        self.animationImages = appearArray
        self.animationRepeatCount = 1
        self.animationDuration = 1.2
        self.startAnimating()
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        var idleArray = [UIImage]()
        self.image = UIImage(named: "ch2idle1.png")
        for x in 1...4 {
            let idle = UIImage(named: "ch2idle\(x).png")
            idleArray.append(idle!)
        }
        
        self.animationImages = idleArray
        self.animationRepeatCount = 0
        self.animationDuration = 0.8
        self.startAnimating()
    }
    
    func playDeadAnimation() {
        var deadArray = [UIImage]()
        self.image = UIImage(named: "ch2hide6.png")
        for x in 1...6 {
            let dead = UIImage(named: "ch2hide\(x).png")
            deadArray.append(dead!)
        }
        self.animationImages = deadArray
        self.animationRepeatCount = 1
        self.animationDuration = 1.2
        self.startAnimating()
    }
    
    func playAttackAnimation() {
        var attackArray = [UIImage]()
        for x in 1...8 {
            let walk = UIImage(named: "ch2attack\(x).png")
            attackArray.append(walk!)
        }
        self.animationImages = attackArray
        self.animationRepeatCount = 1
        self.animationDuration = 1.6
        self.startAnimating()
    }
    
}
