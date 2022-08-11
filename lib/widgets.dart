// Here are the implementations for shared components within the SignUp feature.
// Keeping widgets shared by different screens in a separate file is good
// practice to maintain consistency, and allow for making easy changes.

import 'package:flutter/material.dart';

// ----------------------- TEXT FORM FIELD ------------------------
// Pretty text field used for first name, last name, email, etc.
class WaterTextFormField extends StatefulWidget {
  final String label;
  final Function(String?) onSaved;
  final Function(String?) validator;
  final String hint;
  final bool obscureText;
  final bool required;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  const WaterTextFormField(
      {required this.label,
      required this.onSaved,
      required this.validator,
      // If the parameter is not required, specify its default value.
      this.hint = "",
      this.obscureText = false,
      this.required = false,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.onChanged,
      Key? key})
      : super(key: key);

  @override
  State<WaterTextFormField> createState() => _WaterTextFormFieldState();
}

class _WaterTextFormFieldState extends State<WaterTextFormField> {
  late TextEditingController _controller;
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    // The ?? operator checks if the first object is null and, if it is, returns
    // the second object as a default value.
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        // RichText is similar to the <span> tag in HTML. Basically only needs
        // to be used when you want to combine different text styles in one text.
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontFamily: "SF Pro Display",
                fontSize: 16,
                fontWeight: FontWeight.w500),
            children: <TextSpan>[
              // Adds an * next to the required fields.
              if (widget.required) ...[
                const TextSpan(text: '* ', style: TextStyle(color: Colors.red)),
              ],
              TextSpan(
                  text: widget.label,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xff3B6ABA).withOpacity(.8),
                ),
            errorColor: const Color(0xFFFF9500),
          ),
          child: TextFormField(
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white),
            controller: _controller,
            onChanged: (input) {
              if (widget.onChanged != null) {
                widget.onChanged!(input);
              }
            },
            obscureText: widget.obscureText ? obscure : false,
            validator: (input) => widget.validator(input),
            onSaved: (input) => widget.onSaved(input),
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.white),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Color(0xff3B6ABA),
                width: 2,
              )),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
              ),
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      // Toggles visibility for obscure text fields (e.g. password).
                      onTap: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      child: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off))
                  : null,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!)),
            ),
          ),
        ),
      ],
    );
  }
}

// --------------------- Water NEW PAGE FORM BUTTON ---------------------
// Has a similar design to the text field, but opens a new page for input.
class WaterNewPageFormButton extends StatelessWidget {
  final String label, hint;
  final String? text;
  final bool required;
  final Function() onPressed;

  const WaterNewPageFormButton(
      {required this.label,
      this.hint = "",
      this.text,
      this.required = false,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontFamily: "SF Pro Display",
                fontSize: 16,
                fontWeight: FontWeight.w500),
            children: <TextSpan>[
              if (required) ...[
                // Adds an * next to the required fields.
                const TextSpan(text: '* ', style: TextStyle(color: Colors.red)),
              ],
              TextSpan(
                  text: label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      // If there's no text, use the hint. The hint serves as
                      // a placeholder, in gray, while the text is the real
                      // user input, in black.
                      (text == null || text!.isEmpty) ? hint : text!,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // Use gray if it's the hint, black if it's text.
                          color: (text == null || text!.isEmpty)
                              ? const Color(0xFF9E9E9E)
                              : Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF999999),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------ OUTLINED WATER BUTTON------------------------
class WaterOutlineButton extends StatelessWidget {
  final String text;
  final bool active, isProcessing;
  final Function() onPressed;
  const WaterOutlineButton(
      {required this.text,
      required this.onPressed,
      this.active = true,
      this.isProcessing = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      splashColor: Color(0xff3B6ABA).withOpacity(.8),
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      minWidth: 331,
      height: 41,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(color: Colors.white)),
      onPressed: (active) ? onPressed : () {},
      child: (isProcessing)
          ? const ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcATop,
              ),
              child: CircularProgressIndicator.adaptive(),
            )
          : Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'SF-Pro-Display-Light.otf',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
    );
  }
}

