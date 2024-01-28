String? determineBMIGroup(double bmi) {
  if (bmi < 18.5) {
    return 'Lightweight';
  } else if (bmi >= 18.5 && bmi <= 24.9) {
    return 'Normal';
  } else if (bmi >= 25) {
    return 'Overweight';
  }
}
