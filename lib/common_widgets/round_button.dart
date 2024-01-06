import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

enum RoundButtonType { primaryBG, secondaryBG, primaryGradient, secondaryGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final Function() onPressed;

  const RoundButton({Key? key, required this.title, required this.onPressed, this.type = RoundButtonType.secondaryBG})
      : super(key: key);

  List<Color> getGradientColors() {
    switch (type) {
      case RoundButtonType.primaryBG:
        return AppColors.primaryG;
      case RoundButtonType.secondaryBG:
        return AppColors.secondaryG;
      case RoundButtonType.primaryGradient:
        return AppColors.primaryG;
      case RoundButtonType.secondaryGradient:
        return AppColors.secondaryG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: getGradientColors(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))
          ]),
      child: MaterialButton(
        minWidth: double.maxFinite,
        height: 50,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: AppColors.primaryColor1,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.whiteColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}


// enum RoundButtonType { bgGradient, bgSGradient , textGradient }
//
// class RoundButton extends StatelessWidget {
//   final String title;
//   final RoundButtonType type;
//   final VoidCallback onPressed;
//   final double fontSize;
//   final double elevation;
//   final FontWeight fontWeight;
//
//   const RoundButton(
//       {super.key,
//         required this.title,
//         this.type = RoundButtonType.bgGradient,
//         this.fontSize = 16,
//         this.elevation = 1,
//         this.fontWeight= FontWeight.w700,
//         required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: type == RoundButtonType.bgSGradient ? AppColors.secondaryG :  AppColors.primaryG,
//           ),
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient
//               ? const [
//             BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 0.5,
//                 offset: Offset(0, 0.5))
//           ]
//               : null),
//       child: MaterialButton(
//         onPressed: onPressed,
//         height: 50,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         textColor: AppColors.primaryColor1,
//         minWidth: double.maxFinite,
//         elevation: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient ? 0 : elevation,
//         color: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient
//             ? Colors.transparent
//             : AppColors.white,
//         child: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient
//             ? Text(title,
//             style: TextStyle(
//                 color: AppColors.white,
//                 fontSize: fontSize,
//                 fontWeight: fontWeight))
//             : ShaderMask(
//           blendMode: BlendMode.srcIn,
//           shaderCallback: (bounds) {
//             return LinearGradient(
//                 colors: AppColors.primaryG,
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight)
//                 .createShader(
//                 Rect.fromLTRB(0, 0, bounds.width, bounds.height));
//           },
//           child: Text(title,
//               style: TextStyle(
//                   color:  AppColors.primaryColor1,
//                   fontSize: fontSize,
//                   fontWeight: fontWeight)),
//         ),
//       ),
//     );
//   }
// }
//
