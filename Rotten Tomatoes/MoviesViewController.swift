//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Tianyi Xing on 9/11/15.
//  Copyright © 2015 Tianyi Xing. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftLoader
import Darwin


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filtered:[String] = []
    var searchActive : Bool = false
    var refreshControl:UIRefreshControl!
    var titleList: [String] = []
    var titleAndIndex = [String: Int]()
    var filteredMovie: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        //config.size = 150
        config.backgroundColor = UIColor.grayColor()
        config.spinnerColor = UIColor.whiteColor()
        SwiftLoader.setConfig(config)
        
        SwiftLoader.show(title: "Loading...", animated: true)
        
        
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        searchBar.barTintColor = UIColor.blackColor()
        searchBar.tintColor = UIColor.orangeColor()
        
        
        //      self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        //      self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
//        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=f2fk8pundhpxf77fscxvkupy")!
        
        let request = NSURLRequest(URL: url)
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? NSDictionary
            
            //  NSLog("the length of the photos NSArray is: \(self.photos?.count)")
            //  NSLog("response: \(self.photos)")
            
            
            
            if(responseDictionary == nil) {
                
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "No Network Connection"
                alert.addButtonWithTitle("OK")
                alert.show()
                
            }
            
            
            if let json = responseDictionary {
                self.movies = json["movies"] as? [NSDictionary]
                var currCNT: Int = 0;
                for movie in self.movies! {
                    self.titleList.append(movie["title"] as! String)
                    self.titleAndIndex[movie["title"] as! String] = currCNT
                    currCNT++
                }
                
                NSLog("\(self.titleAndIndex)")
                NSLog("\(self.titleList)")
                
                sleep(1)
                SwiftLoader.hide()
                self.tableView.reloadData()
            }
            
            //print(self.movies)
            
            self.refreshControl = UIRefreshControl()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            self.tableView.addSubview(self.refreshControl)
            
            
            // self.searchBar.resignFirstResponder()
            
            
        }
        
    }
    
    //    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    //    {
    //        return true;
    //    }
    
    
    
    func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if cell.respondsToSelector("setSeparatorInset:") {
                cell.separatorInset = UIEdgeInsetsZero
            }
            if cell.respondsToSelector("setLayoutMargins:") {
                cell.layoutMargins = UIEdgeInsetsZero
            }
            if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
                cell.preservesSuperviewLayoutMargins = false
            }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        //cell.layoutMargins = UIEdgeInsetsZero
        
        var currIndex = indexPath.row
        
        if(searchActive) {
            
            
            //        currIndex = 4
            let currTitle = self.filtered[indexPath.row]
            currIndex = titleAndIndex[currTitle]!
            NSLog("current index for big heor is : \(currIndex)")
            
        }
        
        let movie = self.movies![currIndex]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        //cell.textLabel?.text = movie["title"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        
        cell.posterView.setImageWithURL(url)
        
        
        
        return cell
        
    }
    
    func refresh(sender:AnyObject)
    {
        
//        
//        let alert = UIAlertView()
//        alert.title = "Error"
//        alert.message = "No Network Connection"
//        alert.addButtonWithTitle("OK")
//        alert.show()
//        

        self.tableView.reloadData()        
        self.refreshControl.endRefreshing()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
        } else {
            
            
            
            
            if let movies = movies {
                return movies.count
            } else {
                return 0
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = titleList.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
            
            
            
            
        }
        self.tableView.reloadData()
    }
    
  
    
    func textFieldShouldReturn(searchBar: UISearchBar!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        searchBar.resignFirstResponder()
        return true;
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
