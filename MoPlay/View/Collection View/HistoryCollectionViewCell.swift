//
//  HistoryCollectionViewCell.swift
//  MoPlay
//
//  Created by Edward Chandra on 22/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var activityName: UILabel!
    
    func customizeElement(){
        
        cellView.layer.cornerRadius = 10
        
    }
    
    
}
