//
//  SignUp2ViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/14/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import Parse
class SignUp2ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    
    @IBOutlet var myindicator: UIActivityIndicatorView!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var bloodType: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    var sexType : String!
    @IBOutlet var myButton: UIButton!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myindicator.stopAnimating()
        self.age.delegate = self
        self.weight.delegate = self
        self.height.delegate = self
        self.fat.delegate = self
        self.bloodType.delegate = self
        self.phone.delegate = self
        self.email.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func SegmantAction(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex
        
        {
        case 0 :
            return sexType = "Male"
            
        case 1 :
            return sexType = "Female"
            
        default :
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUP(sender: AnyObject) {
        
        self.myindicator.startAnimating()
        self.view.userInteractionEnabled = false
        
        if age.text == nil || weight.text == nil || height.text == nil || fat.text == nil || bloodType.text == nil || sexType == nil || phone.text == nil || email.text == nil {
            
            showAlert("error", message: "please check your input")
        
            self.myindicator.stopAnimating()
            self.view.userInteractionEnabled = true
            
                }else{
            
            
            
            
                    let patientsClass = PFQuery(className: "patients")
                    patientsClass.whereKey("userID", equalTo: "\(PFUser.currentUser()!.objectId!)")
            patientsClass.getFirstObjectInBackgroundWithBlock({ (patient:PFObject?, error:NSError?) -> Void in
                
                if error != nil {
                
                    print(error)
                    
                }else{
                
                    patient!["Age"] = self.age.text!
                    patient!["Height"] = self.height.text!
                    patient!["Weight"] = self.weight.text!
                    patient!["Fat"] = self.fat.text!
                    patient!["BloodType"] = self.bloodType.text!
                    patient!["Sex"] = self.sexType!
                    patient!["Phone"] = self.phone.text!
                    patient!["email"] = self.email.text!
                    patient!["userID"] = PFUser.currentUser()!.objectId!
                    patient!["UserName"] = PFUser.currentUser()!["username"] as! String
                    patient!["doctorID"] = PFUser.currentUser()!["DoctorID"] as! String
                    
                    patient?.saveInBackgroundWithBlock({ (saved:Bool, error:NSError?) -> Void in
                    
                        if saved && error == nil {
                            let user = PFUser.currentUser()
                            user!["Info"] = "True"
                            user?.saveInBackground()
                            self.myindicator.stopAnimating()
                            self.myButton.userInteractionEnabled = true
                            print("updated paitents class")

                        }else{
                        
                            print(error)
                            
                        }

                    })
                }
                
              })
            }
       }
    
    func showAlert(title:String, message:String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActoin = UIAlertAction(title: "Done !!", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            alertView.dismissViewControllerAnimated(true, completion: nil)
            self.myindicator.stopAnimating()
            self.view.userInteractionEnabled = true
        }
        alertView.addAction(alertActoin)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
}