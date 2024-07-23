import 'package:vpn/di/factory/repository_factory.dart';
import 'package:vpn/feature/server/server_details/domain/server_details_service.dart';

abstract class ServiceFactory {
  ServerDetailsService get serverDetailsService;
}

class ServiceFactoryImpl implements ServiceFactory {
  final RepositoryFactory _repositoryFactory;

  ServiceFactoryImpl({
    required RepositoryFactory repositoryFactory,
  }) : _repositoryFactory = repositoryFactory;

  ServerDetailsService? _serverDetailsService;

  @override
  ServerDetailsService get serverDetailsService => _serverDetailsService ??= ServerDetailsServiceImpl(
        serverRepository: _repositoryFactory.serverRepository,
      );
}
