//
//  HistoryViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 22/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIImageView!
    
    var activities: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        backGesture()
    }
    
    func backGesture(){
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(self.backAction))
        backButton.addGestureRecognizer(backGesture)
        
    }
    
    @objc func backAction(){
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Activities")
        
        do {
            activities = try managedContext.fetch(fetchRequest)
            collectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return activities.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let name = activities[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HistoryCollectionViewCell
        
        cell?.customizeElement()
        cell?.activityName.text = name.value(forKeyPath: "name") as? String
        
        return cell!
        
    }
    
    

}
