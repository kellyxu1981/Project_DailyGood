//
//  FeedViewController.swift
//  DailyGood
//
//  Created by Kelly Xu on 2/15/15.
//  Copyright (c) 2015 kelly. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollView2: UIScrollView!
    @IBOutlet weak var btn_nearby: UIButton!
    @IBOutlet weak var btn_recent: UIButton!
    
    var isNearby: Bool = true
    var refreshControl: UIRefreshControl!
    var refreshControl2: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn_nearby.alpha = 1
        btn_recent.alpha = 0.5
        scrollView.alpha = 1
        scrollView2.alpha = 0
        
        
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        refreshControl2 = UIRefreshControl()
        refreshControl2.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        scrollView.insertSubview(refreshControl, atIndex: 0)
        scrollView2.insertSubview(refreshControl2, atIndex: 0)
        
        scrollView.contentSize = CGSize(width: 320, height: 1284)
        scrollView2.contentSize = CGSize(width: 320, height: 1325)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapNearbyBtn(sender: AnyObject) {
            viewSwitchToNearby()
    }
    
    @IBAction func onTapRecentBtn(sender: AnyObject) {
            viewSwitchToRecent()
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
        delay(0.5, closure: {
            self.refreshControl.endRefreshing()
            self.refreshControl2.endRefreshing()
        })
    }
    
    func viewSwitchToNearby(){
            scrollView.alpha = 1
            scrollView2.alpha = 0
            btn_nearby.alpha = 1
            btn_recent.alpha = 0.5
            isNearby = false
    }
    
    func viewSwitchToRecent(){
        scrollView.alpha = 0
        scrollView2.alpha = 1
        btn_nearby.alpha = 0.5
        btn_recent.alpha = 1
        isNearby = true
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
