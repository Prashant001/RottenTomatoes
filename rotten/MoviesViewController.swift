//
//  MoviesViewController.swift
//  rotten
//
//  Created by Prashant Bhartiya on 9/12/14.
//  Copyright (c) 2014 Prashant Bhartiya. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies : [NSDictionary] = []
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=xzedj5qkpnsdam7f5nd9zjtx&limit=20&country=us"
        
        var request = NSURLRequest (URL: NSURL (string: url))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        
        [MBProgressHUD.showHUDAddedTo(self.view, animated: true)];
        
       // delay(1){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            
       
         //       self.tableView.backgroundColor = UIColor.blackColor()
           // self.tableView.tintColor = UIColor.whiteColor()
            //self.tableView.separatorColor = UIColor.darkGrayColor()

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (respone:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
         /*       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    sleep(3)
                });*/
            if(error != nil) {

                // If there is an error in the web request, print it to the console
                // let alertController = UIAlertController(title: "Error", message: "HI", preferredStyle: .Alert)
                
                
                //let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                //alertController.addAction(defaultAction)
                //self.presentViewController(alertController, animated: true, completion: nil)
                CSNotificationView.showInViewController(self, style: CSNotificationViewStyleError, message: error.localizedDescription)
                self.refreshControl.endRefreshing()
                return
                
               
            }
            
            
               var object = NSJSONSerialization.JSONObjectWithData(data, options: nil,
                    error: nil) as NSDictionary
                
                self.movies = object["movies"] as [NSDictionary]
            
                self.tableView.reloadData()
            
            }
            
            [MBProgressHUD .hideHUDForView(self.view, animated: true)];
        });
      
    }
    
    func refresh(sender:AnyObject)
    {
        //TODO: Remove duplicate code from viewDidLoad()
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            
            var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=xzedj5qkpnsdam7f5nd9zjtx&limit=30&country=us"
            
            var request = NSURLRequest (URL: NSURL (string: url))

            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (respone:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                
                
                
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil,
                    error: nil) as NSDictionary
                
                self.movies = object["movies"] as [NSDictionary]
                println("Refreshing")
                self.tableView.reloadData()
                
            }
        });
        self.refreshControl.endRefreshing()

    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieViewCell") as MovieViewCell
        
        var movie = movies[indexPath.row]
        
        cell.movieTitleLabel.text = movie["title"] as? String
        
        cell.synopsisLabel.text = movie["synopsis"] as? String
      
        var posters = movie["posters"] as NSDictionary
        
        var posterURL = posters["thumbnail"] as String
        
        var originalUrl = posterURL.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil)

        cell.posterView.setImageWithURL(NSURL(string: originalUrl))
        return cell
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let movieDetailViewController = segue.destinationViewController as MovieDetailViewController
        if let movieCell = sender as? MovieViewCell {
            movieDetailViewController.navigationItem.title = movieCell.movieTitleLabel.text
            movieDetailViewController.movieSynopsis=movieCell.synopsisLabel.text
            movieDetailViewController.movieDetailImage = movieCell.posterView.image
           // movieDetailViewController.movieImage = movieCell.posterView
            //if var movieSynopsis = movieCell.synopsisLabel.text as String {
            //movieDetailViewController.synopsisLabel.text = movieSynopsis
            //}
        }
    }
    

}
