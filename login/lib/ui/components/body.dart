import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/business_logic/controller.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final LoginController _controller = Get.find();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  GlobalKey<NavigatorState> dialogload = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    ever(_controller.viewState, (_) {
      if (_controller.viewState.value.loading){
        showDialog(context: Get.overlayContext!, builder: (_)=> const Center(child: CircularProgressIndicator())
        );
      } else {
        if (Navigator.of(Get.overlayContext!).canPop()) {
          Navigator.of(Get.overlayContext!).pop();
        }
      }

      if (_controller.viewState.value.done){
        Get.offNamed(MAP_SCREEN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              const SizedBox(
                height: 300.0,
                width: 300.0,
                child:Image(image: AssetImage(
                    "images/login_illustration.jpg"
                )),
              ),
              const SizedBox(height: 20.0),
              Obx(() => TextField(
                  controller: _emailTextEditingController,
                  onChanged:(email){
                    _controller.validateEmail(email);
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Your email ....",
                    label: const Text("Email"),
                    hintStyle: const TextStyle(
                          fontSize: 10.0
                      ),
                    errorText:
                    _controller.viewState.value.emailError != null ?
                    _controller.viewState.value.emailError!.isEmpty ? null : _controller.viewState.value.emailError
                    : null
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Obx(()=> TextField(
                  controller: _passwordTextEditingController,
                  onChanged: (password){
                    _controller.validatePassword(password);
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Your password ....",
                      label: const Text("password"),
                    hintStyle: const TextStyle(
                      fontSize: 10.0
                    ),
                    errorText:
                    _controller.viewState.value.passwordError != null ?
                    _controller.viewState.value.passwordError!.isEmpty ? null : _controller.viewState.value.passwordError
                    : null
                  ),
                ),
              ),

              const SizedBox(height: 20.0,),
              Obx(()=>ElevatedButton(
                onPressed: (){
                  if (_controller.viewState.value.isEveryThingValid()){
                    _controller.login(_emailTextEditingController.value.text, _passwordTextEditingController.value.text);
                  }
                },
                child: const Text("Login"),
                style: ElevatedButton.styleFrom(
                    primary: _controller.viewState.value.isEveryThingValid() ?
                    Colors.red : Colors.grey,
                    fixedSize: const Size(150.0 , 50.0)
                ),
              )),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account ? "),
                GestureDetector(
                  onTap: (){},
                  child: const Text(
                      "sign up now !",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline
                      ),
                  ),
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}
