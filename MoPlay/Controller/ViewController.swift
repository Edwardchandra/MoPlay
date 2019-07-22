//
//  ViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 17/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var historyButton: UIImageView!
    
    //MARK: Variables
    var imageArray = [UIImage(named: "menu1"), UIImage(named: "menu2"), UIImage(named: "menu3")]
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        historyGesture()
    }
    
    //MARK: History Button
    func historyGesture(){
        let historyGesture = UITapGestureRecognizer(target: self, action: #selector(self.historyAction))
        historyButton.addGestureRecognizer(historyGesture)
    }
    
    @objc func historyAction(){
        performSegue(withIdentifier: "segueToHistory", sender: self)
    }
    
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell
        
        cell?.activityImage.image = imageArray[indexPath.row]
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0{
            print("1")
        }else if indexPath.row == 1{
            performSegue(withIdentifier: "segueToSecondInstruction", sender: self)
        }else if indexPath.row == 2{
            performSegue(withIdentifier: "segueToInstruction", sender: self)
        }
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }

}

