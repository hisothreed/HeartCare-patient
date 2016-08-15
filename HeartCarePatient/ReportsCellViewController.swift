//
//  ReportsCellViewController.swift
//  HeartCarePatient
//
//  Created by Hiso3D on 12/30/15.
//  Copyright © 2015 Hiso3D. All rights reserved.
//

import UIKit

class ReportsCellViewController: UITableViewCell {

    @IBOutlet var statusimage: UIImageView!
    @IBOutlet var HRLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
