import Cocoa
import FlutterMacOS

public class VpnPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let messenger = registrar.messenger
      StorageManagerSetup.setUp(binaryMessenger: messenger, api: StorageManagerImpl())
      VpnManagerSetup.setUp(binaryMessenger: messenger, api: VpnManagerImpl())
  }
}

public class StorageManagerImpl: NSObject, StorageManager {
    func addNewServer(name: String, ipAddress: String, domain: String, username: String, password: String, protocol: VpnProtocol, routingProfileId: Int64, dnsServers: [String]) throws -> AddNewServerResult {
        throw PigeonError(code: "@", message: "", details: nil)
    }
    
    func getAllServers() throws -> [Server] {
        return [Server(name: "hhh", value: 1)]
    }
    
    func getPlatformType(request: GetPlatformTypeRequest) throws -> GetPlatformTypeResponse {
        let response = GetPlatformTypeResponse(platformType: "MacOS")
        return response
    }
}

public class VpnManagerImpl: NSObject, VpnManager {
    func getPlatformType(request: GetPlatformTypeRequest) throws -> GetPlatformTypeResponse {
        throw PigeonError(code: "222", message: nil, details: ErrorResponse(type: ErrorType.databaseError, fieldErrors: [FieldError(type: ErrorType.serverError, field: Field.description)]))
        let response = GetPlatformTypeResponse(platformType: "MacOS")
        return response
    }
}
