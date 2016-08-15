//
//  reportsViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/30/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import HealthKit
class reportsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var refreshControl : UIRefreshControl!

    @IBOutlet var myReportsTableView : UITableView!
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
    
    
    
    func refresh(sender:AnyObject){
        
        getHealthData()
        
        myReportsTableView.reloadData()
        
        self.refreshControl.endRefreshing()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myReportsTableView.backgroundColor = UIColor.clearColor()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        myReportsTableView.addSubview(refreshControl)
        getHealthData()
        let cellNib = UINib(nibName: "ReportsCellViewController", bundle: nil)
        myReportsTableView.registerNib(cellNib, forCellReuseIdentifier: "RCELL")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let heartRateQuery = HKSampleQuery(sampleType: self.heartRateQuantitySample!, predicate: predicate, limit: 0, sortDescriptors: [sort]) { (query:HKSampleQuery, sample:[HKSample]?, error:NSError?) -> Void in
            if error != nil {
                
                print(error)
                
            }else{
                
                let results = sample as! [HKQuantitySample]
                var array = [HealthData]()
                for result: HKQuantitySample  in results  {
                    
                    let dateToAdd = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: +3, toDate: result.startDate, options: NSCalendarOptions.WrapComponents)
                    ////////////
                    let quantityString  = "\(result.quantity)"
                    let cutted = quantityString.substringToIndex(quantityString.endIndex.advancedBy(-7))
                    print(cutted)
                    let quantityToCalculate = NSNumberFormatter().numberFromString("\(cutted)")?.doubleValue
                    print(quantityToCalculate)
                    var FinalquantityToAdd = Double()
                    if quantityToCalculate != nil {
                        
                        let quantityToAdd = round(quantityToCalculate! * 60.0)
                        
                        FinalquantityToAdd = quantityToAdd
                        
                    }
                    
                    
                    array.append(HealthData(heartRate: "\(FinalquantityToAdd)" + "bpm", Date: "\(dateToAdd!)"))
                    
                    ////////////
                }
                
                self.healthDataArray = array
                self.myReportsTableView.reloadData()
            }
        }
        healthStore.executeQuery(heartRateQuery)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell: ReportsCellViewController = tableView.dequeueReusableCellWithIdentifier("RCELL", forIndexPath: indexPath) as! ReportsCellViewController
        cell.backgroundColor = UIColor.clearColor()
        if healthDataArray[indexPath.row].heartRate > "\(80...120)bpm" {
        cell.statusimage.image = UIImage(named: "safe")
            
        cell.HRLabel.text = healthDataArray[indexPath.row].heartRate
        cell.dateLabel.text = healthDataArray[indexPath.row].Date
        print(healthDataArray)
        }else{
        
            cell.statusimage.image = UIImage(named: "notsafe")
            
            cell.HRLabel.text = healthDataArray[indexPath.row].heartRate
            cell.dateLabel.text = healthDataArray[indexPath.row].Date
            print(healthDataArray)
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthDataArray.count
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
