//
//  TweetDetailController.swift
//  SketchTAG
//
//  Created by KEEVIN MITCHELL on 11/1/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController {
   
    
    
    override func viewDidLoad() {
        self.title = "What shall we put in here guys?'"
    }

    
    override func viewWillAppear(animated: Bool) {
        
        let firstImageView = UIImageView(image: UIImage(named: "bg01.png"))
        firstImageView.frame = view.frame
        view.addSubview(firstImageView)
        
        imageFadeIn(firstImageView)
        
    }
    
    func imageFadeIn(imageView: UIImageView) {
        
        let secondImageView = UIImageView(image: UIImage(named: "bg02.png"))
        secondImageView.frame = view.frame
        secondImageView.alpha = 0.0
        
        view.insertSubview(secondImageView, aboveSubview: imageView)
        
        UIView.animateWithDuration(2.0, delay: 2.0, options: .CurveEaseOut, animations: {
            secondImageView.alpha = 1.0
            }, completion: {_ in
                imageView.image = secondImageView.image
                secondImageView.removeFromSuperview()
        })
        
    }
    
    
}
