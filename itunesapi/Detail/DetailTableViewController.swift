//
//  DetailTableViewController.swift
//  itunesapi
//
//  Created by sunhaeng Heo on 2018. 5. 29..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit
import SafariServices

class DetailTableViewController: UITableViewController, UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageCache.clear()
    }
    
    var expandReleaseNotes: Bool = false {
        didSet {
            if expandReleaseNotes != oldValue {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableViewRowAnimation.fade)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    var expandDescription: Bool = false {
        didSet {
            if expandDescription != oldValue {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: UITableViewRowAnimation.fade)
                    self.tableView.endUpdates()
                }
            }
        }
    }

    // MARK: -
    var rank: (String, Int) = ("", 0)
    var appData: AppData?
    func load(_ appId: String) {
        HTTP.detailRequest(appId: appId) { [weak self](appData, error) in
            guard appData != nil && error == nil else {
                return
            }
            
            self?.appData = appData
            
            DispatchQueue.main.async {
                self?.title = self?.appData?.trackName
                self?.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard appData != nil else {
            return 0
        }
        
        switch section {
        case 0, 2, 3, 4:
            return 1
        case 1:
            return appData?.releaseNotes != nil ? 1 : 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "section\(indexPath.section)", for: indexPath) as! DetailTableViewCell
        switch indexPath.section {
        case 0:
            cell.labels?[0].text = "\(appData?.averageUserRating ?? 0)"
            cell.labels?[1].text = "#\(rank.1)"
            cell.labels?[2].text = appData?.trackContentRating
            cell.labels?[3].text = (appData?.userRatingCount.roughFormat() ?? "") + "개의 평가"
            break
        case 1:
            cell.titleLabel?.text = "새로운 기능"
            cell.labels?[0].text = "버전 \(appData?.version ?? "")"
            cell.labels?[1].text = appData?.currentVersionReleaseDate.dateValue?.sinceNowString()
            if let label = cell.labels?[2], let attributedText = appData?.releaseNotes?.attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9) {
                
                label.attributedText = attributedText
                
                if expandReleaseNotes {
                    cell.expandButton?.isHidden = true
                    cell.expandAction = nil
                } else {
                    let size = attributedText.boundingRect(with: CGSize(width: label.frame.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                    
                    if size.height <= 75 {
                        cell.expandButton?.isHidden = true
                        cell.expandAction = nil
                    } else {
                        label.attributedText = appData?.releaseNotes?.removeWhiteLine().attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9)
                        cell.expandButton?.isHidden = false
                        cell.expandAction = { [weak self](button) in
                            self?.expandReleaseNotes = true
                        }
                    }
                }
            }
            break
        case 2:
            cell.titleLabel?.text = "미리보기"
            break
        case 3:
            if let label = cell.labels?[0], let attributedText = appData?.description.attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9) {
                label.attributedText = attributedText
                
                if expandDescription {
                    cell.expandButton?.isHidden = true
                    cell.expandAction = nil
                } else {
                    let size = attributedText.boundingRect(with: CGSize(width: label.frame.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                    
                    if size.height <= 75 {
                        cell.expandButton?.isHidden = true
                        cell.expandAction = nil
                    } else {
                        label.attributedText = appData?.description.removeWhiteLine().attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9)
                        cell.expandButton?.isHidden = false
                        cell.expandAction = { [weak self](button) in
                            self?.expandDescription = true
                        }
                    }
                }
            }
            cell.labels?[1].text = appData?.artistName
            
            
            break
        case 4:
            cell.titleLabel?.text = "정보"
            cell.labels?[0].text = appData?.sellerName
            cell.labels?[1].text = appData?.genres[0]
            cell.labels?[2].text = appData?.trackContentRating
            
            if let infoCell = cell as? DetailTableViewInfoCell {
                infoCell.webLink = appData?.sellerUrl
                infoCell.clickAction = { [weak self](url) in
                    let safari = SFSafariViewController(url: url)
                    self?.present(safari, animated: true, completion: nil)
                }
            }
            break
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 167
        case 2:
            return 500
        case 3:
            return 195
        case 4:
            return appData?.sellerUrl != nil ? 280 : 230
        default:
            return 0
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            if expandReleaseNotes, let attributedText = appData?.releaseNotes?.attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9) {
                let size = attributedText.boundingRect(with: CGSize(width: tableView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                return size.height + 94
            } else {
                return 167
            }
        case 2:
            return 500
        case 3:
            if expandDescription, let attributedText = appData?.description.attributedString(font: UIFont.systemFont(ofSize: 15), lineSpacing: 9) {
                let size = attributedText.boundingRect(with: CGSize(width: tableView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                return size.height + 130
            } else {
                return 195
            }
        case 4:
            return appData?.sellerUrl != nil ? 280 : 230
        default:
            return 0
        }
    }
    
    // MARK: - Collection view data source (screenshots)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appData?.screenshotUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScreenshotCollectionViewCell
        
        
        if let screenshotUrl = appData?.screenshotUrls[indexPath.item] {
            cell.imageView?.load(urlString: screenshotUrl)
        }
        return cell
    }
    
}


