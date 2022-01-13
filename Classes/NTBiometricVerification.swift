//
//  FFBiometricVerification.swift
//  FFBiometricVerificationFramework
//
//  Created by Naveed Tahir on 13/01/2022.
//

import Foundation
import LocalAuthentication
import UIKit

public class NTBiometricVerification{
    
    public static func Authenticate(completion: @escaping ((Bool,String) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { (success, error) -> Void in
                    if(success) {
                        // Touch / Face ID recognized success here
                        DispatchQueue.main.async {
                            completion(true, "")
                        }
                        
                    } else {
                        //If not recognized then
                        DispatchQueue.main.async {
                            completion(false, "")
                        }
                    }
                })
        } else {
            let strMessage = errorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                completion(false, strMessage)
            }
        }
    }
    
    public static func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        if #available(iOS 11.0, *) {
            switch errorCode {
                
            case LAError.Code.authenticationFailed.rawValue:
                strMessage = "Authentication Failed"
                
            case LAError.Code.userCancel.rawValue:
                strMessage = "User Cancel"
                
            case LAError.Code.systemCancel.rawValue:
                strMessage = "System Cancel"
                
            case LAError.Code.passcodeNotSet.rawValue:
                strMessage = "Please goto the Settings & Turn On Passcode"
                
            case LAError.Code.biometryNotAvailable.rawValue:
                strMessage = "TouchI or FaceID DNot Available"
                
            case LAError.Code.biometryNotEnrolled.rawValue:
                strMessage = "TouchID or FaceID Not Enrolled"
                
            case LAError.Code.biometryLockout.rawValue:
                strMessage = "TouchID or FaceID Lockout Please goto the Settings & Turn On Passcode"
                
            case LAError.Code.appCancel.rawValue:
                strMessage = "App Cancel"
                
            case LAError.Code.invalidContext.rawValue:
                strMessage = "Invalid Context"
                
            default:
                strMessage = ""
                
            }
        } else {
            // Fallback on earlier versions
        }
        return strMessage
    }
    
}
