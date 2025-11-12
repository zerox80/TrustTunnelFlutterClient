import Cocoa
import FlutterMacOS
import TrustTunnelClient

public class VpnPlugin: NSObject, FlutterPlugin {
    private static var vpnApi: IVpnManagerImpl?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger

        // TODO: Made separated plugin initialization
        // Konstantin Gorynin <k.gorynin@adguard.com>, 25 August 2025
        // Setup all platform managers
        let vpnImpl = IVpnManagerImpl(bundleIdentifier: "com.adguard.TrustTunnel.Extension")
        IVpnManagerSetup.setUp(binaryMessenger: messenger, api: vpnImpl)

        let events = FlutterEventChannel(
            name: "vpn_plugin_event_channel", binaryMessenger: messenger)
        events.setStreamHandler(vpnImpl)

        self.vpnApi = vpnImpl
    }
}

final class IVpnManagerImpl: NSObject, IVpnManager, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var vpnManager: VpnManager?
    
    init(bundleIdentifier: String) {
        super.init()
        self.vpnManager = VpnManager(bundleIdentifier: bundleIdentifier, stateChangeCallback: { [weak self] newState in
            self?.state = VpnManagerState(rawValue: newState)!
        })
    }

    private var state: VpnManagerState = .disconnected {
        didSet {
            DispatchQueue.main.async {
                self.emitState(self.state)
            }
        }
    }

    // MARK: - IVpnManager (Pigeon HostApi)

    func start(config: String) throws {
        vpnManager?.start(config: config)
    }

    func stop() throws {
        vpnManager?.stop()
    }

    func getCurrentState() throws -> VpnManagerState {
        return state
    }

    // MARK: - FlutterStreamHandler (EventChannel)

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
        -> FlutterError?
    {
        self.eventSink = events
        emitState(state)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    private func emitState(_ s: VpnManagerState) {
        eventSink?(s.rawValue)
    }
}
