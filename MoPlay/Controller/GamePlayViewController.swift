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
    
    //MARK: Variables
    var temp: Int = 0
    var countdownTimer: Timer!
    var totalTime = 9
    var storetime: Double?
    var audioPlayer: AVAudioPlayer?
    //var timer = Timer()
    
    //var abort = true
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    func scheduledTimerWithTimeInterval(){
        
        if totalTime >= 3{
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: abort)

        }else{
            timer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                self.abort = false
            }
        }
        
    }
    
    @objc func updateCounting(){
        if abort == true{
            self.jumpLabel.alpha = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.jumpLabel.alpha = 0
            }
        }
    }
    */
    
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
        
        let scoreDestination = segue.destination as? ActivityCompleteViewController
        
        scoreDestination!.score = Int(scoreTextField.text!)
        
    }
    
    
    //MARK: Pause Button
    func pauseGesture(){
        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pauseAction))
        pauseButton.addGestureRecognizer(pauseTapGesture)
    }
    
    @objc func pauseAction(){
        
        if temp==1{
            startTimer()
            countdownTimer.fire()
            temp=0
            print(temp)
        }else if temp==0{
            countdownTimer.invalidate()
            storetime = Double(timeLabel.text!)!
            temp=1
            print(temp)
        }
    }
    
    @objc func paused(){
        print("paused")
    }
    
    func customizeComponent(){
        pauseButton.layer.cornerRadius = 25
        timeView.layer.cornerRadius = 50
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
