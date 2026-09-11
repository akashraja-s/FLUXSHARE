import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/theme.dart';
import 'discovery/discovery_service.dart';
import 'metrics/metrics_collector.dart';
import 'network/local_server.dart';
import 'peer/peer_manager.dart';
import 'repositories/transfer_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistence and managers
  await MetricsCollector().init();
  await TransferRepository().init();
  PeerManager().init();

  // Start presence listener for nearby device discovery on local LAN
  final server = LocalServer();
  DiscoveryService().startPeerPresenceListener(
    peerId: server.localPeerId,
    deviceName: server.localDeviceName,
    platform: server.platform,
    serverPort: 8080,
  );

  runApp(const FluxShareApp());
}

class FluxShareApp extends StatelessWidget {
  const FluxShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluxShare',
      theme: AppTheme.lightTheme,
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
