//
//  HighSchoolListCell.swift
//  MVVMSample
//
//  Created by Mac-0002 on 12/05/23.
//

import UIKit

class HighSchoolListCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var schoolWebsiteLinkLbl: UILabel!
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var schoolCityZipLbl: UILabel!
    @IBOutlet weak var schoolEmailAddressLbl: UILabel!
    @IBOutlet weak var schoolPhoneLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     This method is to set the table view cell data
     parameter:- Listing model is my listings api response model
     */
    func setSchooldata(model: schoolData?){
        schoolNameLbl.text = model?.school_name ?? ""
        schoolCityZipLbl.text = "\(model?.city ?? "") \(model?.zip ?? "")"
        schoolEmailAddressLbl.text = model?.school_email ?? ""
        schoolWebsiteLinkLbl.text = model?.website ?? ""
        schoolPhoneLbl.text = model?.phone_number ?? ""
    }
}
