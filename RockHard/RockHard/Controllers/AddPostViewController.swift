//
//  AddPostViewController.swift
//  RockHard
//
//  Created by Anthony Gonzalez on 2/3/20.
//  Copyright © 2020 Rockstars. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {
    
    //MARK: -- Properties
    lazy var addPostLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Post"
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .white
        return label
    }()
    
    lazy var feedPostImage: UIImageView = {
        let myImage = UIImageView()
        myImage.isUserInteractionEnabled = true
        myImage.image = #imageLiteral(resourceName: "cameraPlaceholder")
        myImage.backgroundColor = .clear
        myImage.layer.cornerRadius = 10
        myImage.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePressed))
        myImage.addGestureRecognizer(tapGesture)
        return myImage
    }()
    
    lazy var feedPostTextField: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 10
        tv.isUserInteractionEnabled = true
        tv.font = UIFont.systemFont(ofSize: 23)
        tv.delegate = self
        return tv
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.cyan, for: .normal)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    var delegate: loadFeedPostsDelegate!
    
    var userName = String()
    
    var imageURL: String? = nil
    
    //MARK: -- Objective C Functions
    @objc private func imagePressed(){
        presentImagePicker()
    }
    
    @objc private func submitButtonPressed(){
        
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        guard let photoUrl = imageURL else {return}
        guard let postText = feedPostTextField.text else { return }
        FirestoreService.manager.createPost(post: Post(userID: user.uid.description, userName: userName, postPicture: photoUrl, postText: postText)) { (result) in
            switch result {
            case .failure(let error):
                Utilities.showAlert(vc: self, message: "\(error.localizedDescription)")
            case .success:
                Utilities.showAlert(vc: self, message: "Message posted")
                self.delegate?.loadAllPosts()
            }
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    //MARK: -- Methods
    private func presentImagePicker(){
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.mediaTypes = ["public.image"]
        imagePickerViewController.sourceType = .photoLibrary
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    private func setTextViewPlaceHolders () {
        feedPostTextField.textColor = .lightGray
        feedPostTextField.text = "Enter Message..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setTextViewPlaceHolders()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        setConstraints()
    }
}


//MARK: -- Constraints
extension AddPostViewController {
    
    private func setConstraints() {
        
        [feedPostImage, addPostLabel, feedPostTextField, submitButton].forEach{view.addSubview($0)}
        [feedPostImage, feedPostTextField, addPostLabel, submitButton ].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        setFeedPostImageConstraints()
        setFeedPostTextFieldConstraints()
        setTitleLabelConstraints()
        setSubmitButtonConstraints()
        
    }
    
    private func setTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            addPostLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPostLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addPostLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addPostLabel.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    private func setFeedPostImageConstraints() {
        NSLayoutConstraint.activate([
            feedPostImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedPostImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            feedPostImage.heightAnchor.constraint(equalToConstant: 150),
            feedPostImage.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    private func setFeedPostTextFieldConstraints() {
        NSLayoutConstraint.activate([
            feedPostTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedPostTextField.topAnchor.constraint(equalTo: addPostLabel.bottomAnchor, constant: 30 ),
            feedPostTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            feedPostTextField.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setSubmitButtonConstraints() {
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}


//MARK: -- Delegate Methods
extension AddPostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = "Enter Message..."
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
}


extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.feedPostImage.image = image
        dismiss(animated: true, completion: nil)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        FirebaseStorageService.uploadManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                self?.imageURL = url
                
            case .failure(let error):
                print(error)
            }
        })
    }
}

