//
//  ImageFeedVC.swift
//  Challenge4
//
//  Created by Roberto Manese III on 4/29/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ImageFeedVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var defaults = UserDefaults.standard

    var posts: [Post] = []
    var postsKey = "Post"
    var postCellID = String(describing: PostCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
        tableView.register(UINib(nibName: postCellID, bundle: nil), forCellReuseIdentifier: postCellID)

        if let savedPeople = defaults.object(forKey: postsKey) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                posts = try jsonDecoder.decode([Post].self, from: savedPeople)
            } catch {
                print("failed to load posts")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(post.imageName)
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellID) as! PostCell
        cell.captionLabel.text = post.caption
        cell.postImage.image = UIImage(contentsOfFile: path.path)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        promptUserForCaption(post: posts[indexPath.row])
    }

    @objc func addNewImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let post = Post(name: imageName, caption: "template")
        posts.append(post)
        save()
        tableView.reloadData()

        dismiss(animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func promptUserForCaption(post: Post) {
        let ac = UIAlertController(title: "Enter a caption for your photo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak ac, weak self] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            post.caption = caption
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }

    private func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(posts) {
            defaults.set(savedData, forKey: postsKey)
        } else {
            print("failed to save")
        }
    }

}
