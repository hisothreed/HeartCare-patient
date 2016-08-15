//
//  MainPageViewController.swift
//  HeartCarePatient
//
//  Created by emergancy on 12/11/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import HealthKit
import Parse
class MainPageViewController: UIViewController{

    @IBOutlet var menuButoon: UIButton!
    /////
   
    //////// health kit stuff
    var heartRateQuantitySample = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
    
    var typesToRead : NSSet {
    
        return NSSet(object: self.heartRateQuantitySample!)
    }
    
    var healthStore = HKHealthStore()
    struct  HealthData {
        var heartRate : String!
        var Date : String!
    }
    
    var healthDataArray = [HealthData]()
    /////
    
    /////// main ui
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var doctorNotes: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    var doctorId : String!
    
    /// views
    @IBOutlet weak var MainView: UIView!
    
    //////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
           menuButoon.addTarget(revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
       // setting images radius

        
        //// health kit stuff
        var token : dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            
            self.checkForHealthData()
        }
        /////
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() == nil {
        
            let signUpViewC : SignUpViewController = storyboard?.instantiateViewControllerWithIdentifier("SignView") as! SignUpViewController
            self.presentViewController(signUpViewC, animated: true, completion: nil)
        }else if PFUser.currentUser()!["Info"] as! String == "False"{
        
            let SignUpView : SignUp2ViewController = storyboard?.instantiateViewControllerWithIdentifier("signup2") as! SignUp2ViewController
            self.presentViewController(SignUpView, animated: true, completion: nil)
            
        
        }else if PFUser.currentUser() != nil || PFUser.currentUser()!["Info"] as! String != "False" {
        
            self.getUserInfo()
            
        
        }else{
        
            let setting = UIApplication.sharedApplication().currentUserNotificationSettings()
            if setting!.types == .None {
                
                showNotificationP()
                
            }

            
        }
        
    
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImageRad(image:UIImageView) {
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
        
    }

    @IBAction func uploadFunc(sender: AnyObject) {
        
        getHealthData()
        
        showAlert("Upload Complete !!", message: "Your Reports Has Been Uploaded .. waiting for your doctor review")
        
    }
    
    
    
    func showAlert(title:String, message:String) {
    
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActoin = UIAlertAction(title: "Done !!", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
        alertView.addAction(alertActoin)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    func checkForHealthData (){
    
        if HKHealthStore.isHealthDataAvailable() {
        
            self.healthStore.requestAuthorizationToShareTypes(nil, readTypes: self.typesToRead as? Set<HKObjectType>, completion: { (done:Bool, error:NSError?) -> Void in
                
                if (error != nil) {
                
                    print(error)
                    
                }else{
                
                    print("done got health data")
                    
                }
                
            })
            
        }
        
    }
    
    func getHealthData() {
        
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.minute = 00
        components.hour = 00
        components.day = calender.component(.Day, fromDate: NSDate())
        print(components)
        components.month = calender.component(.Month, fromDate: NSDate())
        components.year = calender.component(.Year, fromDate: NSDate())
        let startdate = calender.dateFromComponents(components)
        
        let calender2 = NSCalendar.currentCalendar()
        let components2 = NSDateComponents()
        components2.minute = 59
        components2.hour = 23
        components2.day = calender2.component(.Day, fromDate: NSDate())
        print(components2)
        components2.month = calender2.component(.Month, fromDate: NSDate())
        components2.year = calender2.component(.Year, fromDate: NSDate())
        let Enddate = calender.dateFromComponents(components2)
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startdate, endDate: Enddate, options: .None)
        
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        let heartRateQuery = HKSampleQuery(sampleType: self.heartRateQuantitySample!, predicate: predicate, limit: 0, sortDescriptors: [sort]) { (query:HKSampleQuery, sample:[HKSample]?, error:NSError?) -> Void in
            print(sample)
            if error != nil {
                
                print(error)
                
            }else{
                
                let results = sample as! [HKQuantitySample]
                var array = [HealthData]()
                for result: HKQuantitySample  in results  {
                    
                    
                    let dateToAdd = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: +3, toDate: result.startDate, options: NSCalendarOptions.WrapComponents)
                    ////////////
                    let  quantityString  = "\(result.quantity)"
                    print(quantityString)
                    let cutted = quantityString.substringToIndex(quantityString.endIndex.advancedBy(-7))
                    let quantityToCalculate = NSNumberFormatter().numberFromString("\(cutted)")?.doubleValue
                    var FinalquantityToAdd = Double()
                    if quantityToCalculate != nil {
                        
                        let quantityToAdd = round(quantityToCalculate! * 60)
                        FinalquantityToAdd = quantityToAdd
                        
                    }
                    
                    array.append(HealthData(heartRate: "\(FinalquantityToAdd)" + "bpm", Date: "\(dateToAdd!)"))
                    
                    ////////////
                }
                
                self.healthDataArray = array
                self.deleteParseReports()
                self.uploadToParse()
            }
        }
        healthStore.executeQuery(heartRateQuery)
        
    }

