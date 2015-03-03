//
//  FeedDetailViewController.swift
//  DailyGood
//
//  Created by Kelly Xu on 2/15/15.
//  Copyright (c) 2015 kelly. All rights reserved.
//

import UIKit
import MapKit

class FeedDetailViewController: UIViewController, UIActionSheetDelegate, MKMapViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var checkBtn1: UIButton!
    @IBOutlet weak var charityImage: UIImageView!
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var oppTitle: UILabel!
    @IBOutlet weak var oppDescription: UITextView!
    @IBOutlet weak var fromWhen: UILabel!
    @IBOutlet weak var untilWhen: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var selection = NSDictionary() // all data from API here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 320, height: 894)

        // FILL DATA
        charityImage.setImageWithURL(NSURL(string: selection["imageURL"] as String))
        charityName.text = selection["sponsoringOrganizationName"] as? String
        oppTitle.text = selection["title"] as? String
        oppDescription.text = selection["description"] as? String
        address.text = selection["location_name"] as? String
        // format date and time....
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateString = selection["startDate"] as? String
        let dateFrom = dateFormatter.dateFromString(dateString!)
        dateString = selection["endDate"] as? String
        let dateTo = dateFormatter.dateFromString(dateString!)
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        fromWhen.text = "From " + dateFormatter.stringFromDate(dateFrom!)
        untilWhen.text = "Until " + dateFormatter.stringFromDate(dateTo!)
        
        // ToDo:
        // mp with directions from current location to selection["latlong"]
        // add tags from selection["categoryTags"] as? [String]
        // Could add WebView for selection["detailUrl"]
        // Should so something with sponsorhip/ad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapBackBtn(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func onCheckBtn(sender: AnyObject) {
            checkBtn1.selected = true
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "CONFIRMED")
            actionSheet.showInView(view)
    }

    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){
        if (buttonIndex == 0){
            checkBtn1.selected = true
        } else {
            checkBtn1.selected = false
        }
    }
}