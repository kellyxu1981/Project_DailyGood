//
//  FeedDetail1ViewController.swift
//  DailyGood
//
//  Created by Kelly Xu on 2/15/15.
//  Copyright (c) 2015 kelly. All rights reserved.
//

import UIKit

class FeedDetail1ViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var checkBtn1: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        scrollView.contentSize = CGSize(width: 320, height: 1284)

        checkBtn1.enabled = true
        
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
                
        }else {
            checkBtn1.selected = false
        }
    }
}