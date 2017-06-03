//
//  DragImg.swift
//  13.GigaPet
//
//  Created by Shuang Wu on 28/05/2017.
//  Copyright © 2017 Shuang Wu. All rights reserved.
//

import Foundation

//need to import both CoreGraphics and UIKit to allow for moving around of graphics.
import UIKit
import CoreGraphics

//UIImageView is also a class. DragImg is a class that inherits properties from UIImageView.
class DragImg: UIImageView {
    
    //UIImageView has some initializers, theses lines of code is just to initialize UIImageView's base class.
    override init (frame: CGRect){
        super.init(frame:frame)
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    //create a variable original position that refers to the first position when the drag movement is initiated
    var originalPosition: CGPoint!
    
    //UIImage and UIButton are subclasses of UIView, so by having dropTarget inheriting from UIView, the droptarget function will work for both images and buttons
    var dropTarget: UIView?
    
    //This DragImg class override the basic info in UIImageView with these lines of new code. This saves the first touch as original position variable
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    //allows for tracking of the movement (drag)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    //when the drag movement is over, return the images back to original position.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.location(in: self.superview)
            
            //creates a notification if the drop was within the frame of the monster
            if target.frame.contains(position){
                NotificationCenter.default.post(NSNotification(name:NSNotification.Name(rawValue: "onTargetDropped"), object: nil) as Notification)
            }
        }
        
        
        self.center = originalPosition
    }
        
    
}
