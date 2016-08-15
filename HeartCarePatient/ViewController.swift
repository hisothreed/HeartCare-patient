//
//  ViewController.swift
//  HeartCarePatient
//
//  Created by emergancy on 12/10/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var menuview : UIView!
    
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var Myview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       // UIView.animateWithDuration(4) { () -> Void in
           
         //   self.menuview.center.x = self.menuview.center.x + self.menuview.frame.width
        //}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slideMenu(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                
                self.Myview.center.x = self.Myview.center.x + 200
                
                
            })
        }
        
    }

}