// --------------------- Water WELCOME BUTTON ---------------------
// Big button at the bottom of every page, usually labeled "Continue".
class WaterWelcomeButton extends StatelessWidget {
  final String text;
  final bool active, isProcessing;
  final Function() onPressed;

  const WaterWelcomeButton(
      {required this.text,
      required this.onPressed,
      this.active = true,
      this.isProcessing = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      minWidth: 331,
      height: 41,
      onPressed: (active) ? onPressed : () {},
      color: (active) ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // If isProcessing is true, display a white circular loading animation
      // where the usual label text would be.
      child: (isProcessing)
          ? const ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcATop,
              ),
              child: CircularProgressIndicator.adaptive(),
            )
          : Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'SF-Pro-Display-Light.otf',
                fontSize: 16,
                color: Colors.blue[1000],
              ),
            ),
    );
  }
}

// ______________________ Action button ________________________________
class ActionButton extends StatelessWidget {
  final Function() onPressed;
  final Icon chIcon;
  const ActionButton({Key? key, required this.onPressed, required this.chIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      height: 30,
      onPressed: onPressed,
      color: const Color(0xFFFFFFFF),
      shape: const CircleBorder(),
      // If isProcessing is true, display a white circular loading animation
      // where the usual label text would be.
      child: chIcon,
    );
  }
}

// --------------------- KTP PRIMARY LARGE BUTTON ---------------------
// Big button at the bottom of every page, usually labeled "Continue".
class WaterPrimaryLargeButton extends StatelessWidget {
  final String text;
  final bool active, isProcessing;
  final Function() onPressed;

  const WaterPrimaryLargeButton(
      {required this.text,
      required this.onPressed,
      this.active = true,
      this.isProcessing = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      minWidth: double.infinity,
      height: 50,
      onPressed: (active) ? onPressed : () {},
      color: (active)
          ? Color(0xff3B6ABA).withOpacity(.8)
          : const Color(0xFFB1B1B1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // If isProcessing is true, display a white circular loading animation
      // where the usual label text would be.
      child: (isProcessing)
          ? const ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcATop,
              ),
              child: CircularProgressIndicator.adaptive(),
            )
          : Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
    );
  }
}

// --------------------- KTP SIGN UP PROGRESS BAR ---------------------
// 3-step progress bar for the user to keep track of the sign up pages.
class KTPSignupProgressBar extends StatelessWidget {
  final int completed; // Number of lines to be filled in blue: (0|1|2|3)
  const KTPSignupProgressBar({required this.completed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          height: 7,
          decoration: BoxDecoration(
              // Fill with blue if one step is completed
              color: (completed >= 1)
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFD9D9D9),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          height: 7,
          decoration: BoxDecoration(
              // Fill with blue if two steps are completed
              color: (completed >= 2)
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFD9D9D9),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          height: 7,
          decoration: BoxDecoration(
              // Fill with blue if three steps are completed
              color: (completed >= 3)
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFD9D9D9),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
      ],
    );
  }
}

// --------------------- KTP CHECKBOX FORM FIELD ----------------------
class KTPCheckboxFormField extends StatelessWidget {
  final String label;
  final bool checked;
  final Function() onPressed;
  const KTPCheckboxFormField(
      {required this.label,
      required this.checked,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: GestureDetector(
        onTap: onPressed,
        child: AbsorbPointer(
          child: Row(
            children: [
              SizedBox(
                height: 16,
                width: 16,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: checked,
                  onChanged: (bool?
                      value) {}, // Do nothing, bool `checked` takes care of this
                  side: const BorderSide(color: Color(0xFFADB5BD)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------ KTP WARNING BANNER ------------------------
// Orange banner to display warning messages. Refer to the style guide.
SnackBar getKTPWarningBanner(BuildContext context, String label) => SnackBar(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      backgroundColor: const Color(0xFFDC8F1B),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Row(
        children: [
          const Icon(Icons.warning_amber_outlined,
              color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
              splashColor: Colors.transparent,
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ))
        ],
      ),
    );
