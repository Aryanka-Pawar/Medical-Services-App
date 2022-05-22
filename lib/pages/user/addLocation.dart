import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/constants.dart';
import '../../shared/helperFunctions.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userLocationEditingController = TextEditingController();

  String userLocation = "Service Location";

  getUserLocation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userLocation = prefs.getString(HelperFunctions.sharedPreferenceUserLocationKey) ?? "Service Location";
    });
    print("\n\nUser Location: ${userLocation}\n\n");
    userLocationEditingController.text = userLocation;
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Location"),
        backgroundColor: AppColors.themeColor,
      ),
      floatingActionButton: customButton("Add Location", addLocation, width(context)*0.82),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                  child: Container(
                    width: width(context)*0.9,
                    decoration: BoxDecoration(
                        border: const Border(),
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 0.5),
                              blurRadius: 20.0,
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Service Location",
                            ),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            cursorColor: AppColors.themeColor,
                            maxLength: 20,
                            validator: (val) => (val==null||val.isEmpty) ?'Enter a service location' : null,
                            controller: userLocationEditingController,
                          ),
                        ),
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

  void addLocation() async{
    if(_formKey.currentState!.validate()){
      HelperFunctions.saveUserLocationSharedPreference(userLocationEditingController.text.toLowerCase());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${userLocationEditingController.text} is Selected")));
    }
  }

}
