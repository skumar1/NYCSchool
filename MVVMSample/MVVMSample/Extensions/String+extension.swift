//
//  String+extension.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation

extension String {
    var localised: String {
        let lang = "en"
        if  let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let langBundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: langBundle, value: "", comment: "")
        } else {
            return self
        }
    }
}
