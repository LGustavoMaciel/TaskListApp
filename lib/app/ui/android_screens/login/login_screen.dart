// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sqlite_example/app/controller/login_store.dart';
import 'package:flutter_sqlite_example/app/routes/app_routes.dart';
import 'package:flutter_sqlite_example/app/ui/widgets/custom_icon_button.dart';
import 'package:flutter_sqlite_example/app/ui/widgets/custom_text_field.dart';
import 'package:mobx/mobx.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginStore loginStore = LoginStore();

  late ReactionDisposer disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    disposer = reaction((_) => loginStore.loggedIn, (loggedIn) {
      if (loginStore.loggedIn) Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/Icon.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'TaskApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                      fontFamily: "Monospace",
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Observer(
                          builder: (_) {
                            return CustomTextField(
                              hint: 'User',
                              prefix: Icon(Icons.supervisor_account),
                              textInputType: TextInputType.emailAddress,
                              onChanged: loginStore.setEmail,
                              enabled: !loginStore.loading,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Observer(
                          builder: (_) {
                            return CustomTextField(
                              hint: 'Password',
                              prefix: Icon(Icons.verified_user),
                              obscure: !loginStore.passwordVisible,
                              onChanged: loginStore.setPassword,
                              enabled: !loginStore.loading,
                              suffix: CustomIconButton(
                                radius: 32,
                                iconData: !loginStore.passwordVisible ? Icons.visibility : Icons.visibility_off,
                                onTap: loginStore.togglePasswordVisible,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Observer(builder: (_) {
                          return SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                disabledForegroundColor: Theme.of(context).primaryColor.withAlpha(100).withOpacity(0.38),
                                disabledBackgroundColor: Theme.of(context).primaryColor.withAlpha(100).withOpacity(0.12),
                              ),
                              // ignore: sort_child_properties_last
                              child: loginStore.loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : Text('Login'),
                              onPressed: loginStore.isEmailValid && loginStore.isPasswordValid && !loginStore.loading
                                  ? () {
                                      loginStore.login();
                                    }
                                  : null,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }
}
