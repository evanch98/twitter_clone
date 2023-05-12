import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/common/common.dart";
import "package:twitter_clone/features/auth/controller/auth_controller.dart";
import "package:twitter_clone/features/auth/view/signup_view.dart";
import "package:twitter_clone/features/home/view/home_view.dart";
import "package:twitter_clone/theme/theme.dart";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Twitter Clone",
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                // if user is not null, it means the user has logged in
                // show the HomeView
                return const HomeView();
              }
              // otherwise, show SignUpView
              return const SignUpView();
            },
            // if an error occurs, it will show the ErrorPage with an error
            // message
            error: (error, st) => ErrorPage(error: error.toString()),
            // if the state is loading, it will show the LoadingPage
            loading: () => const LoadingPage(),
          ),
      debugShowCheckedModeBanner: false,
    );
  }
}
