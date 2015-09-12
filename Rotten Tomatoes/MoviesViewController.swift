//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Tianyi Xing on 9/11/15.
//  Copyright © 2015 Tianyi Xing. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   @IBOutlet weak var tableView: UITableView!
  
   var movies: [NSDictionary]?
  
   var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView.dataSource = self
      tableView.delegate = self
      
         let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
      
      
          let request = NSURLRequest(URL: url)
  
      
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
        let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? NSDictionary
        
        //  NSLog("the length of the photos NSArray is: \(self.photos?.count)")
        //  NSLog("response: \(self.photos)")
        
        
        if let json = responseDictionary {
          self.movies = json["movies"] as? [NSDictionary]
          self.tableView.reloadData()
        }
        
        //print(self.movies)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)


      }
  
     }
 
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
   
    
    let movie = self.movies![indexPath.row]
    
    cell.titleLabel.text = movie["title"] as? String
    cell.synopsisLabel.text = movie["synopsis"] as? String
    //cell.textLabel?.text = movie["title"] as? String
    
    let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
    
    cell.posterView.setImageWithURL(url)
    return cell
    
    
    
    
  }
  
  func refresh(sender:AnyObject)
  {
    
    
    
    self.refreshControl.endRefreshing()
    
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let movies = movies {
      return movies.count
    } else {
      return 0
    }

  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPathForCell(cell)!
      
    let movie = movies![indexPath.row]
      
    let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
    
      movieDetailsViewController.movie = movie
  
  
  }
 

}
