//
//  MotionDetector.swift
//  MobiusNov2023
//
//  Created by Vsevolod Migdisov on 01.08.2023.
//
import CoreMotion
import Charts

@MainActor
final class MotionDetector: ObservableObject {
    
    static public let shared = MotionDetector()
    @Published var lock = false
    @Published var data = [DataModel]()
    @Published var assetIndex = 0
    @Published var showIndicators = false

    private init() {}
    private let motionManager = CMMotionManager()
    private var isFacedown = false
    private var toChangeAsset = false
    private var toShowIndicator = false
    private var toHideIndicator = false
    
    func startMotionDetector() {
        data = []
        guard motionManager.isDeviceMotionAvailable else { return }
        guard !motionManager.isDeviceMotionActive else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.1

        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] data, _ in
            guard let self = self, let gravity = data?.gravity else { return }
            
            recordData(x: gravity.x, y: gravity.y, z: gravity.z)
            
            /// Показ индикатора средней цены
            if gravity.y < 0.2 && gravity.y > -0.2 && (toShowIndicator || toHideIndicator)  {
                Task {
                    if self.toShowIndicator {
                        self.showIndicators = true
                        self.toShowIndicator = false
                    }
                    if self.toHideIndicator {
                        self.showIndicators = false
                        self.toHideIndicator = false
                    }
                }
            }
            if gravity.y < -0.4 {
                toHideIndicator = true
            }
            
            if gravity.y > 0.4 {
                toShowIndicator = true
            }
            
            /// Переключение инструментов
            if gravity.z > -0.4 && toChangeAsset {
                Task {
                    self.assetIndex = self.assetIndex >= Asset.portfolio.count - 1 ? 0 : self.assetIndex + 1
                    self.toChangeAsset = false
                }
            }
            if gravity.z < -0.8 {
                toChangeAsset = true
            }
            
            /// Показ графика данных гироскопа
            if gravity.z > 0.8 {
                if !self.isFacedown {
                    self.isFacedown = true
                    Task {
                        self.lock.toggle()
                    }
                }
            } else if gravity.z < 0 {
                if self.isFacedown {
                    self.isFacedown = false
                }
            }
        }
    }
    
    func startAccelerometerDetector() {
        data = []
        guard motionManager.isAccelerometerAvailable else { return }
        guard !motionManager.isAccelerometerActive else { return }
        
        motionManager.accelerometerUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { [weak self] data, _ in
            guard let data, let self else { return }
            recordData(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
        }
    }
    
    func startGyroscopeDetector() {
        data = []
        guard motionManager.isGyroAvailable else { return }
        guard !motionManager.isGyroActive else { return }
        
        motionManager.gyroUpdateInterval = 0.1
        
        motionManager.startGyroUpdates(to: OperationQueue()) { [weak self] data, _ in
            guard let data, let self else { return }
            recordData(x: data.rotationRate.x, y: data.rotationRate.y, z: data.rotationRate.z)
        }
    }
    
    func stopDetector() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
    }
    
    func recordData(x: Double, y: Double, z: Double) {
        Task {
            let date = Date()
            self.data.append(DataModel(date: date, axis: .x, value: x))
            self.data.append(DataModel(date: date, axis: .y, value: y))
            self.data.append(DataModel(date: date, axis: .z, value: z))
            
            if self.data.count > Constants.dataCount {
                self.data.removeFirst()
            }
        }
    }
    
    // MARK: - Supporting objects
    
    enum Axis: String {
        case x = "X"
        case y = "Y"
        case z = "Z"
    }
    
    struct DataModel: Identifiable {
        let id = UUID()
        let date: Date
        let axis: Axis
        let value: Double
    }
    
    enum Constants {
        static let dataCount = 100
    }
}
