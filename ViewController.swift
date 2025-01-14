import UIKit

class ViewController: UIViewController {
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLabel()
        fetchArtists()
    }

    func setupLabel() {
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Loading artists..."
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    func fetchArtists() {
        guard let url = URL(string: "http://localhost:3000/artists") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                if let artists = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let artistNames = artists.compactMap { $0["name"] as? String }.joined(separator: "\n")
                    DispatchQueue.main.async {
                        self.label.text = artistNames
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}

