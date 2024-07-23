# Without FVM

gen:
	@echo "* Generate pigeon *"
	@dart pub run pigeon --input pigeons/platform_api.dart --swift_out ios/Classes/PlatformApi.g.swift
	@dart pub run pigeon --input pigeons/platform_api.dart --swift_out macos/Classes/PlatformApi.g.swift

gen2:
	@echo "* Generate pigeon *"
	@dart pub run pigeon --input pigeons/storage_manager.dart --swift_out ios/Classes/StorageManager.g.swift
	@dart pub run pigeon --input pigeons/storage_manager.dart --swift_out macos/Classes/StorageManager.g.swift
	@dart pub run pigeon --input pigeons/vpn_manager.dart --swift_out ios/Classes/VpnManager.g.swift
	@dart pub run pigeon --input pigeons/vpn_manager.dart --swift_out macos/Classes/VpnManager.g.swift
	@dart pub run pigeon --input pigeons/common_api.dart --swift_out ios/Classes/CommonApi.g.swift
	@dart pub run pigeon --input pigeons/common_api.dart --swift_out macos/Classes/CommonApi.g.swift