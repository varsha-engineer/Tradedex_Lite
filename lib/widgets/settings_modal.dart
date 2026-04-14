import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (_, settings, __) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 56,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customize your experience and refresh settings in one place.',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 0,
                          color: isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF8FAFC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            activeThumbColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            title: Text(
                              'Dark Mode',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Switch the app theme to dark mode.',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            value: settings.darkMode,
                            onChanged: (_) => settings.toggleTheme(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Card(
                          elevation: 0,
                          color: isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF8FAFC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            title: Text(
                              'Refresh Interval',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            trailing: DropdownButton<int>(
                              value: settings.refreshInterval,
                              underline: const SizedBox.shrink(),
                              items: [2, 5, 10, 30]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('$e sec'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) settings.changeInterval(val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 0,
                          color: isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF8FAFC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            title: Text(
                              'Currency',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: settings.currency,
                              underline: const SizedBox.shrink(),
                              items: ['INR', 'USD']
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) settings.changeCurrency(val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
