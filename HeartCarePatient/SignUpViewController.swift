//
//  SignUpViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/12/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit
import Parse
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var UserName: UITextField!
    @IBOutlet var PassWord: UITextField!
    @IBOutlet var myindicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myindicator.stopAnimating()
        UserName.delegate = self
        PassWord.delegate = self
        // Do any additional setup after loading the view.
    
    
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogIn(sender: AnyObject) {
        myindicator.startAnimating()
        PFUser.logInWithUsernameInBackground(UserName.text!, password: PassWord.text!) { (user:PFUser?, error:NSError?) -> Void in
            
            if error != nil {
                self.myindicator.stopAnimating()
                print(error)
                
                self.showAlert("Error", message: "Check your input")
                
                
            }else{
                
                print("done with userData \(user)")
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
    }

        
        
    
    
    
    func showAlert(title:String, message:String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActoin = UIAlertAction(title: "Done !!", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
        alertView.addAction(alertActoin)
        self.presentViewController(alertView, animated: true, completion: nil)
        
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
