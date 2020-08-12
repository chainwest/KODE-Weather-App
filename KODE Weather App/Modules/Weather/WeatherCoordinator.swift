//
//  WeatherViewCoordinator.swift

import UIKit

protocol WeatherCoordinatorDelegate: class {
    func weatherCoordinatorDidFinish(from coordinator: WeatherCoordinator)
}

class WeatherCoordinator: Coordinator {
    weak var coordinatorDelegate: WeatherCoordinatorDelegate?
    private let rootViewController: UINavigationController
    public let city: String
    
    init(rootViewController: UINavigationController, city: String) {
        self.rootViewController = rootViewController
        self.city = city
    }
    
    override func start() {
        let dependencies = AppDependency.makeDefault()
        let viewModel = WeatherViewModel(dependencies: dependencies, city: city)
        viewModel.delegate = self
        let viewController = WeatherViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    override func finish() {
        coordinatorDelegate?.weatherCoordinatorDidFinish(from: self)
    }
}

extension WeatherCoordinator: WeatherViewModelDelegate {
    func weatherViewModelDidFinish(_ viewModel: WeatherViewModel) {
        finish()
    }
}
