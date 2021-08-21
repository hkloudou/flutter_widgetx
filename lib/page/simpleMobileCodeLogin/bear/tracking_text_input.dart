part of '../SimpleMobileCodeLoginPage.dart';

typedef void CaretMoved(Offset? globalCaretPosition);
typedef void TextChanged(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  TrackingTextInput(
      {Key? key,
      this.onCaretMoved,
      this.onTextChanged,
      this.hint,
      this.label,
      this.focusNode,
      // this.onEditingComplete,
      this.teddyController,
      this.isObscured = false})
      : super(key: key);
  final CaretMoved? onCaretMoved;
  final TextChanged? onTextChanged;
  final String? hint;
  final String? label;
  final FocusNode? focusNode;
  final bool isObscured;
  final TeddyController? teddyController;
  // final VoidCallback onEditingComplete;
  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  Timer? _debounceTimer;
  @override
  initState() {
    _textController.addListener(() {
      // We debounce the listener as sometimes the caret position is updated after the listener
      // this assures us we get an accurate caret position.
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (_fieldKey.currentContext != null) {
          // Find the render editable in the field.
          final RenderObject fieldBox =
              _fieldKey.currentContext!.findRenderObject()!;
          Offset? caretPosition = getCaretPosition(fieldBox);

          if (widget.onCaretMoved != null) {
            widget.onCaretMoved!(caretPosition);
          }
        }
      });
      if (widget.onTextChanged != null) {
        widget.onTextChanged!(_textController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
          maxLength: 11,
          keyboardType: TextInputType.phone,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.label,
            // style
            // fillColor: AppConfig.isDarkMode(context)
            //     ? AppConfig.colorDarkBg2
            //     : AppConfig.colorLightBg,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 15.0,
            ),
            // enabledBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(color: Color(0xFFE7EBEE)),
            // ),
            enabledBorder: InputBorder.none,
          ),
          key: _fieldKey,
          controller: _textController,
          obscureText: widget.isObscured,

          // onTap: () {
          //   widget.teddyController.playHandsUp();
          // },
          // onEditingComplete: () {
          //   widget.teddyController.playHandsDown();
          // },
          // onEditingComplete: widget.onEditingComplete,
          validator: (value) {
            // _fieldKey.currentState.
            // var x = 0;
            if (value == null || value.isEmpty) {
              return '手机号不能为空';
            }
            try {
              // value.i
              // int.parse(source)
              var x = int.tryParse(value) ?? 0;
              if (x == 0) {
                return "手机号格式错误";
              }
            } catch (e) {
              return "手机号必须为数字";
            }
            return null;
          }),
    );
  }
}
