//
//  ViewController.swift
//  MVVMJsonEx
//
//  Created by Магомед Ахильгов on 26.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewController: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    let dataParser = Parser()
    var parsedData = [Datum]()
    var parsedCell = [String]()
    var variants = [Variant]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        dataParser.parseDatum { data in
            self.parsedData = data
            DispatchQueue.main.async {
                self.tableViewController.reloadData()
            }
        }
        dataParser.parseCells { cell in
            self.parsedCell = cell
            DispatchQueue.main.async {
                self.tableViewController.reloadData()
            }
        }
    }
}

//MARK: - TableView Delegate & DataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifierOfcell =  parsedCell[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifierOfcell, for: indexPath) as? HzTableViewCell {
            cell.hzTextLabel.text = parsedData[0].data.text
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: identifierOfcell, for: indexPath) as? PictureTableViewCell {
            if let image = URL(string: parsedData[1].data.url!) {
                cell.downloadImage(from: image)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierOfcell, for: indexPath) as? UITableViewCell else {  return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        statusLabel.text = "Выбрано поле под названием \(parsedCell[indexPath.row])"
    }
    
//MARK: - PickerView Delegate & DataSource
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        variants = parsedData[2].data.variants!
        return variants[row].text
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let numberOfComponents = parsedData[2].data.variants?.count {
            return numberOfComponents
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusLabel.text = "Выбран \(parsedCell[row]) и вариант под номером -\(variants[row].id)- пользователем под id: \(parsedData[2].data.selectedID!)"
    }
}

