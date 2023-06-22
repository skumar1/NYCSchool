//
//  AppAPIRegister.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation

enum AppAPIRegister {
    case getHighSchoolList
    case getHighSchoolDetailList
}
extension AppAPIRegister: EndPointType {
   
    var baseURL: URL {
        switch self{
        case .getHighSchoolList:
                guard let url = URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json") else { fatalError("baseURL could not be configured.")}
                return url
        case .getHighSchoolDetailList:
            guard let url = URL(string: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json") else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getHighSchoolList:
                    return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
        case .getHighSchoolDetailList:
                    return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self{
        default:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getHighSchoolList:
            return ""
        case .getHighSchoolDetailList:
            return ""
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .getHighSchoolList:
            return    .get
        case .getHighSchoolDetailList:
            return    .get
        }
    }
}

