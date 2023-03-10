import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wup/app/modules/user/input/input_controller.dart';
import 'package:wup/app/widgets/default_button.dart';

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

  bool _nameBlanked = true;
  bool _birthdayBlanked = true;
  bool _heightBlanked = true;
  bool _weightBlanked = true;

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
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: tr('input.gender'),
                                        ),
                                        name: 'gender',
                                        // initialValue: 1,
                                        // textStyle: TextStyle(fontWeight: FontWeight.bold),
                                        options: [
                                          FormBuilderFieldOption(
                                            value: "Female",
                                            child: const Text(
                                              'input.female',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ).tr(),
                                          ),
                                          FormBuilderFieldOption(
                                            value: "Male",
                                            child: const Text(
                                              "input.male",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ).tr(),
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
                                          labelText: tr('input.name'),
                                          suffixIcon: _nameBlanked
                                              ? null
                                              : _nameHasError
                                                  ? const Icon(Icons.error,
                                                      color: Colors.red)
                                                  : const Icon(Icons.check,
                                                      color: Colors.green),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            _nameBlanked = false;
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
                                        format: DateFormat('y/M/d'),
                                        inputType: InputType.date,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          labelText: tr('input.birthday'),
                                          suffixIcon: _birthdayBlanked
                                              ? null
                                              : _birthdayHasError
                                                  ? const Icon(Icons.error,
                                                      color: Colors.red)
                                                  : const Icon(Icons.check,
                                                      color: Colors.green),
                                        ),
                                        onChanged: (value) {
                                          _birthdayBlanked = false;
                                        },
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
                                                labelText:
                                                    '${tr('input.height')} (cm)',
                                                suffixIcon: _heightBlanked
                                                    ? null
                                                    : _heightHasError
                                                        ? const Icon(
                                                            Icons.error,
                                                            color: Colors.red)
                                                        : const Icon(
                                                            Icons.check,
                                                            color:
                                                                Colors.green),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _heightBlanked = false;
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
                                              name: 'weight',
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(),
                                              decoration: InputDecoration(
                                                suffixText: "kg",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText:
                                                    '${tr('input.weight')} (kg)',
                                                suffixIcon: _weightBlanked
                                                    ? null
                                                    : _weightHasError
                                                        ? const Icon(
                                                            Icons.error,
                                                            color: Colors.red)
                                                        : const Icon(
                                                            Icons.check,
                                                            color:
                                                                Colors.green),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _weightBlanked = false;
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
                              DefaultButton(
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
