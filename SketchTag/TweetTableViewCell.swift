//
//  TweetTableViewCell.swift
//  SketchTag
//
//  Created by KEEVIN MITCHELL on 10/27/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    //Code that make these get updated when someone sets the tweet
    //Public API tath will be used in xell for row
    var tweet: Tweet?{
        didSet{
           updateUI()
            
        }
        
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetTimeLabel: UILabel!
   
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    func updateUI(){
        
        //Reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel.attributedText = nil
        tweetTimeLabel.attributedText = nil
        tweetProfileImageView.image = nil
        tweetTextView.attributedText = nil
        
        //Load new info from our tweet (If Any)
        if let tweet = self . tweet
        {
//            tweetTextLabel?.text = tweet.text
//            if tweetTextLabel?.text != nil {
//                for _ in tweet.media {
//                    tweetTextLabel.text! += " 📷"
            
 //               }
        
        
          //  }
            
            tweetTextView?.text = tweet.text
            if tweetTextView?.text != nil{
                for _ in tweet.media {
                    tweetTextView.text! += " 📷"                    
                }
                
                
            }
            
            
       tweetScreenNameLabel?.text = "\(tweet.user)" //Twwet.user.desceiption
            if let profileImageURL = tweet.user.profileImageURL
            {
                let myQos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
                let queue = dispatch_get_global_queue(myQos, 0)
                
                dispatch_async(queue){
                    
                    if let imageData = NSData(contentsOfURL: profileImageURL){
                        //This blocks main thread
                        
                        dispatch_async(dispatch_get_main_queue()){
                            
                           // get back the main queue
                       self .tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                    
                    
                    
                }
                
                
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                
            }
            tweetTimeLabel?.text = formatter.stringFromDate(tweet.created)
            
            
        }
        
        
    }
    
    
    
    
}
