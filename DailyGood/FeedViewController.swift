//
//  FeedViewController.swift
//  DailyGood
//
//  Created by Kelly Xu on 2/15/15.
//  Copyright (c) 2015 kelly. All rights reserved.
//

import UIKit
import CoreLocation

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var myLocation: String! = ""
    var didFindLoc: Bool = false
    var opportunities: [NSDictionary]! = []
    var isNearby: Bool = true
    var refreshControl: UIRefreshControl!
    var categoryTag: String = ""
    
    @IBOutlet weak var btn_nearby: UIButton!
    @IBOutlet weak var btn_recent: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // needed for table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 400
        
        // location stuff 
        // NB: the call to the API is made from setLocationInfo() when location is updated
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        triggerLocationServices()
        
        // NB: should make sure data is loaded from API again when refreshing....
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // for location stuff -- we only need access to location when app is in use
    // note we also needed to add the NSLocationWhenInUseUsageDescription key-value in info.plist
    func triggerLocationServices() {
        didFindLoc = false
        if CLLocationManager.locationServicesEnabled() {
            if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.startMonitoringSignificantLocationChanges()
            }
        } else {
            var alert = UIAlertView(title: "Location Error", message: "Location services desabled", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       if status == .AuthorizedWhenInUse || status == .Authorized {
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var alert = UIAlertView(title: "Location Error", message: error.localizedDescription, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                var alert = UIAlertView(title: "Location Error", message: error.localizedDescription, delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.useLocationInfo(pm)
            } else {
                var alert = UIAlertView(title: "Location Error", message: "No data received from geocoder", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
    func useLocationInfo(placemark: CLPlacemark!) {
        if didFindLoc {
            return
        }
        if placemark != nil && placemark.locality != nil {
            //stop updating location to save battery life
            didFindLoc = true
            locationManager.stopMonitoringSignificantLocationChanges()
            myLocation = placemark.locality + ", " + placemark.administrativeArea
            if placemark.thoroughfare != nil {
                myLocation = placemark.thoroughfare + ", " + myLocation
                if placemark.subThoroughfare != nil {
                    myLocation = placemark.subThoroughfare + " " + myLocation
                }
            }
            // get data from API
            getVolOpps(myLocation)
        } else {
            var alert = UIAlertView(title: "Location Error", message: "Could not get your city", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // for table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opportunities.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("VolCell") as VolCell
        cell.volOppCharity.text = opportunities[indexPath.row]["sponsoringOrganizationName"] as? String
        cell.volOppLocation.text = opportunities[indexPath.row]["location_name"] as? String
        var tag = opportunities[indexPath.row]["categoryTags"] as [String]
        if tag.count > 0 {
            cell.volOppTag.text = tag[0] as String
        } else {
            //cell.volOppTag.hidden = true
            cell.volOppTag.text = "no tag"
        }
        cell.volOppTitle.text = opportunities[indexPath.row]["title"] as? String
        cell.volOppDescription.text = opportunities[indexPath.row]["description"] as? String
        let startDate = opportunities[indexPath.row]["startDate"] as String
        let when = startDate.componentsSeparatedByString(" ")
        cell.volOppTime.text = when[0] + " at " + when[1]
        
        // for image we use flickr API...
        var query: String
        if tag.count > 0 {
            let tags = tag[0].componentsSeparatedByString(" ")
            query = "&tags=" + "%2C".join(tags)
        } else if let charity = cell.volOppCharity.text {
            let words = charity.componentsSeparatedByString(" ")
            query = "&text=" + "%20".join(words)
        } else {
            return cell
        }
        // license = 7 (no copyright) does not return much, will deal with this later
        // var flickrUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=fc0877fa484b0b38e2d299a5c491c764&tag_mode=any&license=7&safe_search=1&content_type=1&media=photos&format=json&nojsoncallback=1&sort=interestingness&per_page=1"
        var flickrUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=fc0877fa484b0b38e2d299a5c491c764&tag_mode=any&safe_search=1&content_type=1&media=photos&format=json&nojsoncallback=1&sort=interestingness-desc&per_page=1"
        flickrUrl += query
        let request = NSURLRequest(URL: NSURL(string: flickrUrl)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error == nil && data != nil {
                var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                var results = dictionary["photos"] as NSDictionary
                var picList = results["photo"] as [NSDictionary]
                if picList.count > 0 {
                    var pic = picList[0] as NSDictionary
                    var picUrl: String = "https://farm" + toString(pic["farm"]!)
                    picUrl += ".staticflickr.com/" + toString(pic["server"]!)
                    picUrl += "/" + toString(pic["id"]!)
                    picUrl += "_" + toString(pic["secret"]!)
                    picUrl += "_n.jpg"
                    cell.volOppImage.setImageWithURL(NSURL(string: picUrl))
                }
            }
        }
        
        // would be nice to get/set these too...
        // cell.volOppSponsor = .....
        // cell.volOppWhoJoined = .....
        return cell
    }
    
    // for getting data from API
    func getVolOpps(city: String) {
        
        // figure out API URL for desired result sorting
        var  url = "http://api2.allforgood.org/api/volopps?key=YahooGood&output=json-hoc&merge=3"
        if isNearby {
            url += "&sort=geo_distance%20asc"
        } else {
            url += "&sort=eventrangestart%20asc"
        }
        
        // add location to query but escape spaces
        if city.isEmpty == false {
            url += "&vol_loc=" + city.stringByReplacingOccurrencesOfString(" ", withString: "+")
        }
        
        // tag query with proper escaping
        if categoryTag != "" {
            url += "&q=categorytags:" + categoryTag.stringByAddingPercentEncodingForURLQueryValue()!
        }
        println(url)
        
        // call API
        let request = NSURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil || data == nil {
                var alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.opportunities = dictionary["items"] as [NSDictionary]
            }
            
            // be sure to load the table
            if self.opportunities.count > 0 {
                self.tableView.reloadData()
            } else {
                var alert = UIAlertView(title: "Sorry", message: "No opportunities matching location and parameters", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }

            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onTapNearbyBtn(sender: AnyObject) {
        isNearby = true
        btn_nearby.enabled = false
        btn_recent.enabled = true
        triggerLocationServices()
    }
    
    @IBAction func onTapRecentBtn(sender: AnyObject) {
        isNearby = false
        btn_nearby.enabled = true
        btn_recent.enabled = false
        triggerLocationServices()
    }
    
    func onRefresh() {
        triggerLocationServices()
        // delay(0.5) {
        //    self.refreshControl.endRefreshing()
        //}
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
