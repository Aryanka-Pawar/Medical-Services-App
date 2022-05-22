import 'package:flutter/material.dart';
import 'package:health_app/service/firebaseDatabase.dart';
import '../../shared/constants.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController serviceDescriptionEditingController = TextEditingController();
  TextEditingController serviceLocationEditingController = TextEditingController();

  final serviceList = [
    "Service Name",
    "Dental",
    "Gynac",
    "Physician",
    "Internist",
    "Allergist",
  ];

  String _currentServiceValue = "Service Name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Service"),
        backgroundColor: AppColors.themeColor,
      ),
      floatingActionButton: customButton("Add Service", addService, width(context)*0.82),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0,),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return Container(
                      height: height(context)*0.07,
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
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentServiceValue,
                            borderRadius: BorderRadius.circular(15.0),
                            isDense: true,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            onChanged: (val){
                              setState(() {
                                _currentServiceValue = val!;
                                state.didChange(val);
                              });
                            },
                            items: serviceList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
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
                          // height: height(context)*0.2,
                          // color: Colors.red,
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "Service Description",
                            ),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            maxLength: 150,
                            cursorColor: AppColors.themeColor,
                            validator: (val) => (val==null||val.isEmpty) ?'Enter a service description' : null,
                            controller: serviceDescriptionEditingController,
                          ),
                        ),
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
                            controller: serviceLocationEditingController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addService() async{
    if(_formKey.currentState!.validate()){
      Map<String, dynamic> serviceRoom = {
        "serviceId" : widget.userId,
        "serviceName" : _currentServiceValue,
        "serviceDescription" : serviceDescriptionEditingController.text,
        "serviceLocation" : serviceLocationEditingController.text.toLowerCase(),
      };
      await DatabaseService(uid: widget.userId).addServices(serviceRoom);
      Navigator.pop(context);
    }
  }

}
