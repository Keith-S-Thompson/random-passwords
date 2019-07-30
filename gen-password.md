# NAME

gen-password - Generate random passwords

# SYNOPSIS

gen-password \[options\]

    Options:
       -help       Show short usage message
       -help1      Show medium usage message
       -help2      Show long usage message
       -man        Show long usage message (invokes pager)

Use **-help1**, **-help2**, or **-man** to see more options.

# DESCRIPTION

**gen-password** generates random passwords.

It is part of the **random-passwords** package, available at

[https://github.com/Keith-S-Thompson/random-passwords](https://github.com/Keith-S-Thompson/random-passwords)

More documentation is available there.

By default, a 12-character password is generated, consisting of
lowercase letters and decimal digits.  Options let you control the
length and valid characters, and to add specified single characters
(for example if you need a 16-character password with 1 digit,
1 uppercase letter, and 1 punctuation character).

There is currently no option to use non-ASCII characters.

# OPTIONS

All options may be abbreviated uniquely.  **-help** may be abbreviated as **-h**.

- **-help**

    Show short usage message

- **-help1**

    Show medium usage message

- **-help2**

    Show long usage message

- **-man**

    Show long usage message using **perldoc**, invokes pager

- **-length N**

    Length of generated password, default is 12

- **-charset ...**

    Character set, default is "a-z0-9"

    The argument is a single word.

- **-decimal**, **-digits**

    Equivalent to **-charset 0-9**

- **-hexadecimal**

    Equivalent to **-charset 0-9a-f**

- **-Hexadecimal**

    Equivalent to **-charset 0-9A-F**

- **-octal**

    Equivalent to **-charset 0-7**

- **-lower**

    Equivalent to **-charset a-z**

- **-upper**

    Equivalent to **-charset A-Z**

- **-alphanumeric**

    Equivalent to **-charset A-Za-z0-9**

- **-printable**

    Equivalent to "-charset !-~" (ASCII non-blank printable characters)

- **-1lower**

    Include (at least) 1 lower case letter

- **-1upper**

    Include (at least) 1 upper case letter

- **-1decimal** **-1digit**

    Include (at least) 1 decimal digit

- **-1punctuation**

    Include (at least) 1 punctuation character

- **-1charset ...**

    Include (at least) 1 character from the specified set

    This option may be given multiple times.
    (The other **-1...** options may only be given once.)
    Use **-1charset 0-9 -1charset 0-9** for 2 decimal digits.

- **-split N**

    Split with a blank every N characters

- **-dev-random**

    Use /dev/random rather than /dev/urandom

    This can be much slower and is probably unnecessary.

- **-debugging**

    Produce debugging output (developer option)

# SEE ALSO

**gen-password**, also part of the **random-passwords** package.

[https://github.com/Keith-S-Thompson/random-passwords](https://github.com/Keith-S-Thompson/random-passwords).

# AUTHOR

Keith Thompson <Keith.S.Thompson@gmail.com>

# LICENSE AND COPYRIGHT

**random-password** is released under GPL version 2 or later.
