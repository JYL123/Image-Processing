The result from the histogram equalization is not bad. However there are some problems that I couldn't figure out:
* why the equalized hitogram still looks the same as the origin histogram?

  There are some mistakes made by me when i generate the equalized histogram. The best way to do it is:
  1. reassigin the pixel intensity to equalized picture
  2. generate the equalized histogram for the equalized picture
  3. generate the CDF based on the equalized histogram

* CDF doesn't change much as well

  This question is included above.
  
  Reflection: it is important to segment the code to know each section's responsibility, and do it right.

