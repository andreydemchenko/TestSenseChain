//
//  FirebaseAnalyticsManager.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 15.12.2022.
//

import FirebaseAnalytics
import Foundation

class FirebaseAnalyticsManager {
    
    func screenPostJobContractClicked() {
        FirebaseAnalytics.Analytics.logEvent("post_contract_screen_viewed", parameters: [
          AnalyticsParameterScreenName: "post_contract_view"
        ])
    }
    
    func screenJobContractsClicked() {
        FirebaseAnalytics.Analytics.logEvent("job_contracts_screen_viewed", parameters: [
          AnalyticsParameterScreenName: "job_contracts_view",
          "isButtonJobContractsClicked": true
        ])
    }
    
    func screenSignOutClicked() {
        FirebaseAnalytics.Analytics.logEvent("signout_screen_viewed", parameters: [
          AnalyticsParameterScreenName: "signout_view",
          "isButtonSignOutClicked": true
        ])
    }
    
    func reviewJobContractClicked(contract: CreateContractJobModel) {
        FirebaseAnalytics.Analytics.logEvent("review_post_contract_screen_viewed", parameters: [
          AnalyticsParameterScreenName: "review_post_contract_view",
          "contractName": contract.name,
          "type": contract.businessType,
          "description": contract.description,
          "startDate": contract.startDate,
          "deadline": contract.deadline,
          "hours": contract.hours,
          "minutes": contract.minutes,
          "price": contract.price
        ])
    }
    
}
