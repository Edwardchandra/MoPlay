//
//  ActivityCompleteViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 20/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit
import SpriteKit

class ActivityCompleteViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var firstStarImageView: UIImageView!
    @IBOutlet weak var secondStarImageView: UIImageView!
    @IBOutlet weak var thirdStarImageView: UIImageView!
    @IBOutlet weak var completeButton: UIImageView!
    
    var score: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        scorePoint()
        completeGesture()
    }
    
    func completeGesture(){
        let completeGesture = UITapGestureRecognizer(target: self, action: #selector(self.completeAction))
        completeButton.addGestureRecognizer(completeGesture)
    }
    
    @objc func completeAction(){
        performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    
    func scorePoint(){
        
        if score==0{
            scoreLabel.text = "Try Harder!"
        }else if score!<=5{
            scoreLabel.text = "Keep Trying!"
            firstStarImageView.alpha = 1
        }else if score!<=10{
            scoreLabel.text = "Good Job!"
            firstStarImageView.alpha = 1
            secondStarImageView.alpha = 1
        }else{
            scoreLabel.text = "Excellent!"
            firstStarImageView.alpha = 1
            secondStarImageView.alpha = 1
            thirdStarImageView.alpha = 1
        }
    }
    
    //Add SKEmitter
    func configureView(){
        
        let sk: SKView = SKView()
        sk.frame = backgroundView.bounds
        sk.backgroundColor = .clear
        backgroundView.addSubview(sk)
        
        let scene: SKScene = SKScene(size: backgroundView.bounds.size)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        
        let en = SKEmitterNode(fileNamed: "completeParticle.sks")
        en?.position = sk.center
        
        scene.addChild(en!)
        sk.presentScene(scene)
        
    }
    
}
