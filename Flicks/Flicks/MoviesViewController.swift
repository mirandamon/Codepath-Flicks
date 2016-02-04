//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Nathan Miranda on 1/5/16.
//  Copyright © 2016 Miraen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        loadDataFromNetwork()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDataFromNetwork() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = self.movies
                            self.collectionView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        }
        else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.miraen.MovieCell", forIndexPath: indexPath) as! MovieCellCollection
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w45"
        let highResBaseUrl = "https://image.tmdb.org/t/p/original"
        if let posterPath = movie["poster_path"] as? String{
            
            let imageUrl = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
            let highResImageUrl = NSURLRequest(URL: NSURL(string: highResBaseUrl + posterPath)!)
            
            cell.posterImageView.setImageWithURLRequest(
                imageUrl,
                placeholderImage: nil,
                success: { (imageUrl, imageResponse, image) -> Void in
                    cell.posterImageView.alpha = 0.0
                    cell.posterImageView.image = image
                    UIView.animateWithDuration(0.3, animations: {() -> Void in
                        cell.posterImageView.alpha = 1.0
                        },
                            completion: {(success) -> Void in
                                cell.posterImageView.setImageWithURLRequest(highResImageUrl,
                                    placeholderImage: image,
                                    success: { (highresImageUrl, highResImageResponse, highResImage) -> Void in
                                        if highResImageResponse != nil {
                                            cell.posterImageView.image = highResImage
                                        }
                                        else {
                                            cell.posterImageView.image = highResImage
                                        }
                                    },
                                    failure: {(request, response, error) -> Void in
                                    })
                            })
                    
                },
                failure: { (imageUrl, imageResponse, error) -> Void in
                    print ("Failure to fetch image")
            })

        }
        return cell
        
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = movies
        }
        else {
            filteredData = movies?.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        return true
                    }
                    else {
                        return false
                    }
                }
                return false
            })
        }
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
