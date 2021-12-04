//
//  NWMonitoring.swift
//  NWMonitoring
//
//  Created by 今村京平 on 2021/12/04.
//

import Foundation
import Network
import RxSwift
import RxRelay

protocol NWMonitoringProtocol {
    func setupNWPathMonitor()
    var status: Observable<NWPath.Status> { get }
    var availableInterfaces: Observable<[NWInterface]> { get }
}

final class NWMonitoring: NWMonitoringProtocol {
    private let nwPathMonitor = NWPathMonitor()
    private let nwMonitorQueue = DispatchQueue(label: "nwMonitorQueue")
    private let statusRelay = PublishRelay<NWPath.Status>()
    private let availableInterfacesRelay = PublishRelay<[NWInterface]>()

    func setupNWPathMonitor() {
        // パス変更の監視を開始
        nwPathMonitor.start(queue: nwMonitorQueue)
        // ネットワークパスの更新を受信
        nwPathMonitor.pathUpdateHandler = { [weak self] nwPath in
            guard let strongSelf = self else { return }
            // let status: NWPath.Status 接続でパスを使用できるかどうかを示すステータス。
            strongSelf.statusRelay.accept(nwPath.status)
            // let availableInterfaces: [NWInterface] パスで使用可能なすべてのインターフェースのリスト（優先順）。
            strongSelf.availableInterfacesRelay.accept(nwPath.availableInterfaces)
        }
    }

    var status: Observable<NWPath.Status> {
        statusRelay.asObservable()
    }

    var availableInterfaces: Observable<[NWInterface]> {
        availableInterfacesRelay.asObservable()
    }
}
