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
    
    //MARK: Variables
    var imageArray = [UIImage(named: "menu1"), UIImage(named: "menu2"), UIImage(named: "menu3")]
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell
        
        cell?.activityImage.image = imageArray[indexPath.row]
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segueToInstruction", sender: self)
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }

}

