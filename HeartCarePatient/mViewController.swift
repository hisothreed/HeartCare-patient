//
//  mViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/31/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
class mViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        revealViewController().rearViewRevealWidth = 260
        if revealViewController() != nil {
          
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
