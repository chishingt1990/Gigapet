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
    @IBOutlet weak var moleImg: Mole!

    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var attackImg: DragImg!
    
    @IBOutlet weak var fruitImg: DragImg!
    @IBOutlet weak var fenceImg: DragImg!
    @IBOutlet weak var heart2Img: DragImg!
    
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var livepanel: UIImageView!
    @IBOutlet weak var skull1: UIImageView!
    @IBOutlet weak var skull2: UIImageView!
    @IBOutlet weak var skull3: UIImageView!
    
    @IBOutlet weak var bg1: UIImageView!
    @IBOutlet weak var bg2: UIImageView!
    @IBOutlet weak var ground1: UIImageView!
    
    @IBOutlet weak var charIcon1: UIButton!
    @IBOutlet weak var charIcon2: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var currentPenalties = 0
    var timer: Timer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var characterNumber = 2
    
    //make sound effects
    var soundEffect: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxAttack: AVAudioPlayer!
    
    
    func skullHideShow (bool: Bool) {
        skull1.isHidden = bool
        skull2.isHidden = bool
        skull3.isHidden = bool
        livepanel.isHidden = bool
    }
    
    func ch1HideShow (bool: Bool) {
        ch1obeyButtons(bool: bool)
        monsterImg.isHidden = bool
        bg1.isHidden = bool
        ground1.isHidden = bool
    }
    
    func ch1obeyButtons (bool: Bool) {
        foodImg.isHidden = bool
        heartImg.isHidden = bool
        attackImg.isHidden = bool
    }
    
    func ch2HideShow (bool: Bool) {
        ch2obeyButtons(bool: bool)
        moleImg.isHidden = bool
        bg2.isHidden = bool
        ground1.isHidden = bool
    }
    
    func ch2obeyButtons (bool: Bool) {
        fruitImg.isHidden = bool
        heart2Img.isHidden = bool
        fenceImg.isHidden = bool
    }
    
    func hideIcon(){
        charIcon1.isHidden = true
        charIcon2.isHidden = true
        initialLabel.isHidden = true
    }
    
    func hideEverything () {
        skullHideShow(bool: true)
        ch1HideShow(bool: true)
        ch2HideShow(bool: true)
        restartButton.isHidden = true
    }
    
    func selectCh1 () {
        ch1HideShow(bool: false)
        skullHideShow(bool: false)
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        attackImg.dropTarget = monsterImg
    }
    
    func selectCh2 () {
        ch2HideShow(bool: false)
        skullHideShow(bool: false)
        
        fruitImg.dropTarget = moleImg
        heart2Img.dropTarget = moleImg
        fenceImg.dropTarget = moleImg
    }
    
    func skullsDIM() {
        skull1.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
    }
    
    @IBAction func Character1(_ sender: Any) {
        hideIcon()
        characterNumber = 1
        selectCh1()
        skullsDIM()
        soundEffect.play()
        startTimer()
    }
    
    @IBAction func Character2(_ sender: Any) {
        hideIcon()
        characterNumber = 2
        selectCh2()
        skullsDIM()
        soundEffect.play()
        startTimer()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideEverything()
        
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
            try sfxAttack = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "btn", ofType: "wav")!) as URL)
            
            soundEffect.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxAttack.prepareToPlay()
            
        } catch let err as Error {
                print(err)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDroppedOnCharacter(_:)), name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
        
    }
    
    func itemDroppedOnCharacter (_: Notification) {
        monsterHappy = true
        startTimer()
        
        if characterNumber == 1 {
            foodImg.alpha = DIM_ALPHA
            foodImg.isUserInteractionEnabled = false
            heartImg.alpha = DIM_ALPHA
            heartImg.isUserInteractionEnabled = false
            attackImg.alpha = DIM_ALPHA
            attackImg.isUserInteractionEnabled = false
        }
        else if characterNumber == 2 {
            fruitImg.alpha = DIM_ALPHA
            fruitImg.isUserInteractionEnabled = false
            heart2Img.alpha = DIM_ALPHA
            heart2Img.isUserInteractionEnabled = false
            fenceImg.alpha = DIM_ALPHA
            fenceImg.isUserInteractionEnabled = false
        }
        if currentItem == 0 {
            sfxBite.play()
        } else if currentItem == 1 {
            sfxHeart.play()
        } else if currentItem == 2 {
            sfxAttack.play()
            if characterNumber == 1 {
                monsterImg.playAttackAnimation()
            } else if characterNumber == 2 {
                moleImg.playAttackAnimation()
            }
        }

    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        //this line will create a timer that repeats every three second and calls changeGameState function every time.
        
        if characterNumber == 1 {
            monsterImg.playIdleAnimation()
        }
        else if characterNumber == 2 {
            moleImg.playIdleAnimation()
        }
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
        
        let rand = arc4random_uniform(3) // 0 or 1
        if characterNumber == 1 {
            if rand == 0 {
                foodImg.alpha = OPAQUE
                foodImg.isUserInteractionEnabled = true
                heartImg.alpha = DIM_ALPHA
                heartImg.isUserInteractionEnabled = false
                attackImg.alpha = DIM_ALPHA
                attackImg.isUserInteractionEnabled = false
            } else if rand == 1 {
                foodImg.alpha = DIM_ALPHA
                foodImg.isUserInteractionEnabled = false
                heartImg.alpha = OPAQUE
                heartImg.isUserInteractionEnabled = true
                attackImg.alpha = DIM_ALPHA
                attackImg.isUserInteractionEnabled = false
            } else if rand == 2 {
                foodImg.alpha = DIM_ALPHA
                foodImg.isUserInteractionEnabled = false
                heartImg.alpha = DIM_ALPHA
                heartImg.isUserInteractionEnabled = false
                attackImg.alpha = OPAQUE
                attackImg.isUserInteractionEnabled = true
            }
        } else if characterNumber == 2 {
            if rand == 0 {
                fruitImg.alpha = OPAQUE
                fruitImg.isUserInteractionEnabled = true
                heart2Img.alpha = DIM_ALPHA
                heart2Img.isUserInteractionEnabled = false
                fenceImg.alpha = DIM_ALPHA
                fenceImg.isUserInteractionEnabled = false
            } else if rand == 1 {
                fruitImg.alpha = DIM_ALPHA
                fruitImg.isUserInteractionEnabled = false
                heart2Img.alpha = OPAQUE
                heart2Img.isUserInteractionEnabled = true
                fenceImg.alpha = DIM_ALPHA
                fenceImg.isUserInteractionEnabled = false
            } else if rand == 2 {
                fruitImg.alpha = DIM_ALPHA
                fruitImg.isUserInteractionEnabled = false
                heart2Img.alpha = DIM_ALPHA
                heart2Img.isUserInteractionEnabled = false
                fenceImg.alpha = OPAQUE
                fenceImg.isUserInteractionEnabled = true
            }
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver(){
        timer.invalidate()
        if characterNumber == 1 {
            monsterImg.playDeadAnimation()
            ch1obeyButtons(bool: true)
        } else if characterNumber == 2 {
            moleImg.playDeadAnimation()
            ch2obeyButtons(bool: true)
        }
        restartButton.isHidden = false
        soundEffect.stop()
    }
    
    @IBAction func restartGame(_ sender: Any) {
        restartButton.isHidden = true
        if characterNumber == 1 {
            ch1obeyButtons(bool: false)
        } else if characterNumber == 2 {
            ch2obeyButtons(bool: false)
        }
        skullsDIM()
        currentPenalties = 0
        startTimer()
        soundEffect.play()
    }

}



