//
//  SecondGamePlayViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 18/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit
import CoreLocation

class SecondGamePlayViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var rabbitImage: UIImageView!
    @IBOutlet weak var userPrompt: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //MARK: Variables
    let locationManager = CLLocationManager()
    var trueHeading = CLLocationDirection ()
    var lastEventTime : NSDate?
    var lastCoordinate = 0.0
    var spinCount = 0.0
    var countdownTimer: Timer!
    var totalTime = 15
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        startTimer()
        
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
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        //     let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d", seconds)
    }
    
    

}
