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

    private init() {}
    private let motionManager = CMMotionManager()
    private var isFacedown = false
    private var toChange = true
    
    func startMotionDetector() {
        data = []
        guard motionManager.isDeviceMotionAvailable else { return }
        guard !motionManager.isDeviceMotionActive else { return }

        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] data, _ in
            guard let self = self, let gravity = data?.gravity else { return }

            recordData(x: gravity.x, y: gravity.y, z: gravity.z)
            if gravity.z > -0.5 {
                toChange = true
            }
            if gravity.z < -0.9 && toChange {
                Task {
                    self.assetIndex = self.assetIndex >= Asset.portfolio.count - 1 ? 0 : self.assetIndex + 1
                }
                toChange = false
            }
            if gravity.z > Constants.faceDownThreshold {
                if !self.isFacedown {
                    self.isFacedown = true
                    Task {
                        self.lock = !self.lock
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
        
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { [weak self] data, _ in
            guard let data, let self else { return }
            recordData(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
        }
    }
    
    func startGyroscopeDetector() {
        data = []
        guard motionManager.isGyroAvailable else { return }
        guard !motionManager.isGyroActive else { return }
        
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
            
//            if self.data.count > Constants.dataCount {
//                self.data.removeFirst()
//            }
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
        static let faceDownThreshold = 0.8
        static let dataCount = 100
    }
}
