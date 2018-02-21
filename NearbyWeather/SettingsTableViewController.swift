//
//  SettingsTableViewController.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 03.12.16.
//  Copyright © 2016 Erik Maximilian Martens. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("SettingsTVC_NavigationBarTitle", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.styleStandard(withTransluscency: false, animated: true)
        navigationController?.navigationBar.addDropShadow(offSet: CGSize(width: 0, height: 1), radius: 10)
        
        tableView.reloadData()
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "InfoTableViewController") as! InfoTableViewController
            navigationItem.removeTextFromBackBarButton()
            navigationController?.pushViewController(destinationViewController, animated: true)
        case 1:
            break
        case 2:
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "OWMCityFilterTableViewController") as! WeatherLocationSelectionTableViewController

            navigationItem.removeTextFromBackBarButton()
            navigationController?.pushViewController(destinationViewController, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SettingsInputTVC") as! SettingsInputTableViewController
            
            navigationItem.removeTextFromBackBarButton()
            navigationController?.pushViewController(destinationViewController, animated: true)
        case 4:
            PreferencesManager.shared.amountOfResults = AmountOfResults(rawValue: indexPath.row)! // force unwrap -> this should never fail, if it does the app should crash so we know
            tableView.reloadData()
        case 5:
            PreferencesManager.shared.temperatureUnit = TemperatureUnit(rawValue: indexPath.row)! // force unwrap -> this should never fail, if it does the app should crash so we know
            tableView.reloadData()
        case 6:
            PreferencesManager.shared.windspeedUnit = DistanceSpeedUnit(rawValue: indexPath.row)! // force unwrap -> this should never fail, if it does the app should crash so we know
            tableView.reloadData()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("SettingsTVC_SectionTitle0", comment: "")
        case 1:
            return nil
        case 2:
            return NSLocalizedString("SettingsTVC_SectionTitle1", comment: "")
        case 3:
            return NSLocalizedString("SettingsTVC_SectionTitle2", comment: "")
        case 4:
            return NSLocalizedString("SettingsTVC_SectionTitle3", comment: "")
        case 5:
            return NSLocalizedString("SettingsTVC_SectionTitle4", comment: "")
        case 6:
            return NSLocalizedString("SettingsTVC_SectionTitle5", comment: "")
        default:
            return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return AmountOfResults.count
        case 5:
            return TemperatureUnit.count
        case 6:
            return DistanceSpeedUnit.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.contentLabel.text = NSLocalizedString("SettingsTVC_About", comment: "")
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! ToggleCell
            cell.contentLabel.text = NSLocalizedString("SettingsTVC_RefreshOnAppStart", comment: "")
            cell.toggle.isOn = UserDefaults.standard.bool(forKey: kRefreshOnAppStartKey)
            cell.toggleSwitchHandler = { sender in
                UserDefaults.standard.set(sender.isOn, forKey: kRefreshOnAppStartKey)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.contentLabel.text = "\(WeatherDataManager.shared.bookmarkedLocations[indexPath.row].name), \(WeatherDataManager.shared.bookmarkedLocations[indexPath.row].country)"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.contentLabel.text = UserDefaults.standard.value(forKey: kNearbyWeatherApiKeyKey) as? String
            cell.accessoryType = .disclosureIndicator
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            let amountResults = AmountOfResults(rawValue: indexPath.row)! // force unwrap -> this should never fail, if it does the app should crash so we know
            cell.contentLabel.text = "\(amountResults.integerValue) \(NSLocalizedString("SettingsTVC_Results", comment: ""))"
            if amountResults.integerValue == PreferencesManager.shared.amountOfResults.integerValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            let temperatureUnit = TemperatureUnit(rawValue: indexPath.row)! // force unwrap -> this should never fail, if it does the app should crash so we know
            cell.contentLabel.text = temperatureUnit.stringValue
            if temperatureUnit.stringValue == PreferencesManager.shared.temperatureUnit.stringValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            let windspeedUnit = DistanceSpeedUnit(rawValue: indexPath.row)! // force unwrap -> this should never fail, if it does the app should crash so we know
            cell.contentLabel.text = windspeedUnit.stringDescriptor
            if windspeedUnit.stringDescriptor == PreferencesManager.shared.windspeedUnit.stringDescriptor {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
