//
//  HighSchoolDetailManager.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation
class HighSchoolDetailManager{
    let router = Router<AppAPIRegister>()
    /* This method is used to get my listings api response*/
//    func getHighSchoolListings(completion: @escaping ([schoolData]?,Error?)->(Void)){
//        router.request(.getHighSchoolList, responseClass: [schoolData].self) { result in
//            switch result {
//            case .success(let responseModel):
//                completion(responseModel,nil)
//            case .failure(let error):
//                completion(nil,error)
//
//            }
//        }
//    }
    func getHighSchoolDetail(completion: @escaping([HighSchoolDetailData]?,Error?)->Void){
        router.request(.getHighSchoolDetailList, responseClass: [HighSchoolDetailData].self) { result in
            switch result{
                case .success(let responseModel):
                    completion(responseModel,nil)
                case .failure(let error):
                    completion(nil,error)
            }
        }
        
    }
}
