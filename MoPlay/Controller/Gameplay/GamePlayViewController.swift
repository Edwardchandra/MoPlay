//
//  GamePlayViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 18/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit
import AVFoundation

class GamePlayViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var jumpLabel: UILabel!
    @IBOutlet weak var pauseButton: UIImageView!
    @IBOutlet weak var fishLayer: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var scoreView: UIImageView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var scoreCheck: UIImageView!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var pausePopUpImageView: UIImageView!
    
    //MARK: Variables
    var temp: Int = 0
    var countdownTimer: Timer!
    var totalTime = 44
    var storetime: Double?
    var audioPlayer: AVAudioPlayer?
    var timer = Timer()
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround() 
        
        customizeComponent()
        
        emitNemo()
        emitDory()
        startTimer()
        
        pauseGesture()
        scoreGesture()
        addAudio()
        audioPlayer?.play()
        
        //scheduledTimerWithTimeInterval()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        
        timer = Timer.scheduledTimer(timeInterval: 1.7, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)

        
        
    }
    
    @objc func updateCounting(){
            self.jumpLabel.alpha = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.jumpLabel.alpha = 0
            }
    }
    
    func addAudio(){
        audioPlayer = AVAudioPlayer()
        
        let sound = Bundle.main.path(forResource: "gamesound", ofType: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }catch{
            print(error)
        }
        
    }
    
    //MARK: NextPage Button
    func scoreGesture(){
        let scoreTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.scoreAction))
        scoreCheck.addGestureRecognizer(scoreTapGesture)
    }
    
    @objc func scoreAction(){
        performSegue(withIdentifier: "segueToScore", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToScore"{
            let scoreDestination = segue.destination as? ActivityCompleteViewController
            
            scoreDestination!.score = Int(scoreTextField.text!)
            
        }
        
    }
    
    
    //MARK: Pause Button
    func pauseGesture(){
        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pauseAction))
        pauseButton.addGestureRecognizer(pauseTapGesture)
    }
    
    @objc func pauseAction(){
        
        if temp==0{
            countdownTimer.invalidate()
            storetime = Double(timeLabel.text!)!
            audioPlayer?.pause()
            temp=1
            print(temp)
            UIView.animate(withDuration: 1, animations: {
                self.pausePopUpImageView.alpha = 1
                self.resumeButton.alpha = 1
                self.restartButton.alpha = 1
                self.quitButton.alpha = 1
            }, completion: nil)
            pauseButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func paused(){
        print("paused")
    }
    
    //MARK: Resume Game
    @IBAction func resumeAction(_ sender: Any) {
        if temp==1{
            startTimer()
            countdownTimer.fire()
            audioPlayer?.play()
            temp=0
            print(temp)
            UIView.animate(withDuration: 0.5, animations: {
                self.pausePopUpImageView.alpha = 0
                self.resumeButton.alpha = 0
                self.restartButton.alpha = 0
                self.quitButton.alpha = 0
            }, completion: nil)
            pauseButton.isUserInteractionEnabled = true
        }
    }
    
    //MARK: Restart Game
    @IBAction func restartAction(_ sender: Any) {
        if temp==1{
            pausePopUpImageView.alpha = 0
            resumeButton.alpha = 0
            restartButton.alpha = 0
            quitButton.alpha = 0
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
            totalTime = 44
            audioPlayer?.play()
            timeLabel.text = "45"
            startTimer()
            pauseButton.isUserInteractionEnabled = true
            temp=0
        }
    }
    
    //MARK: Quit Game
    @IBAction func quitAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    
    //MARK: Customize Components
    func customizeComponent(){
        pauseButton.layer.cornerRadius = 25
        timeView.layer.cornerRadius = 50
        resumeButton.layer.cornerRadius = 17
        restartButton.layer.cornerRadius = 17
        quitButton.layer.cornerRadius = 17
    }
    
    //MARK: Timer
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timeLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        print("time end")
        UIView.animate(withDuration: 2.0, animations: {
            self.fishLayer.alpha = 0
            self.pauseButton.alpha = 0
            self.timeView.layer.backgroundColor = #colorLiteral(red: 0.9519329667, green: 0, blue: 0, alpha: 1)
        }) { (_) in
            self.fishLayer.removeFromSuperview()
            UIView.animate(withDuration: 1.0, animations: {
                self.scoreView.alpha = 1
                self.scoreCheck.alpha = 1
                self.scoreTextField.alpha = 1
            })
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        //     let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d", seconds)
    }
    
    //MARK: Emitter
    func emitDory() {
        let doryEmitter = CAEmitterLayer()
        
        doryEmitter.emitterPosition = CGPoint(x: 0, y: view.frame.height/4)
        doryEmitter.emitterShape = .line
        doryEmitter.emitterSize = CGSize(width: view.frame.width, height: view.frame.height)
        doryEmitter.renderMode = .additive
        
        let cell = CAEmitterCell()
        cell.birthRate = 0.5
        cell.lifetime = 100.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = 165
        cell.scale = 0.75
        cell.scaleRange = 0.65
        cell.alphaSpeed = -0.025
        cell.contents = UIImage(named: "dory")?.cgImage
        doryEmitter.emitterCells = [cell]
        
        fishLayer.layer.addSublayer(doryEmitter)
    }
    
    func emitNemo() {
        let nemoEmitter = CAEmitterLayer()
        
        nemoEmitter.emitterPosition = CGPoint(x: view.frame.width, y: view.frame.height/4)
        nemoEmitter.emitterShape = .line
        nemoEmitter.emitterSize = CGSize(width: view.frame.width, height: view.frame.height)
        nemoEmitter.renderMode = .additive
        
        let cell = CAEmitterCell()
        cell.birthRate = 0.5
        cell.lifetime = 100.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = 350
        cell.scale = 0.75
        cell.scaleRange = 0.5
        cell.alphaSpeed = -0.025
        cell.contents = UIImage(named: "nemo")?.cgImage
        nemoEmitter.emitterCells = [cell]
        
        fishLayer.layer.addSublayer(nemoEmitter)
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
