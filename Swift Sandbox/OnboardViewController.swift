//
//  OnboardViewController.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/4/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit
import SwiftyOnboard

class OnboardViewController: UIViewController {
    
    var swiftyOnboard: SwiftyOnboard!
    let colors: [UIColor] = [
        UIColor(red: 0/255, green: 204/255, blue: 10/255, alpha: 1.0),
        UIColor(red: 0/255, green: 196/255, blue: 196/255, alpha: 1.0),
        UIColor(red: 229/255, green: 2/255, blue: 78/255, alpha: 1.0)
    ]
    var titleArray: [String] = [
        "Welcome to Note Taker!",
        "Take notes on your phone. Revolutionary!",
        "Go ahead and start."
    ]
    var subTitleArray: [String] = [
        "The place to take notes that is like no other place to take notes.",
        "Pen and paper is so last century. Use your phone to take notes instead.",
        "What are you waiting for?"
    ]
    
    var gradiant: CAGradientLayer = {
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        UIApplication.shared.statusBarStyle = .lightContent
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    func gradient() {
        // Add gradiant to view
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index == 2 {
            performSegue(withIdentifier: "onboardSegue", sender: nil)
        } else {
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        }
        
    }
    
    func handleBegin(sender: UIButton) {
        performSegue(withIdentifier: "onboardSegue", sender: nil)
    }
}

extension OnboardViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        // Set the image on the page: 
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        // Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        
        view.title.font = UIFont(name: "ArialRoundedMTBold", size: 22)
        
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        // Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        // Setup for the overlay buttons
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continue", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
        }else {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}
