//
//  HighSchoolListManager.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation
class HighSchoolListManager{
    let router = Router<AppAPIRegister>()
    /* This method is used to get my listings api response*/
    func getHighSchoolListings(completion: @escaping ([schoolData]?,Error?)->(Void)){
        router.request(.getHighSchoolList, responseClass: [schoolData].self) { result in
            switch result {
            case .success(let responseModel):
                completion(responseModel,nil)
            case .failure(let error):
                completion(nil,error)
                
            }
        }
    }
}
