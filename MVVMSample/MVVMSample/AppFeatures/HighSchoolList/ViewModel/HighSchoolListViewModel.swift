//
//  HIghSchoolListViewModel.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation

class HighSchoolListViewModel{
    
    //MARK: - Local Variables
    var delegate: HighSchoolListDelegate
    var manager = HighSchoolListManager()
    var schoolListing :[schoolData]? {
        didSet{
            delegate.tableReload()
        }
    }
    init(delegate: HighSchoolListDelegate){
        self.delegate = delegate
    }
    
    /* This method is used to bind api
     Parameters: SearchString is search textfield text,
     Page is current page index  */
    func getHighSchoolList(){
        self.delegate.showLoader?()
        manager.getHighSchoolListings() { [weak self] (response, error) in
        self?.delegate.hideLoader?()
            if let response = response {
                self?.schoolListing = response
                self?.delegate.success?(response: "")
            } else if let error = error as? MVVMSampleError{
                print(error)
                self?.delegate.error?(Error: error.failureReason)
            }
        }
    }
}
