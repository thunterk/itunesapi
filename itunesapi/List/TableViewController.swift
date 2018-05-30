//
//  TableViewController.swift
//  itunesapi
//
//  Created by sunhaeng Heo on 2018. 5. 29..
//  Copyright © 2018년 Kyung-gak Nam. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageCache.clear()
    }
    
    // MARK: -
    var listData: ListData? = nil
    
    func load() {
        HTTP.listRequest { [weak self](listData, error) in
            guard listData != nil && error == nil else {
                return
            }
            
            self?.listData = listData
            
            DispatchQueue.main.async {
                self?.title = self?.listData?.title.label
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData?.entry.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if let data = listData?.entry[indexPath.row] {
            cell.setRank(indexPath.row + 1)
            cell.titleLabel?.text = data.name.label
            cell.descLabel?.text = data.category.attributes?["label"]
            
            var iconInfo: (Int, String)?
            for each in data.image {
                if let height = Int(each.attributes?["height"] ?? "0"), height > (iconInfo?.0 ?? 0) {
                    iconInfo = (height, each.label)
                }
            }
            
            if let iconUrl = iconInfo?.1 {
                cell.thumbnail?.load(urlString: iconUrl)
            }
        }
        
        return cell
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell), let data = listData?.entry[indexPath.row], let appId = data.id.attributes?["im:id"], let dst = segue.destination as? DetailTableViewController else {
            return
        }
        dst.title = data.name.label
        dst.rank = (data.category.label, indexPath.row + 1)
        dst.load(appId)
    }

}
