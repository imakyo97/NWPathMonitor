//
//  NWMonitoringViewModel.swift
//  NWPathMonitor
//
//  Created by 今村京平 on 2021/12/04.
//

import Foundation
import Network
import RxSwift
import RxCocoa

protocol NWMonitoringViewModelInput {
    func viewDidLoad()
}

protocol NWMonitoringViewModelOutput {
    var NWPathStatus: Driver<String> { get }
    var NWInterface1: Driver<String?> { get }
    var NWInterface2: Driver<String?> { get }
    var NWInterface3: Driver<String?> { get }
    var NWInterface4: Driver<String?> { get }
    var NWInterface5: Driver<String?> { get }
}

protocol NWMonitoringViewModelType {
    var inputs: NWMonitoringViewModelInput { get }
    var outputs: NWMonitoringViewModelOutput { get }
}

final class NWMonitoringViewModel: NWMonitoringViewModelInput, NWMonitoringViewModelOutput {
    private let nwMonitoring: NWMonitoringProtocol
    private let disposeBag = DisposeBag()
    private let nwPathStatusRelay = PublishRelay<String>()
    private let nwInterface1Relay = PublishRelay<String?>()
    private let nwInterface2Relay = PublishRelay<String?>()
    private let nwInterface3Relay = PublishRelay<String?>()
    private let nwInterface4Relay = PublishRelay<String?>()
    private let nwInterface5Relay = PublishRelay<String?>()
    private var nwInterfaceRelayArray: [PublishRelay<String?>] = []

    init(nwMonitoring: NWMonitoringProtocol = ModelLocator.shared.nwMonitoring) {
        self.nwMonitoring = nwMonitoring
        setupNWInterfaceRelayArray()
        setupBinding()
    }

    private func setupNWInterfaceRelayArray() {
        nwInterfaceRelayArray = [
            nwInterface1Relay,
            nwInterface2Relay,
            nwInterface3Relay,
            nwInterface4Relay,
            nwInterface5Relay
        ]
    }

    private func setupBinding() {
        nwMonitoring.status
            .subscribe(onNext: { [weak self] status in
                guard let strongSelf = self else { return }
                let statusString = strongSelf.convertingToString(status: status)
                strongSelf.nwPathStatusRelay.accept(statusString)
            })
            .disposed(by: disposeBag)

        nwMonitoring.availableInterfaces
            .subscribe(onNext: passInterfaceName(nwInterface:))
            .disposed(by: disposeBag)
    }

    private func convertingToString(status: NWPath.Status) -> String {
        switch status {
        case .satisfied:
            return "satisfied"
        case .unsatisfied:
            return "unsatisfied"
        case .requiresConnection:
            return "requiresConnection"
        @unknown default:
            fatalError()
        }
    }

    private func convertingToString(interfaceType: NWInterface.InterfaceType) -> String {
        switch interfaceType {
        case .other:
            return "other"
        case .wifi:
            return "wifi"
        case .cellular:
            return "cellualr"
        case .wiredEthernet:
            return "wiredEthrnet"
        case .loopback:
            return "loopback"
        @unknown default:
            fatalError()
        }
    }

    private func passInterfaceName(nwInterface: [NWInterface]) {
        nwInterfaceRelayArray.enumerated().forEach {
            if nwInterface.indices.contains($0.offset) {
                $0.element.accept(
                    convertingToString(interfaceType: nwInterface[$0.offset].type)
                )
            } else {
                $0.element.accept(nil)
            }
        }
    }

    func viewDidLoad() {
        nwMonitoring.setupNWPathMonitor()
    }

    var NWPathStatus: Driver<String> {
        nwPathStatusRelay.asDriver(onErrorDriveWith: .empty())
    }

    var NWInterface1: Driver<String?> {
        nwInterface1Relay.asDriver(onErrorDriveWith: .empty())
    }

    var NWInterface2: Driver<String?> {
        nwInterface2Relay.asDriver(onErrorDriveWith: .empty())
    }

    var NWInterface3: Driver<String?> {
        nwInterface3Relay.asDriver(onErrorDriveWith: .empty())
    }

    var NWInterface4: Driver<String?> {
        nwInterface4Relay.asDriver(onErrorDriveWith: .empty())
    }

    var NWInterface5: Driver<String?> {
        nwInterface5Relay.asDriver(onErrorDriveWith: .empty())
    }
}

extension NWMonitoringViewModel: NWMonitoringViewModelType {
    var inputs: NWMonitoringViewModelInput {
        return self
    }

    var outputs: NWMonitoringViewModelOutput {
        return self
    }
}