    func uploadToParse() {
        
        for object in healthDataArray {
            
            let Reports = PFObject(className: "Reports")
            Reports["userID"] = "\(PFUser.currentUser()!.objectId!)"
            Reports["doctorID"] = "\(doctorId!)"
            Reports["HeartRate"] = object.heartRate
            Reports["Date"] = object.Date
            Reports.saveInBackgroundWithBlock { (done:Bool, error:NSError?) -> Void in
                
                
                if done {
                    
                    print("uploaded")
                    
                }else{
                    
                    print(error)
                }
                
            }
        }
        
    }
    ///////
    func getUserInfo(){
        
        self.userIdLabel.text = "ID :" + "\(PFUser.currentUser()!.objectId!)"
        
        // getting user info to put in ui
        self.userNameLabel.text = PFUser.currentUser()?.username!
        let userimageQuery = PFQuery(className: "patients")
        let id =  "\(PFUser.currentUser()!.objectId!)"
        userimageQuery.whereKey("userID", equalTo: id)
        userimageQuery.getFirstObjectInBackgroundWithBlock({ (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil {
                
                print(error)
                
            }else{
                
                self.doctorId = object!["doctorID"] as! String
                
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
            
        })
        // getting notes/status
        let query = PFQuery(className: "patients")
        query.whereKey("userID", equalTo: "\(PFUser.currentUser()!.objectId!)")
        query.getFirstObjectInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
            
            if object!["userStatus"] != nil {
                self.statusLabel.text = object!["userStatus"] as? String
                if self.statusLabel.text == "Normal" {
                    
                    self.statusLabel.textColor = UIColor.greenColor()
                }else{
                    
                    self.statusLabel.textColor = UIColor.redColor()
                    
                }
            }else{
                
                self.statusLabel.text = "Not Yet Being Recognized"
            }
            if object!["DoctorNotes"] != nil {
                self.doctorNotes.text = object!["DoctorNotes"] as? String
            }else{
                
                self.doctorNotes.text = " "
                
            }
            
        }
        
    }
    
    
    func showNotificationP () {
        
        let NotificationSetting = UIUserNotificationSettings(forTypes: [.Alert,.Badge,.Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(NotificationSetting)
        self.setNotificationScheduled()
        
    }
    func setNotificationScheduled () {
        
        
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.minute = calender.component(.Minute, fromDate: NSDate()) + 1
        components.hour = calender.component(.Hour, fromDate: NSDate())
        components.day = calender.component(.Day, fromDate: NSDate())
        components.month = calender.component(.Month, fromDate: NSDate())
        components.year = calender.component(.Year, fromDate: NSDate())
        calender.timeZone = NSTimeZone.defaultTimeZone()
        let fireDate = calender.dateFromComponents(components)
        
        let notification = UILocalNotification()
        notification.fireDate = fireDate!
        notification.repeatInterval = NSCalendarUnit.Day
        notification.alertBody = "Reminding You To Send Reports To Your Doctor (-;"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["test": "test"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print(notification)
    }


    func deleteParseReports(){
    
        let reports = PFQuery(className: "Reports")
        reports.whereKey("userID", equalTo: "\(PFUser.currentUser()!.objectId!)")
        reports.findObjectsInBackgroundWithBlock { ( objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil && objects?.isEmpty == false {
                for object in objects! {
            object.deleteEventually()
                }
            }
        }
    }
    
    
}
