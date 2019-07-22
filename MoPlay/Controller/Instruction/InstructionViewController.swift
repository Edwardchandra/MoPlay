//
//  InstructionViewController.swift
//  MoPlay
//
//  Created by Edward Chandra on 19/07/19.
//  Copyright © 2019 Edward Chandra. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        let guidelineSlides:[SecondInstruction] = createSlides()
        setupSlideScrollView(guidelineSlides: guidelineSlides)
        
        pageControl.numberOfPages = guidelineSlides.count
        pageControl.currentPage = 0
        
        view.bringSubviewToFront(pageControl)
        
    }
    
    
    func createSlides() -> [SecondInstruction]{
        
        let slide1: SecondInstruction = Bundle.main.loadNibNamed( "SecondInstruction", owner: self, options: nil)?.first as! SecondInstruction
        slide1.instructionLabel.text = "First, AirPlay your iPhone screen \n to your Apple TV."
        slide1.instructionButton.isHidden = true
        
        let slide2: SecondInstruction = Bundle.main.loadNibNamed( "SecondInstruction", owner: self, options: nil)?.first as! SecondInstruction
        slide2.instructionLabel.text = "In this activity, parents and baby work together \n to catch the fishes in the sea by jumping."
        slide2.instructionButton.isHidden = true
        
        let slide3: SecondInstruction = Bundle.main.loadNibNamed( "SecondInstruction", owner: self, options: nil)?.first as! SecondInstruction
        slide3.instructionLabel.text = "If a fish successfully caught, \n there will be a celebration."
        slide3.instructionButton.isHidden = true
        
        let slide4: SecondInstruction = Bundle.main.loadNibNamed( "SecondInstruction", owner: self, options: nil)?.first as! SecondInstruction
        slide4.instructionLabel.text = "By having this activity, \n baby is expected \n to be able to learn how to jump."
        slide4.instructionButton.isHidden = false
        
        let nextPageGesture = UITapGestureRecognizer(target: self, action: #selector(self.nextPageAction))
        slide4.instructionButton.addGestureRecognizer(nextPageGesture)
        
        slide1.InstructionImageView.image = #imageLiteral(resourceName: "gameplayBackground")
        slide2.InstructionImageView.image = #imageLiteral(resourceName: "gameplayBackground")
        slide3.InstructionImageView.image = #imageLiteral(resourceName: "gameplayBackground")
        slide4.InstructionImageView.image = #imageLiteral(resourceName: "gameplayBackground")
        
        return [slide1, slide2, slide3, slide4]
    }
    
    @objc func nextPageAction(){
        performSegue(withIdentifier: "segueToGameplay", sender: self)
    }
    
    func setupSlideScrollView(guidelineSlides: [SecondInstruction]){
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(guidelineSlides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< guidelineSlides.count{
            guidelineSlides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            
            scrollView.addSubview(guidelineSlides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    

}
