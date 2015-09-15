//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Tianyi Xing on 9/11/15.
//  Copyright © 2015 Tianyi Xing. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

  @IBOutlet weak var navBar: UINavigationItem!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  
  var movie: NSDictionary!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      titleLabel.text = movie["title"] as? String
      synopsisLabel.text = movie["synopsis"] as? String
      
        
      var url = movie.valueForKeyPath("posters.thumbnail") as! String
        
      let urlOld = NSURL(string: url)
       imageView.setImageWithURL(urlOld!)

        
        
      var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
      if let range = range {
            url = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
       
      let urlNew = NSURL(string: url)
        
//      let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
      imageView.setImageWithURL(urlNew!)

      navBar.title = movie["title"] as? String
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
