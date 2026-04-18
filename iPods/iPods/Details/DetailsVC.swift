import UIKit

final class DetailViewController: UIViewController {

    var presenter: DetailPresenter!

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let slider = UISlider()
    private let playButton = UIButton()

    private let tableView = UITableView()

    private var episodes: [EpisodeViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        presenter.view = self

        Task {
            await presenter.load()
        }
    }
}

private func setupUI() {
    view.backgroundColor = .black

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true

    titleLabel.textColor = .white
    titleLabel.font = .boldSystemFont(ofSize: 24)

    authorLabel.textColor = .lightGray

    descriptionLabel.textColor = .gray
    descriptionLabel.numberOfLines = 2

    slider.tintColor = .orange

    playButton.backgroundColor = .orange
    playButton.layer.cornerRadius = 30
    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)

    tableView.backgroundColor = .black
    tableView.dataSource = self

    let stack = UIStackView(arrangedSubviews: [
        imageView,
        titleLabel,
        authorLabel,
        descriptionLabel,
        slider,
        playButton,
        tableView
    ])

    stack.axis = .vertical
    stack.spacing = 16

    view.addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        imageView.heightAnchor.constraint(equalToConstant: 300),

        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
}

extension DetailViewController: DetailView {

    func display(_ model: DetailViewModel) {
        titleLabel.text = model.title
        authorLabel.text = model.author
        descriptionLabel.text = model.description

        guard let url = model.imageURL else { return }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)

            DispatchQueue.main.async {
                self.imageView.image = data.flatMap { UIImage(data: $0) }
            }
        }
    }

    func displayEpisodes(_ items: [EpisodeViewModel]) {
        self.episodes = items
        tableView.reloadData()
    }

    func showError(_ message: String) {
        print(message)
    }
}


