import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passC = TextEditingController(text: "admin123");

  final AuthController authC = Get.find<AuthController>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: emailC,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => TextField(
                controller: passC,
                autocorrect: false,
                obscureText: controller.isHiden.value,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "password",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.isHiden.toggle();
                    },
                    child: Icon(controller.isHiden.value
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> hasil =
                        await authC.login(emailC.text, passC.text);
                    controller.isLoading(false);

                    if (hasil["error"] == true) {
                      Get.snackbar("Error", hasil["message"]);
                    } else {
                      Get.offAllNamed(Routes.home);
                    }
                  } else {
                    Get.snackbar("Error", "Email dan password wajib diisi.");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Obx(
                () =>
                    Text(controller.isLoading.isFalse ? "Login" : "Loading..."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
