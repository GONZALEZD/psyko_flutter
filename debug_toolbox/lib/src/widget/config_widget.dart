import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:debug_toolbox/src/widget/toolbox.dart';
import 'package:flutter/material.dart';

class MaterialAppConfigWidget extends StatelessWidget {
  const MaterialAppConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = Toolbox.of(context);
    return ValueListenableBuilder<MaterialAppConfig>(
        valueListenable: toolbox!,
        builder: (context, config, child) {
          return ListView(
            shrinkWrap: true,
            children: [
              _buildToggleTile(
                currentValue: toolbox.showBanner,
                title: "Show debug banner",
                onValueChanged: (value) => toolbox.showBanner = value,
              ),
              const Divider(),
              _buildToggleTile(
                currentValue: toolbox.displayFrames,
                title: "Display performance frames",
                onValueChanged: (value) => toolbox.displayFrames = value,
              ),
              const Divider(),
              _buildChoiceTile<ThemeMode>(context,
                  groupTitle: "Select Theme",
                  currentValue: toolbox.themeMode,
                  choices: ThemeMode.values.asNameMap(),
                  onValueChanged: (value) =>
                  toolbox.themeMode = value ?? toolbox.themeMode),
              const Divider(),
              _buildChoiceTile<TargetPlatform>(
                context,
                groupTitle: "Select Platform",
                currentValue: toolbox.platform,
                choices: TargetPlatform.values.asNameMap(),
                onValueChanged: (value) =>
                    toolbox.platform = value ?? toolbox.platform,
              ),
            ],
          );
        });
  }

  Widget _buildToggleTile(
      {required bool currentValue,
      required String title,
      required Function(bool) onValueChanged}) {
    return SwitchListTile.adaptive(
      title: Text(title),
      value: currentValue,
      onChanged: onValueChanged,
    );
  }

  Widget _buildChoiceTile<T>(BuildContext context,
      {required String groupTitle,
      required T currentValue,
      required Map<String, T> choices,
      required Function(T?) onValueChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  groupTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ] +
            choices
                .map((title, value) => MapEntry(
                    value,
                    RadioListTile<T>(
                      value: value,
                      groupValue: currentValue,
                      title: Text(title),
                      onChanged: onValueChanged,
                    )))
                .values
                .toList(),
      ),
    );
  }
}
