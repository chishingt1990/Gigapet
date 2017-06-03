//
//  ViewController.swift
//  13.GigaPet
//
//  Created by Shuang Wu on 27/05/2017.
//  Copyright © 2017 Shuang Wu. All rights reserved.
//

//remember to import this for audio
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    //It takes from MonsterImg Class, which inherits from UIImageView class.
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var skull1: UIImageView!
    @IBOutlet weak var skull2: UIImageView!
    @IBOutlet weak var skull3: UIImageView!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var currentPenalties = 0
    var timer: Timer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    //make sound effects
    var soundEffect: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!

    
    func itemDroppedOnCharacter (notif: AnyObject){
        print("item dropped on charcter")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        skull1.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        
        //Selector calls a function, just type in the name of the function within the quotes. The colon is required for any function with 1 or more parameter. Name is for a nortification called "OnTargetDropped". So basically, this line of code is saying, if it is observed that the notification center has a notification called "onTargetDropped", then it will run the ViewController.itemDroppedOnCharacter function
     NotificationCenter.default.addObserver(self, selector: #selector(self.itemDroppedOnCharacter(_:)), name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
        
        //insert this code block to play music
        do {
            //these three lines do the same thing as one line of code as shown below. basically letting the code identify which music file to play
            let resourcePath = Bundle.main.path(forResource: "cave-music", ofType: "mp3")
            let urlofmusic = NSURL(fileURLWithPath: resourcePath!)
            try soundEffect = AVAudioPlayer(contentsOf: urlofmusic as URL)
            
            //one line of code identifying which music file to play
            try sfxBite = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: "wav")!) as URL)
            try sfxDeath = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "wav")!) as URL)
            try sfxHeart = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: "wav")!) as URL)
            try sfxSkull = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: "wav")!) as URL)
            
            soundEffect.prepareToPlay()
            soundEffect.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxHeart.prepareToPlay()
            
        } catch let err as Error {
                print(err)
        }
        
        startTimer()
        
    }
    
    func itemDroppedOnCharacter (_: Notification) {
        monsterHappy = true
        startTimer()
        foodImg.alpha = DIM_ALPHA
        foodImg.isUserInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.isUserInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxBite.play()
        }

    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        //this line will create a timer that repeats every three second and calls changeGameState function every time.
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        if monsterHappy == false {
            currentPenalties += 1
            sfxSkull.play()
            if currentPenalties == 1 {
                skull1.alpha = OPAQUE
                skull2.alpha = DIM_ALPHA
                skull3.alpha = DIM_ALPHA
            }
            if currentPenalties == 2 {
                skull1.alpha = OPAQUE
                skull2.alpha = OPAQUE
                skull3.alpha = DIM_ALPHA
            }
            if currentPenalties >= 3 {
                skull1.alpha = OPAQUE
                skull2.alpha = OPAQUE
                skull3.alpha = OPAQUE
                gameOver()
                sfxDeath.play()
            }
            if currentPenalties == 0 {
                skull1.alpha = DIM_ALPHA
                skull2.alpha = DIM_ALPHA
                skull3.alpha = DIM_ALPHA
            }
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.isUserInteractionEnabled = false
            heartImg.alpha = OPAQUE
            heartImg.isUserInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.isUserInteractionEnabled = false
            foodImg.alpha = OPAQUE
            foodImg.isUserInteractionEnabled = true
        }
        currentItem = rand
        monsterHappy = false

    }
    
    func gameOver(){
        timer.invalidate()
        monsterImg.playDeadAnimation()
    }



}



