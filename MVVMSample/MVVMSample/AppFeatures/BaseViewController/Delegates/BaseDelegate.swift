//
//  BaseDelegate.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import UIKit

import Foundation
@objc protocol BaseDelegate: AnyObject {
    @objc optional func error(Error:String?)
    @objc optional func success(response:String)
    @objc optional func showLoader()
    @objc optional func hideLoader()
    
}
