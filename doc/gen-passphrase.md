# NAME

gen-passphrase - Generate random passphrases

# SYNOPSIS

gen-passphrase \[options\] initials|word-count min-len max-len

    Options:
       -help       Show short usage message
       -help1      Show medium usage message
       -help2      Show long usage message
       -man        Show long usage message (invokes pager)

       -[no]suffix       Allow/disallow words ending in s, ed, ing (enabled by default)
       -verbose          Show statistics about the strength of the passphrase
       -dictionary file  Use specified word list
                         Default is /usr/share/dict/words or $PASSPHRASE_DICT
       -dev-random       Use /dev/random rather than /dev/urandom (slow)
       -debugging        Produce debugging output (developer option)

# DESCRIPTION

**gen-passphrase** generates random passphrases.

It is part of the **random-passwords** package, available at

[https://github.com/Keith-S-Thompson/random-passwords](https://github.com/Keith-S-Thompson/random-passwords)

More documentation is available there.

**gen-passphrase** was partly inspired by this XKCD cartoon: [http://xkcd.com/936/](http://xkcd.com/936/),
which suggests using long passphrases consisting of randomly selected
English words.  The example in the cartoon was "correct horse battery
staple" (of course you shouldn't use \*that\* specific passphrase).

The passphrase consists of a sequence of words randomly selected
from the specified word list file.  The three command-line arguments
(following any options) are:

1\. **Either** a string of ASCII lowercase letters **or** a decimal integer
  specifying the number of words;

2\. The minimum length of each word; and

3\. The maximum length of each word.

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

- **-\[no\]suffix**

    **-suffix**, the default, allows words ending in s, ed, and ing
    (which are typically forms of other words).

    **-nosuffix** excludes such words.  This typically reduces the number of
    available words by about half.  If you use this option, use **-verbose**
    to see the effects, and consider using more and/or longer words.

- **-verbose**

    Show statistics about the strength of the passphrase

- **-dictionary _file_**

    Use specified word list  

    Default is /usr/share/dict/words or $PASSPHRASE\_DICT

- **-dev-random**

    Use /dev/random rather than /dev/urandom

    This can be much slower and is probably unnecessary.

- **-debugging**

    Produce debugging output (developer option)

# SEE ALSO

**gen-passphrase**, also part of the **random-passwords** package.

[https://github.com/Keith-S-Thompson/random-passwords](https://github.com/Keith-S-Thompson/random-passwords).

# AUTHOR

Keith Thompson <Keith.S.Thompson@gmail.com>

# LICENSE AND COPYRIGHT

**random-passphrase** is released under GPL version 2 or later.
