import 'package:dgo_puzzle/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeRules extends StatelessWidget {
  HomeRules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TutorialPageView(),
    );
  }
}

class TutorialPageView extends StatefulWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onDone;

  const TutorialPageView({Key? key, this.onSkip, this.onDone}) : super(key: key);

  @override
  _TutorialPageViewState createState() => _TutorialPageViewState();
}

class _TutorialPageViewState extends State<TutorialPageView> {
  late PageController pageController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          width: 250,
          child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: pages,
          ),
        ),
        _buildControlBar(context, pages.length),
      ],
    );
  }

  void onPageChanged(int page) {
    setState(() {
      currentPageIndex = page;
    });
  }



  void _skipTutorial() {
    widget.onSkip?.call();
  }

  void _validateTutorial() {
    widget.onDone?.call();
  }

  void _nextTutorialPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic);
  }

  List<TutorialPage> _buildPages(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return [
      TutorialPage(
        title: strings.tutorial_01_title,
        message: strings.tutorial_01_body,
      ),
      TutorialPage(
        title: strings.tutorial_02_title,
        message: strings.tutorial_02_body,
      ),
      if (!Theme.of(context).platform.isMobile)
        TutorialPage(
          title: strings.tutorial_03_title_web,
          message: strings.tutorial_03_body_web,
        ),
      TutorialPage(
        title: strings.tutorial_04_title,
        message: strings.tutorial_04_body,
      ),
    ];
  }

  Widget _buildControlBar(BuildContext context, int nbPages) {
    final hasNextPage = currentPageIndex < nbPages - 1;
    final strings = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          child: Text(strings.tutorial_skip_button),
          onPressed: hasNextPage ? _skipTutorial : null,

        ),
        TextButton(
          child: Text(hasNextPage ? strings.tutorial_next_button : strings.tutorial_done_button),
          onPressed: hasNextPage ? _nextTutorialPage : _validateTutorial,
        )
        ,
      ],
    );
  }
}


class TutorialPage extends StatelessWidget {
  final String title;
  final String message;
  final Widget? leadingWidget;
  final Widget? trailingWidget;

  const TutorialPage({
    Key? key,
    required this.title,
    required this.message,
    this.leadingWidget,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTitle(context),
            Row(
              children: [
                if (leadingWidget != null)
                  Expanded(
                    child: leadingWidget!,
                  ),
                Expanded(child: _buildBody(context)),
                if (trailingWidget != null)
                  Expanded(
                    child: trailingWidget!,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
