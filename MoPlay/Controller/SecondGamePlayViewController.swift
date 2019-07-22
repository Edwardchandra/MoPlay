//
//  SecondGamePlayViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 18/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import CoreData

class SecondGamePlayViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var rabbitImage: UIImageView!
    @IBOutlet weak var userPrompt: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIImageView!
    @IBOutlet weak var pauseView: UIImageView!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var scoreView: UIImageView!
    @IBOutlet weak var completeButton: UIImageView!
    @IBOutlet weak var completeLabel: UILabel!
    
    
    //MARK: Variables
    let locationManager = CLLocationManager()
    var trueHeading = CLLocationDirection ()
    var lastEventTime : NSDate?
    var lastCoordinate = 0.0
    var spinCount = 0.0
    var countdownTimer: Timer!
    var totalTime = 39
    var storetime: Double?
    var audioPlayer: AVAudioPlayer?
    var temp: Int = 0
    var activities: [NSManagedObject] = []
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        startTimer()
        
        customizeComponent()
        
        pauseGesture()
        addAudio()
        audioPlayer?.play()
        
        completeGesture()
        
    }
    
    func completeGesture(){
        let completeGesture = UITapGestureRecognizer(target: self, action: #selector(self.completeAction))
        completeButton.addGestureRecognizer(completeGesture)
    }
    
    @objc func completeAction(){
        save(name: "Spinning", score: 100)
        performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    
    func save(name: String, score: Int){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Activities",
                                       in: managedContext)!
        
        let names = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        names.setValue(name, forKeyPath: "name")
        names.setValue(score, forKeyPath: "score")
        
        do {
            try managedContext.save()
            activities.append(names)
            print("saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addAudio(){
        audioPlayer = AVAudioPlayer()
        
        let sound = Bundle.main.path(forResource: "gamesound2", ofType: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }catch{
            print(error)
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
                self.pauseView.alpha = 1
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
    
    @IBAction func resumeAction(_ sender: Any) {
        if temp==1{
            startTimer()
            countdownTimer.fire()
            audioPlayer?.play()
            temp=0
            print(temp)
            UIView.animate(withDuration: 0.5, animations: {
                self.pauseView.alpha = 0
                self.resumeButton.alpha = 0
                self.restartButton.alpha = 0
                self.quitButton.alpha = 0
            }, completion: nil)
            pauseButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func restartAction(_ sender: Any) {
        if temp==1{
            pauseView.alpha = 0
            resumeButton.alpha = 0
            restartButton.alpha = 0
            quitButton.alpha = 0
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
            totalTime = 39
            audioPlayer?.play()
            timeLabel.text = "40"
            startTimer()
            pauseButton.isUserInteractionEnabled = true
            temp=0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    
    func customizeComponent(){
        resumeButton.layer.cornerRadius = 17
        restartButton.layer.cornerRadius = 17
        quitButton.layer.cornerRadius = 17
    }
    
    //MARK: LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //get coordinates
        let coordinates = newHeading.trueHeading
        let angle = coordinates * .pi / 180
        let difference = abs(coordinates-lastCoordinate)
        
        //get time interval
        let now = NSDate()
        if let lastEventTime = self.lastEventTime {
            let timeSinceLast = now.timeIntervalSince(lastEventTime as Date)
            let dps = difference/timeSinceLast
            //            rotationPerMinute.text = "\(dps)"
            
            switch dps {
            case 60.1...100: userPrompt.text = "Keep this pace"
            case 100...1000: userPrompt.text = "Slow Down"
            default: userPrompt.text = "A bit faster"
            }
            
            print("difference: \(difference)), time since last move: \(timeSinceLast) seconds, degrees per second: \(dps)")
            
            //get spin count
            self.spinCount = spinCount + difference
            //            spinCounter.text = "\(spinCount)"
        }
        
        
        //calculate RPM
        //        let RPM =  coordinates - lastCoordinate
        //        print("\(RPM)")
        
        
        self.lastEventTime = now
        self.lastCoordinate = coordinates
        //headingArray?.updateValue(coordinates, forKey: lastEventTime)
        
        
        //print ("\(coordinates) degrees, \(lastEventTime) time, \(elapsed)")
        
        //let RPM = headingArray[
        
        UIImageView.animate(withDuration: 0.5){
            self.rabbitImage.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
        }
        
        
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
            self.pauseButton.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.scoreView.alpha = 1
                self.completeButton.alpha = 1
                self.completeLabel.alpha = 1
            })
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        //     let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d", seconds)
    }
    
    

}
