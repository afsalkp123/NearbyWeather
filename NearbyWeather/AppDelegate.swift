//
//  AppDelegate.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 03.12.16.
//  Copyright © 2016 Erik Maximilian Martens. All rights reserved.
//

import UIKit
import RxFlow
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - Properties
  
  var window: UIWindow?
  var welcomeWindow: UIWindow?
  
  private var flowCoordinator: FlowCoordinator?
  
  private var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
  
  // MARK: - Functions
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    instantiateServices()
    instantiateApplicationUserInterface()
    
    FirebaseApp.configure()
    
    SettingsBundleTransferService.shared.updateSystemSettings()
    
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    refreshWeatherDataIfNeeded()
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    self.backgroundTaskId = application.beginBackgroundTask { [weak self] in
      self?.endBackgroundTask()
    }
    
    WeatherInformationPersistencyService.shared.updatePreferredBookmark { [weak self] result in
      switch result {
      case .success:
        completionHandler(.newData)
      case .failure:
        completionHandler(.failed)
      }
      self?.endBackgroundTask()
    }
  }
}

// MARK: - Private Helper Functions

extension AppDelegate {
  
  private func instantiateServices() {
    WeatherNetworkingService.instantiateSharedInstance()
    UserLocationService.instantiateSharedInstance()
    PreferencesDataService.instantiateSharedInstance()
    WeatherInformationPersistencyService.instantiateSharedInstance()
    PermissionsService.instantiateSharedInstance()
    BadgeService.instantiateSharedInstance()
  }
  
  private func instantiateApplicationUserInterface() {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    let rootFlow = RootFlow(rootWindow: window)
    
    flowCoordinator = FlowCoordinator()
    flowCoordinator?.coordinate(
      flow: rootFlow,
      with: RootStepper()
    )
  }
  
  private func refreshWeatherDataIfNeeded() {
    if UserDefaults.standard.value(forKey: Constants.Keys.UserDefaults.kNearbyWeatherApiKeyKey) != nil,
      UserDefaults.standard.bool(forKey: Constants.Keys.UserDefaults.kRefreshOnAppStartKey) == true {
      WeatherInformationPersistencyService.shared.update(withCompletionHandler: nil)
    }
  }
  
  private func endBackgroundTask() {
    UIApplication.shared.endBackgroundTask(backgroundTaskId)
    backgroundTaskId = .invalid
  }
}
