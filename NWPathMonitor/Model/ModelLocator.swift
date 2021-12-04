//
//  ModelLocator.swift
//  NWPathMonitor
//
//  Created by 今村京平 on 2021/12/04.
//

import Foundation

final class ModelLocator {
    static let shared = ModelLocator()
    private init() {}
    let nwMonitoring: NWMonitoringProtocol = NWMonitoring()
}
