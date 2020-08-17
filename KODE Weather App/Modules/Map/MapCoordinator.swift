//
//  MapCoordinator.swift

import UIKit

class MapCoordinator: Coordinator {
    private let rootViewController: UINavigationController
    
    private var viewModel: MapViewModel = {
        let appDependecy = AppDependency.makeDefault()
        let mapViewModel = MapViewModel(dependencies: appDependecy)
        return mapViewModel
    }()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        viewModel.delegate = self
        let mapViewController = MapViewController(viewModel: viewModel)
        rootViewController.setViewControllers([mapViewController], animated: false)
    }
}

extension MapCoordinator: MapViewModelDelegate {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String) {
        let weatherCoordinator = WeatherCoordinator(rootViewController: rootViewController, city: city)
        weatherCoordinator.coordinatorDelegate = self
        addChildCoordinator(weatherCoordinator)
        weatherCoordinator.start()
    }
}

extension MapCoordinator: WeatherCoordinatorDelegate {
    func weatherCoordinatorDidFinish(from coordinator: WeatherCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
