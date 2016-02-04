//
//  DetailViewController.swift
//  Flicks
//
//  Created by Nathan Miranda on 2/1/16.
//  Copyright © 2016 Miraen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{
            
            let imageUrl = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
            
            posterImageView.setImageWithURLRequest(
                imageUrl,
                placeholderImage: nil,
                success: { (imageUrl, imageResponse, image) -> Void in
                    
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = image
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            self.posterImageView.alpha = 1.0
                        })
                    }
                    else {
                        //print ("Image was cached so just updated the image")
                        self.posterImageView.image = image
                    }
                },
                failure: { (imageUrl, imageResponse, error) -> Void in
                    print ("Failure to fetch image")
            })
            
        }
        
        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
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
