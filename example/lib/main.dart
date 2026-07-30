import 'package:flutter/material.dart';
import 'package:interactive_toast/interactive_toast.dart';

void main() {
  runApp(const InteractiveToastDemoApp());
}

class InteractiveToastDemoApp extends StatelessWidget {
  const InteractiveToastDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBanner(
      controller: AppBannerController(),
      child: MaterialApp(
        title: 'Interactive Toast Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DemoScreen(),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Toast Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Banner Types'),
          _buildDemoCard(
            'Info Banner',
            'Shows information to the user',
            () => AppBanner.of(context).show(
              context,
              'This is an info message',
              config: const BannerConfig(message: 'This is an info message'),
            ),
          ),
          _buildDemoCard(
            'Success Banner',
            'Indicates successful operation',
            () => AppBanner.of(context).show(
              context,
              'Operation completed successfully!',
              config: const BannerConfig(
                message: 'Success!',
                type: BannerType.success,
              ),
            ),
          ),
          _buildDemoCard(
            'Warning Banner',
            'Alerts about potential issues',
            () => AppBanner.of(context).show(
              context,
              'Warning: This action cannot be undone',
              config: const BannerConfig(
                message: 'Warning!',
                type: BannerType.warning,
              ),
            ),
          ),
          _buildDemoCard(
            'Error Banner',
            'Reports errors to the user',
            () => AppBanner.of(context).show(
              context,
              'Error: Connection failed. Please try again.',
              config: const BannerConfig(
                message: 'Error occurred',
                type: BannerType.error,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Progress Indicator'),
          _buildDemoCard(
            'With Progress Bar',
            'Shows countdown progress bar',
            () => AppBanner.of(context).show(
              context,
              'Downloading file...',
              config: const BannerConfig(
                message: 'Downloading file...',
                duration: Duration(seconds: 5),
                showProgress: true,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Action Button'),
          _buildDemoCard(
            'With Action',
            'Tap to trigger callback without dismissing',
            () => AppBanner.of(context).show(
              context,
              'New version available!',
              config: BannerConfig(
                message: 'Update available!',
                action: BannerAction(
                  label: 'UPDATE',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Update tapped!')),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Custom Duration'),
          _buildDemoCard(
            'Long Duration',
            'Banner stays for 10 seconds',
            () => AppBanner.of(context).show(
              context,
              'This banner stays for 10 seconds',
              config: const BannerConfig(
                message: 'Long duration banner',
                duration: Duration(seconds: 10),
                showProgress: true,
              ),
            ),
          ),
          _buildDemoCard(
            'Short Duration',
            'Banner dismisses quickly',
            () => AppBanner.of(context).show(
              context,
              'Quick dismiss after 1.5 seconds',
              config: const BannerConfig(
                message: 'Quick banner',
                type: BannerType.success,
                duration: Duration(milliseconds: 1500),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Controls'),
          OutlinedButton.icon(
            onPressed: () => AppBanner.of(context).dismiss(),
            icon: const Icon(Icons.close),
            label: const Text('Dismiss Current Banner'),
          ),
          const SizedBox(height: 48),
          const Text(
            'Swipe up to dismiss • Tap action button to trigger callback',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDemoCard(String title, String subtitle, VoidCallback onPressed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(onPressed: onPressed, child: const Text('Show')),
      ),
    );
  }
}
