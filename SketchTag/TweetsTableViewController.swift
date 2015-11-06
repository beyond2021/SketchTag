//
//  TweetsTableViewController.swift
//  SketchTag
//
//  Created by KEEVIN MITCHELL on 10/23/15.
//  Copyright © 2015 Beyond 2021. All rights reserved.
//

import UIKit
import CoreLocation

class TweetsTableViewController: UITableViewController {
    
    //Model an array of an array of tweets. Each section is a new batch of tweets
    
    var tweets = [[Tweet]]()
    
    // MARK: - View controller life cycle
    
//    let latitude = CLLocationDegrees(40.7127)
//    let longitude = CLLocationDegrees(74.0059)
//    
//    let radius = CLLocationDistance(10)
    
    //LETS MAKE IT SEARCH FOR SOME SEARCH TEXT
    var searchText : String? =  "newyorkcity" {
        
        
        //When this is set I need to do a new search
        didSet{
            //everytime serch changes
           lastSuccessfulRequest = nil
            
            searchTextField?.text = searchText
            
            // Clear out my table
            tweets.removeAll()
            tableView.reloadData()
                                    refresh()
           
            
            
        }
        
    }
    
    
    var lastSuccessfulRequest : TwitterRequest?
    
    
    var nextRequestToAttempt : TwitterRequest? {
        if lastSuccessfulRequest == nil{
           //Lets make one
            if searchText != nil{
                let realSearchText = "#" + searchText!
                return TwitterRequest(search: realSearchText, count: 100)
            } else{
                return nil
                
            }
            
        } else {
            
          return  lastSuccessfulRequest!.requestForNewer
        }
       // return nil
    }
    
    
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            
            if   let request = nextRequestToAttempt {
                
                request.fetchTweets  { (newTweets) -> Void in
                    // NOTE THIS CLOUSURE IS NOT ON THE MAIN QUEUE SO NO UI STUFF UNLESS U GET BACK THERE. BECAUSE FETCH TWEETS IS AN ASYNCRONOUS API. MULTIYHTRADE API
                    //Do whatever I want in here with my new tweets
                    //if they are any
                    
                    // LETS GET BACK ON THE MAIN QUEUE
                    dispatch_async(dispatch_get_main_queue()){ () -> Void in
                        // NOW WE ARE BACK ON THE MAIN QUEUE
                        
                        if newTweets.count > 0 {
                            self.tweets.insert(newTweets, atIndex: 0) //HERE WE LOAD UP OUR MODEL
                            //This is in section 0. No proplem for capturing self in this case
                            //Next I reload my tableView.
                            // NB I should just reload this one section, but for demo purposes I am reloading the whole tableview here
                            self.tableView.reloadData()
                           sender?.endRefreshing()
                            
                        }
                        
                    }
                }
                
            }
        } else{
        
sender?.endRefreshing()
        }
        
    }
    
    @IBAction func refeshStream(sender: AnyObject) {
        tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
        refresh()
    }
    
    
    @IBAction func backToSearch(sender: AnyObject) {
        tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //// tableView.hidden = true
        self.title = searchText!.capitalizedString
        setTableViewHeight()
               refresh()
        
          }
    
   
    func setTableViewHeight(){
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func refresh(){
        if refreshControl != nil { // someone is calling refresh before my outlets are set. Start my spinner
            refreshControl?.beginRefreshing()
                    }
        refresh(refreshControl)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //WHEN THIS TRXTFIELD IS SET BY IOS I WILL SET MYSELF AS ITS DELEGATE
    @IBOutlet weak var searchTextField: UITextField!{
        
        didSet{
        searchTextField.delegate = self
            searchTextField.text = searchText
        }
        
    }
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        //HOW MANY SECTIONS DO WE KAVE. ANS. TWWETS.COUNT //// how many thing ion the tweetes model
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count // GETS ALL THE TWEETS IN EACH SECTION
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "TweeT"
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        
        // Configure the cell...
        //Lets make the title the actual tweet. find the twwet in this row and get the tweet's text
        //Get the tweet
   ///        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        // Configure the cell... using the custome ce3ll public API
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    /Users/keevinmitchell/Desktop/SketchTag/SketchTag/TweetsTableViewController.swift:227:44: Extraneous '_' in parameter: 'textField' has no keyword argument name
    
    */

}

extension TweetsTableViewController: UITextFieldDelegate
    

{
     func textFieldDidBeginEditing(textField: UITextField){
        
         if textField == searchTextField{
        
        }
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField{
            textField.resignFirstResponder()//dismiss the keyboard
            searchText = textField.text
            self.title = searchText!.capitalizedString
            
        }
        return true
    }
    
}

extension TweetsTableViewController : UITextViewDelegate {
    
    
    
}


