//
//  OnboardingViewController.swift
//  Ball Shooter
//
//  Created by Lars Olt on 7/2/20.
//  Copyright © 2020 Lars Olt. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var onboardingScroll: UIScrollView!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var scrollBtn: UIButton!
    
    var images: [String] = [String]()
    var frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill up the images array
        for i in 1...7 {
            images.append("Instruction_page_\(i)")
        }
        
        onboardingPageControl.numberOfPages = images.count
        
        setupScroll()
        
    }
    
    func setupScroll() {
        
        // Set up the frames for the scroll view
        for index in 0..<images.count {
            
            // Set up the frame position based on the other frames
            frame.origin.x = onboardingScroll.frame.size.width * CGFloat(index)
            frame.size = onboardingScroll.frame.size
            
            // Set up the view
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[index])
            imageView.contentMode = .scaleAspectFit
            onboardingScroll.addSubview(imageView)
            
        }
        
        let scrollWidth = onboardingScroll.frame.size.width * CGFloat(images.count)
        let scrollHeight = onboardingScroll.frame.size.height
        onboardingScroll.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        onboardingScroll.delegate = self
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = onboardingScroll.contentOffset.x / onboardingScroll.frame.size.width
        onboardingPageControl.currentPage = Int(pageNumber)
        
        if (Int(pageNumber + 1) == images.count) {
            scrollBtn.setImage(UIImage(named: Images.finishBtn), for: .normal)
        }
        else {
            scrollBtn.setImage(UIImage(named: Images.nextBtn), for: .normal)
        }
        
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        let pageNumber = onboardingScroll.contentOffset.x / onboardingScroll.frame.size.width
        
        if (Int(pageNumber) < images.count - 1) {
            
            slideToNext()
            
            if (Int(pageNumber + 2) == images.count) {
                scrollBtn.setImage(UIImage(named: Images.finishBtn), for: .normal)
            }
            else {
                scrollBtn.setImage(UIImage(named: Images.nextBtn), for: .normal)
            }
            
        }
        else {
            performSegue(withIdentifier: "segueFromOnboardingToLevels", sender: nil)
        }
    }
    
    func slideToNext() {
        let newX = onboardingScroll.contentOffset.x + onboardingScroll.frame.size.width
        let newY = onboardingScroll.contentOffset.y
        
        // Transition the scroll view
        onboardingScroll.setContentOffset(CGPoint(x: newX, y: newY), animated: true)
        
        let updatedPageNumber = onboardingScroll.contentOffset.x / onboardingScroll.frame.size.width
        onboardingPageControl.currentPage = Int(updatedPageNumber + 1)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
