//
//  NSErrorExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/6/21.
//

import Foundation

private let errorKeyTitle = "title"
private let errorKeyConfirmTitle = "confirmTitle"
private let errorKeyAdditionalData = "additionalData"
private let isAppLaunchedOnceKey = "isAppAlreadyLaunchedOnce"

let ErrorKeyAdditionalDataURL = "url"
let ErrorKeyAdditionalDataID = "id"

extension NSError {
    
    var title: String {
        if self is DecodingError {
            return "Decoding Error" + "\n"
        }
        
        var title = self.userInfo[errorKeyTitle] as? String ?? ""
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            title = Strings.Error.generalTechnicalFailureTitle + "\n"
        }
        return title
    }
    
    var message: String {
        return "\n" + self.localizedDescription + " (\(self.code))" + "\n\n"
    }
    
    var confirmTitle: String {
        var confirmTitle = self.userInfo[errorKeyConfirmTitle] as? String ?? ""
        if confirmTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            confirmTitle = Strings.Error.genericConfirmTitle
        }
        return confirmTitle
    }
    
    var additionalData: [String: Any] {
        return userInfo[errorKeyAdditionalData] as? [String: Any] ?? [:]
    }
    
    var endpoint: String? {
        return additionalData[ErrorKeyAdditionalDataURL] as? String
    }
}
