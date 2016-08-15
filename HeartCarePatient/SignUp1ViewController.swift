//
//  SignUp1ViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/14/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import Parse
class SignUp1ViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var myindicator: UIActivityIndicatorView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var doctorID: UITextField!
    var imagepicker = UIImagePickerController()
    var image : UIImage!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myindicator.stopAnimating()
        self .userName.delegate = self
        self.password.delegate = self
        self.doctorID.delegate = self
        self.imagepicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
    
        self.myindicator.startAnimating()
        self.view.userInteractionEnabled = false
        
        let user = PFUser()
        
        if image == nil || userName.text == nil || password.text == nil {
        
            showAlert("error", message: "please check yout input")
            
        
        }else{
            
            let doctorsClassQuery = PFQuery(className: "doctors")
            doctorsClassQuery.whereKey("doctorID", equalTo: self.doctorID.text!)
            doctorsClassQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                if objects!.first == nil {
                
                    self.myindicator.stopAnimating()
                    self.showAlert("Error", message: "no such a doctor id in database please check your input")
                    
                }else if objects!.first != nil{
                    user.username = self.userName.text!
                    user.password = self.password.text!
                    user["Info"] = "False"
                    let imageData = UIImageJPEGRepresentation(self.image, 0.9)
                    user["UserImage"] = PFFile(data: imageData!)
                    user["DoctorID"] = self.doctorID.text!
                    user.signUpInBackgroundWithBlock { (done:Bool, error:NSError?) -> Void in
                        
                        if error != nil  {
                            self.myindicator.stopAnimating()
                            
                            self.view.userInteractionEnabled = true
                            
                            self.showAlert("Error", message: "check your internet")
                            
                            
                        }else{
                            
                            self.myindicator.stopAnimating()
                            
                            let patientsClass = PFObject(className: "patients")
                            patientsClass["userID"] = "\(PFUser.currentUser()!.objectId!)"
                            patientsClass["UserImage"] = PFFile(data: imageData!)
                            patientsClass["doctorID"] = "\(self.doctorID.text!)"
                            patientsClass["UserName"] = "\(self.userName!.text!)"
                            patientsClass["FullName"] = "\(self.userName!.text!)"
                            patientsClass.saveInBackgroundWithBlock({ (done:Bool, error:NSError?) -> Void in
                                if error != nil {
                                    
                                    print(error)
                                    
                                    
                                }else{
                                    
                                    print("updated paitents class")
                                }
                                
                            })
                            
                            
                            let signUpViewC : SignUp2ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("signup2") as! SignUp2ViewController
                            
                            self.performSegueWithIdentifier("su", sender: nil)
                            
                            
                        }
                        
                    }
                
                }else if error != nil {
                
                    self.showAlert("Error", message: "please check your internet")
                    
                }
                
            })
            
        }
    }
    
    
    func showAlert(title:String, message:String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActoin = UIAlertAction(title: "Done !!", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            alertView.dismissViewControllerAnimated(true, completion: nil)
            self.view.userInteractionEnabled = true
            self.myindicator.stopAnimating()
        }
        alertView.addAction(alertActoin)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        imagepicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagepicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.image =  info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
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
