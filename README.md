# Assessment

Reflective Section

1. Argument and Option Handling:
My script first checks if the number of arguments is enough (at least 1) or if --help is requested.
It then enters a loop to process all options starting with -, such as -v, -n, or combined ones like -vn.
Each letter after - is checked individually:
-n enables showing line numbers.
-v enables inverting the match (show non-matching lines).
--help prints the usage information and exits.
After options are processed, the script expects two positional arguments:
The pattern to search for, and the file to search inside.
If the file does not exist, an error is shown.

2. Adding Support for Regex, -i, -c, -l:
To support regular expressions and new options like -i, -c, or -l, I would need to expand the option parsing part to recognize these new flags individually.
Changes needed:
-i (ignore case): I would add a flag to control case-sensitivity and adjust the grep command accordingly
-c (count): Instead of printing matching lines, I would keep a counter variable and at the end, print the number of matches.
-l (list): If there is at least one match, I would just print the filename and stop reading further.
For regex: The basic matching logic would need to support full regular expression syntax, not just basic string matching (maybe using grep -E internally).

3. Hardest Part:
The hardest part was handling combined options like -vn or -nv.
Initially, my script only handled separate options like -v -n, but not when combined together.
I had to learn how to loop through each character individually inside a combined option string, and set the correct flags for each one.
Making the script flexible enough to handle all combinations correctly was challenging but very educational.
