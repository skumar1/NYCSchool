//
//  BaseViewModel.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation
class BaseViewModel {
    //MARK: - Local variables
    var delegate:BaseDelegate!
    
    init(delegate:BaseDelegate){
        self.delegate = delegate
    }
}
