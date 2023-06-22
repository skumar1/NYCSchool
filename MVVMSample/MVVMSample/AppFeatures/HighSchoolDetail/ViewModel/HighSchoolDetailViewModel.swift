//
//  HighSchoolDetailViewModel.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation

class HighSchoolDetiailViewModel{
    
    //MARK: - Local Variables
    var delegate: HighSchoolDetailDelegates
    var manager = HighSchoolDetailManager()
    private let shcoolDataObj: schoolData
    var detailData :HighSchoolDetailData? {
        didSet{
            delegate.updateDetails()
        }
    }
    
    init(delegate: HighSchoolDetailDelegates, data: schoolData){
        self.delegate = delegate
        shcoolDataObj = data
    }
    
    /* This method is used to bind api for detail page*/
    func getHighSchoolDetailList(){
        self.delegate.showLoader?()
        manager.getHighSchoolDetail() { [weak self] (response, error) in
        self?.delegate.hideLoader?()
            if let response = response {
                if let detailObj = self?.filterArrayWithSchoolID(array: response){
                    self?.detailData = detailObj
                    self?.delegate.success?(response: "")
                }
            } else if let error = error as? MVVMSampleError{
                print(error)
                self?.delegate.error?(Error: error.failureReason)
            }
        }
    }
    
    /*This method is used to get the detail of particular highschool*/
    func filterArrayWithSchoolID(array:[HighSchoolDetailData]) -> HighSchoolDetailData? {
        
        let filteredArray = array.filter { (obj) -> Bool in
            return obj.dbn == shcoolDataObj.dbn
        }
        
        if let foundObject = filteredArray.first {
            print("Found object with id \(foundObject.dbn): \(foundObject.school_name)")
            return foundObject
        } else {
            print("No object found with id \(shcoolDataObj.dbn)")
            return nil
        }
    }
}
