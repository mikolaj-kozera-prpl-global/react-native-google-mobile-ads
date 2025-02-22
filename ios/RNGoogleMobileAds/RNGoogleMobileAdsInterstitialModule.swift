/**
 * Copyright (c) 2016-present Invertase Limited & Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this library except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#if !targetEnvironment(macCatalyst)

import Foundation
import GoogleMobileAds

@objc(RNGoogleMobileAdsInterstitialModule)
class RNGoogleMobileAdsInterstitialModule: NSObject {
  let ad = RNGoogleMobileAdsInterstitialAd()
  let gamAd = RNGoogleMobileAdsGAMInterstitialAd()
  
  deinit {
    invalidate()
  }
  
  @objc
  func invalidate() {
    ad.invalidate()
    gamAd.invalidate()
  }
  
  @objc(interstitialLoad:forAdUnitId:withAdRequestOptions:)
  func interstitialLoad(
    requestId: NSNumber,
    adUnitId: String,
    adRequestOptions: Dictionary<String, Any>
  ) {
    if (RNGoogleMobileAdsCommon.isAdManagerUnit(adUnitId)) {
      gamAd.load(
        requestId: requestId.intValue,
        adUnitId: adUnitId,
        adRequestOptions: adRequestOptions
      )
    } else {
      ad.load(
        requestId: requestId.intValue,
        adUnitId: adUnitId,
        adRequestOptions: adRequestOptions
      )
    }
  }
  
  @objc(interstitialShow:forAdUnitId:withShowOptions:withResolve:withReject:)
  func interstitialShow(
    requestId: NSNumber,
    adUnitId: String,
    showOptions: Dictionary<String, Any>,
    resolve: RCTPromiseResolveBlock?,
    reject: RCTPromiseRejectBlock?
  ) {
    if (RNGoogleMobileAdsCommon.isAdManagerUnit(adUnitId)) {
      gamAd.show(
        requestId: requestId.intValue,
        adUnitId: adUnitId,
        showOptions: showOptions,
        resolve: resolve,
        reject: reject
      )
    } else {
      ad.show(
        requestId: requestId.intValue,
        adUnitId: adUnitId,
        showOptions: showOptions,
        resolve: resolve,
        reject: reject
      )
    }
  }
  
  class RNGoogleMobileAdsInterstitialAd: RNGoogleMobileAdsFullScreenAd<GADInterstitialAd> {
    override func getAdEventName() -> String {
      return GOOGLE_MOBILE_ADS_EVENT_INTERSTITIAL
    }
    
    override func loadAd(
      adUnitId: String,
      adRequest: GAMRequest,
      completionHandler: @escaping (GADInterstitialAd?, Error?) -> ()
    ) {
      GADMobileAds.sharedInstance().applicationVolume = 0.0
      GADMobileAds.sharedInstance().applicationMuted = true
      GADInterstitialAd.load(
        withAdUnitID: adUnitId,
        request: adRequest,
        completionHandler: completionHandler
      )
    }
  }
  
  class RNGoogleMobileAdsGAMInterstitialAd: RNGoogleMobileAdsFullScreenAd<GAMInterstitialAd> {
    override func getAdEventName() -> String {
      return GOOGLE_MOBILE_ADS_EVENT_INTERSTITIAL
    }
    
    override func loadAd(
      adUnitId: String,
      adRequest: GAMRequest,
      completionHandler: @escaping (GAMInterstitialAd?, Error?) -> ()
    ) {
      GAMInterstitialAd.load(
        withAdManagerAdUnitID: adUnitId,
        request: adRequest,
        completionHandler: completionHandler
      )
    }
  }
}

#endif
