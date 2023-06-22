//
//  Error.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation
enum MVVMSampleError:Error{
    enum ServerError: String, Error{
        case unauthrozied
        case unknownError
    }
    enum NetworkError:String , Error{
        case requestTimeOut
    }
    public enum JSONError: String, Error {
        case jsonDecodeError
    }
    case serverError(reason: String)
    case jsonError(reason: JSONError)
    case networkError(reason:NetworkError)
}

extension MVVMSampleError.ServerError{
    var failureReason: String {
        let rawValue = self.rawValue
        return rawValue
    }
}

extension MVVMSampleError.NetworkError {
    var failureReason:String{
        let rawValue = self.rawValue
        return rawValue.localised
        }
    }

extension MVVMSampleError.JSONError{
    var failureReason:String{
        let rawValue = self.rawValue
        return rawValue.localised
    }
}
extension MVVMSampleError: LocalizedError {
    
    public var failureReason: String? {
        switch self {
        case .serverError(reason: let reason):
            return reason
        case .jsonError(reason: let reason):
            return reason.failureReason
        case .networkError(reason: let reason):
            return reason.failureReason
        }
    }
}
class Validation {
    func validate(responseData: [String:Any]) -> Error {
        return  createErrorFailure(error: responseData[ErrorConstant.errors])
    }
    /* This method creates error in error format */
    func createErrorFailure(error:Any?) -> Error {
        guard (error != nil) else{
            return (MVVMSampleError.jsonError(reason: .jsonDecodeError))
        }
        if let error = error as? String {
           return  (MVVMSampleError.serverError(reason: error))
        }
        if let error = error as? [String]{
            return  (MVVMSampleError.serverError(reason: error.joined(separator: "\n")))
        }
        if let error = error as? [String:Any]{
            return  (MVVMSampleError.serverError(reason:createDictError(dic: error)))
        }
        return (MVVMSampleError.jsonError(reason: .jsonDecodeError))
    }
    /* Method to handle error in dictionary format */
    func createDictError(dic:[String:Any]) -> String{
        var errorString = ""
        for (_,value) in dic {
            if let value = value as? String {
                errorString += value
            }else if let value = value as? [String] {
                errorString += value.joined(separator: "\n")
            }else if let value = value as? [String:Any] {
                errorString += createDictError(dic: value)
                errorString += "\n"
            }
           
        }
        return errorString
    }
}

