import UIKit
import ParseSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func signUpPressed(_ sender: Any) {
        // Make sure user is fully logged out before signup
        User.logout { _ in
            self.performSignUp()
        }
    }

    func performSignUp() {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            statusLabel.text = "Please fill in required fields."
            return
        }

        var newUser = User()
        newUser.username = username
        newUser.password = password

        newUser.signup { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.statusLabel.text = "Sign up successful! Welcome, \(user.username ?? "")"
                    print("User signed up: \(user)")
                    UserData.createDefault(for: user)
                    // Optionally: navigate to Profile screen

                case .failure(let error):
                    self.statusLabel.text = "Sign-up failed: \(error.localizedDescription)"
                    print("Sign-up error: \(error)")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
