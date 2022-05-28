//
//  PictureTableViewCell.swift
//  MVVMJsonEx
//
//  Created by Магомед Ахильгов on 27.05.2022.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageOutlet.image = UIImage(data: data)
            }
        }
    }
}

extension UIImageView {
    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill, placeholder: UIImage? = nil) {
        contentMode = mode
        image = placeholder
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error on download \(error ?? URLError(.badServerResponse))")
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                print("statusCode != 2xx; \(response.statusCode)")
                return
            }
            guard let image = UIImage(data: data) else {
                print("not valid image")
                return
            }
            DispatchQueue.main.async {
                print("download completed \(url.lastPathComponent)")
                self.image = image
            }
        }.resume()
    }
}
