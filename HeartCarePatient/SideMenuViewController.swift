//
//  SideMenuViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/11/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import Parse
class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

   @IBOutlet var profileImage : UIImageView!
    
    var cellArray = [cellData]()
    struct cellData {
        var cellImage : UIImage!
        var cellText : String!
    }
    
    
    @IBOutlet var MyTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        cellArray.append(cellData(cellImage: UIImage(named: "Profile"), cellText: "Profile"))
        cellArray.append(cellData(cellImage: UIImage(named: "Doctor"), cellText: "Doctor Info"))
        cellArray.append(cellData(cellImage: UIImage(named: "logout"), cellText: "LogOut"))
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if PFUser.currentUser() != nil {
        
        let imageFile = PFUser.currentUser()!["UserImage"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({ (imagedata:NSData?, error:NSError?) -> Void in
            if error != nil {
                print(error)
                
            }else{
                
                
                self.profileImage.image = UIImage(data: imagedata!)
                self.setImageRad(self.profileImage)
                
            }
        })

        }
       
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
       MyTable.backgroundColor = UIColor.clearColor()
       cell.backgroundColor = UIColor.clearColor()
       cell.textLabel?.text = cellArray[indexPath.row].cellText
        cell.imageView?.image = cellArray[indexPath.row].cellImage
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
        
            self.logOut()
            print("logedout")
            
        }else if indexPath.row == 0 {
        
            self.performSegueWithIdentifier("Pro", sender: nil)
        }
    }
    
    func logOut (){
    
        PFUser.logOut()

        let SignUpMain : SignUpViewController = storyboard?.instantiateViewControllerWithIdentifier("SignView") as! SignUpViewController
        self.presentViewController(SignUpMain, animated: true, completion: nil)
        
    }
    
    func setImageRad(image:UIImageView) {
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
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
