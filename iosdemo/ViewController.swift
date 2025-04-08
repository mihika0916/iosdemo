//
//  ViewController.swift
//  iosdemo
//
//  Created by Mihika Sharma on 28/03/25.
//

import UIKit
import ParseSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            statusLabel.text = "Please fill in all fields."
            return
        }

        User.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.statusLabel.text = "Welcome, \(user.username ?? "User")!"
                    print("Login success: \(user)")

                    // fetch the user's associated data
                    UserData.fetch(for: user) { userData in
                        if let data = userData {
                            print("Loaded quote: \(data.favoriteQuote ?? "N/A")")
                        } else {
                            print("No user data found.")
                        }
                    }

                    // Navigate to Profile screen
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                        profileVC.loggedInUser = user
                        self.navigationController?.pushViewController(profileVC, animated: true)
                    }

                case .failure(let error):
                    self.statusLabel.text = "Login failed: \(error.localizedDescription)"
                    print("Login failed: \(error)")
                }
            }
        }
    }
}
