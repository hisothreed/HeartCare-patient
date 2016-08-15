//
//  profileViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/21/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import Parse
class profileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var picView: UIImageView!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var bloodType: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    var imagepicker = UIImagePickerController()
    @IBOutlet var myButton: UIButton!
    @IBOutlet var myindicator: UIActivityIndicatorView!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.age.delegate = self
        self.weight.delegate = self
        self.height.delegate = self
        self.fat.delegate = self
        self.bloodType.delegate = self
        self.phone.delegate = self
        self.email.delegate = self
        myindicator.stopAnimating()
        imagepicker.delegate = self
    
        getUserInfo()
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
    @IBAction func updatePic(sender: AnyObject) {
        
        imagepicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagepicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.picView.image =  info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        updateImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        
        
        
    }
    func getUserInfo (){
    
        self.nameLabel.text = PFUser.currentUser()!.username!
        let userimageQuery = PFQuery(className: "patients")
        let id =  "\(PFUser.currentUser()!.objectId!)"
        userimageQuery.whereKey("userID", equalTo: id)
        userimageQuery.getFirstObjectInBackgroundWithBlock({ (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil {
                
                print(error)
                
            }else{
                
                self.age.text! = object!["Age"] as! String
                self.height.text! = object!["Height"] as! String
                self.weight.text! = object!["Weight"] as! String
                self.fat.text! = object!["Fat"] as! String
                self.bloodType.text! = object!["BloodType"] as! String
                self.phone.text! = object!["Phone"] as! String
                self.email.text! = object!["email"] as! String
                
                
                let imageFile = PFUser.currentUser()!["UserImage"] as! PFFile
                imageFile.getDataInBackgroundWithBlock({ (imagedata:NSData?, error:NSError?) -> Void in
                    if error != nil {
                        print(error)
                        
                    }else{
                        self.picView.image = UIImage(data: imagedata!)
                        
                        
                        
                    }
                })
                
            }
            
        })

        
        
    }
    
    func updateImage(image: UIImage) {
    
        myindicator.startAnimating()
        
        let user = PFUser.currentUser()
        let imagedata = UIImageJPEGRepresentation(image, 0.9)
        user!["UserImage"] = PFFile(data: imagedata!)
        user?.saveInBackgroundWithBlock({ (saved:Bool, error:NSError?) -> Void in
            
            
            if error != nil {
            
                print(error)
            self.showAlert("error", message: "check your internet")
            self.myindicator.stopAnimating()
                
            }else{
                let patientsClass = PFObject(className: "patients")
                patientsClass["UserImage"] = PFFile(data: imagedata!)
                patientsClass.saveInBackgroundWithBlock({ (done:Bool, error:NSError?) -> Void in
                    if error != nil {
                        self.myindicator.stopAnimating()
                        print(error)
                    }else{
                        self.myindicator.stopAnimating()
                       print("updated image")
                    }
                    
                })
                
            }
            
        })
        
    }

    @IBAction func updateInfo(sender: AnyObject) {
        
        self.myButton.userInteractionEnabled = false
        
        if age.text == nil || weight.text == nil || height.text == nil || fat.text == nil || bloodType.text == nil || phone.text == nil || email.text == nil {
            
            
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
                patient!["Phone"] = self.phone.text!
                patient!["email"] = self.email.text!
                
                patient?.saveInBackground()
         
            }
          })
            
         
       }
    }
    
    func showAlert(title:String, message:String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActoin = UIAlertAction(title: "Done !!", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            alertView.dismissViewControllerAnimated(true, completion: nil)
            self.view.userInteractionEnabled = true
        }
        alertView.addAction(alertActoin)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }

}
