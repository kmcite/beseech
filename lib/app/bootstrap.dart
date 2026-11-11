import 'package:beseech/business/configuration.dart';
import 'package:beseech/business/information.dart';
import 'package:beseech/business/prayers.dart';
import 'package:beseech/core/router.dart';
import 'package:beseech/domain/repositories/configuration_repository.dart';
import 'package:beseech/domain/repositories/prayers_repository.dart';
import 'package:beseech/domain/repositories/user_repository.dart';
import 'package:beseech/domain/services/database_service.dart';
import 'package:beseech/main.dart';
import 'package:beseech/ui/shell/beseech_shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeseechAppScope extends StatelessWidget {
  const BeseechAppScope({
    super.key,
    required this.databaseService,
    required this.prayersRepository,
    required this.userRepository,
    required this.configurationRepository,
    required this.router,
  });

  final DatabaseService databaseService;
  final PrayersRepository prayersRepository;
  final UserRepository userRepository;
  final ConfigurationRepository configurationRepository;
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: databaseService),
        Provider.value(value: router),
        ChangeNotifierProvider.value(value: prayersRepository),
        ChangeNotifierProvider.value(value: userRepository),
        ChangeNotifierProvider.value(value: configurationRepository),
        ChangeNotifierProvider(
          create: (_) => PrayersController(prayersRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => InformationController(userRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ConfigurationController(
            prayersRepository,
            userRepository,
            configurationRepository,
          ),
        ),
      ],
      child: routerScope(
        router: router,
        child: const BeseechApp(),
      ),
    );
  }
}

Future<Widget> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = DatabaseService();
  await databaseService.init();

  final prayersRepository = PrayersRepository(databaseService);
  await prayersRepository.init();

  final userRepository = UserRepository(databaseService);
  await userRepository.init();

  final configurationRepository = ConfigurationRepository(databaseService);
  await configurationRepository.init();

  final router = AppRouter(home: const BeseechShell());

  return BeseechAppScope(
    databaseService: databaseService,
    prayersRepository: prayersRepository,
    userRepository: userRepository,
    configurationRepository: configurationRepository,
    router: router,
  );
}
