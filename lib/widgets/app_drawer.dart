import 'package:afrikalyrics_mobile/config.dart';
import 'package:afrikalyrics_mobile/payments_controller.dart';
import 'package:afrikalyrics_mobile/theme_service.dart';
import 'package:afrikalyrics_mobile/widgets/about_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: context.height * .2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/background.jpeg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                // ListTile(
                //   title: Text(
                //     "Login",
                //     style: TextStyle(fontSize: 23),
                //   ),
                //   onTap: () {
                //     Get.to(LoginPage());
                //   },
                // ),
                // Divider(),
                // ListTile(
                //   title: Text(
                //     "Register",
                //     style: TextStyle(fontSize: 23),
                //   ),
                //   onTap: () {
                //     Get.to(RegisterScreen());
                //   },
                // ),
                Divider(),
                ListTile(
                  title: Text(
                    "Get Premium ",
                    style: TextStyle(
                      fontSize: 23,
                      color: Theme.of(context).textTheme.headline5?.color,
                    ),
                  ),
                  onTap: () {
                    PaymentsController.to.loadProductsForSale();
                    Get.back();
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 23,
                      color: Theme.of(context).textTheme.headline5?.color,
                    ),
                  ),
                  trailing: Switch(
                    value: Get.isDarkMode,
                    onChanged: (value) {
                      ThemeService().switchTheme();
                      Get.back();
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 23,
                      color: Theme.of(context).textTheme.headline5?.color,
                    ),
                  ),
                  onTap: () {
                    Get.to(AboutUsScreen());
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 23,
                      color: Theme.of(context).textTheme.headline5?.color,
                    ),
                  ),
                  onTap: () {
                    try {
                      launch("https://afrikalyrics.com/privacy-policy");
                    } catch (e) {}
                  },
                ),
                Divider(),

                // ListTile(
                //   title: Text(
                //     "Logout",
                //     style: TextStyle(fontSize: 23),
                //   ),
                //   onTap: () {
                //     Get.to(RegisterScreen());
                //   },
                // ),
                // Divider(),
              ],
            ),
          ),
          Container(
            child:
                Text("V${Config.infos?.version}(${Config.infos?.buildNumber})"),
          )
        ],
      ),
    );
  }
}
