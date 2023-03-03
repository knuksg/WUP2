import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wup/components/default_button.dart';
import 'package:wup/controllers/input_controller.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() {
    return _InputScreenState();
  }
}

class _InputScreenState extends State<InputScreen> {
  final InputController controller = Get.put(InputController());
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  final bool _genderHasError = false;
  bool _nameHasError = false;
  final bool _birthdayHasError = false;
  bool _heightHasError = false;
  bool _weightHasError = false;

  var genderOptions = ['Female', 'Male', 'Other'];

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: GetStorage().read('progressbar'),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        maxWidth: constraints.maxWidth,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '정보 입력을 위한,',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily:
                                          GoogleFonts.nanumGothic().fontFamily,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '텍스트 부분입니다',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: GoogleFonts.nanumGothic()
                                            .fontFamily,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: FormBuilder(
                                  key: _formKey,
                                  // enabled: false,
                                  onChanged: () {
                                    _formKey.currentState!.save();
                                    debugPrint(_formKey.currentState!.value
                                        .toString());
                                  },
                                  autovalidateMode: AutovalidateMode.disabled,
                                  initialValue: {
                                    'movie_rating': 5,
                                    'name': controller.name,
                                    'gender': 'Female',
                                  },
                                  skipDisabled: true,
                                  child: Column(
                                    children: <Widget>[
                                      FormBuilderSegmentedControl(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Gender',
                                        ),
                                        name: 'gender',
                                        // initialValue: 1,
                                        // textStyle: TextStyle(fontWeight: FontWeight.bold),
                                        options: const [
                                          FormBuilderFieldOption(
                                            value: "Female",
                                            child: Text(
                                              "Female",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          FormBuilderFieldOption(
                                            value: "Male",
                                            child: Text(
                                              "Male",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                        onChanged: _onChanged,
                                      ),
                                      const SizedBox(height: 16),
                                      FormBuilderTextField(
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        name: 'name',
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'name',
                                          suffixIcon: _nameHasError
                                              ? const Icon(Icons.error,
                                                  color: Colors.red)
                                              : const Icon(Icons.check,
                                                  color: Colors.green),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            _nameHasError = !(_formKey
                                                    .currentState
                                                    ?.fields['name']
                                                    ?.validate() ??
                                                false);
                                          });
                                        },
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 16),
                                      FormBuilderDateTimePicker(
                                        name: 'birthday',
                                        initialEntryMode:
                                            DatePickerEntryMode.calendar,
                                        initialValue: DateTime.now(),
                                        format: DateFormat('y/M/d'),
                                        inputType: InputType.date,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: 'Birthday',
                                          suffixIcon: _birthdayHasError
                                              ? const Icon(Icons.error,
                                                  color: Colors.red)
                                              : const Icon(Icons.check,
                                                  color: Colors.green),
                                        ),

                                        // locale: const Locale.fromSubtags(languageCode: 'fr'),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FormBuilderTextField(
                                              name: 'height',
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(),
                                              decoration: InputDecoration(
                                                suffixText: "cm",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'height (cm)',
                                                suffixIcon: _heightHasError
                                                    ? const Icon(Icons.error,
                                                        color: Colors.red)
                                                    : const Icon(Icons.check,
                                                        color: Colors.green),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _heightHasError = !(_formKey
                                                          .currentState
                                                          ?.fields['height']
                                                          ?.validate() ??
                                                      false);
                                                });
                                              },
                                              validator: FormBuilderValidators
                                                  .compose([
                                                FormBuilderValidators
                                                    .required(),
                                                FormBuilderValidators.numeric()
                                              ]),
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: FormBuilderTextField(
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              name: 'weight',
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(),
                                              decoration: InputDecoration(
                                                suffixText: "kg",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'weight (kg)',
                                                suffixIcon: _weightHasError
                                                    ? const Icon(Icons.error,
                                                        color: Colors.red)
                                                    : const Icon(Icons.check,
                                                        color: Colors.green),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _weightHasError = !(_formKey
                                                          .currentState
                                                          ?.fields['weight']
                                                          ?.validate() ??
                                                      false);
                                                });
                                              },
                                              validator: FormBuilderValidators
                                                  .compose([
                                                FormBuilderValidators
                                                    .required(),
                                                FormBuilderValidators.numeric()
                                              ]),
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                              DefaultButton2(
                                text: 'Submit',
                                press: () {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    debugPrint(_formKey.currentState?.value
                                        .toString());
                                    controller.saveUserInfo(
                                      name: _formKey
                                          .currentState?.fields['name']?.value,
                                      birthday: _formKey.currentState
                                          ?.fields['birthday']?.value,
                                      gender: _formKey.currentState
                                          ?.fields['gender']?.value,
                                      height: _formKey.currentState
                                          ?.fields['height']?.value,
                                      weight: _formKey.currentState
                                          ?.fields['weight']?.value,
                                    );
                                  } else {
                                    debugPrint(_formKey.currentState?.value
                                        .toString());
                                    debugPrint('validation failed');
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
