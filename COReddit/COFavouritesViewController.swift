//
//  COFavouritesViewController.swift
//  COReddit
//
//  Created by Matthew Sun on 10/14/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

import UIKit

class COFavouritesViewController: UITableViewController {
    var posts : [CORedditPost]?
    var favourites = [CORedditPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "favourites"
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if let posts = posts {
            for post in posts {
                if (post.isFavourited) {
                    favourites.append(post)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Feed Cell", forIndexPath:indexPath) as! COFeedCell
        
        cell.postImageView.image = nil
        cell.titleLabel.text = nil
        cell.authorLabel.text = nil
        cell.createdLabel.text = nil
        
        let post = favourites[indexPath.row]
        cell.postID = post.postID
        cell.titleLabel.text = post.title
        cell.authorLabel.text = post.author
        cell.heart.hidden = !post.isFavourited
        
        if let imageURLString = post.imageURL, imageURL = NSURL(string: imageURLString) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (data, response, error) in
                if error == nil && data != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if post.postID == cell.postID {
                            cell.postImageView?.image = UIImage(data: data!)
                        }
                    })
                }
            }
            task.resume()
        }
        
        if let created = post.created {
            let createdTimeInterval : NSTimeInterval = (String(created) as NSString).doubleValue
            let createdDate = NSDate(timeIntervalSince1970: createdTimeInterval)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd - hh:mm:ss a"
            cell.createdLabel.text = dateFormatter.stringFromDate(createdDate)
        }
        
        return cell;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    
    
    

}
