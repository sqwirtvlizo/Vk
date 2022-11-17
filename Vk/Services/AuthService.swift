//
//  AuthService.swift
//  Vk
//
//  Created by Евгений Кононенко on 17.11.2022.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    var token: String? {
        return VKSdk.accessToken().accessToken
    }
    private let appId = "51478899"
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
  
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall", "friends"]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
                delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
            } else {
                print("auth problems, state \(state) error \(String(describing: error))")
                delegate?.authServiceInDidFail()
            }
        }
    }
    
    // MARK: VKSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    // MARK: VkSdkUIDelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
