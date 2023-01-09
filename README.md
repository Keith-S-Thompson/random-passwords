Copyright (C) 2023 Keith Thompson

### UPDATE, Mon 2019-05-06 :

Corrected a bug that caused `gen-passphrase` to break on systems
where Perl uses 32-bit integers.  (This was not a security hole;
the command would simply fail.)

https://github.com/Keith-S-Thompson/random-passwords/issues/4

### UPDATE, Tue 2019-02-27 :

I've corrected a minor formatting bug, an incorrect interaction between
the "`-split N`" option and the `-1digit` et al singleton options.

https://github.com/Keith-S-Thompson/random-passwords/issues/3

### UPDATE, Mon 2018-06-04 :

I've added options to `gen-password` to require specified single
characters.  For example, if a site requires at least one decimal
digit and one punctuation character, you can use:

    gen-password -len 12 -lower -1decimal -1punctuation

Some sites restrict which punctuation characters can be used.  Use the
`-1charset` option for that (which can be given multiple times).

### UPDATE, Wed 2014-08-06 :

A very minor bug in `gen-password` caused a warning message:

    defined(@array) is deprecated at /home/kst/bin/gen-password line 151.
            (Maybe you should just omit the defined()?)

to appear when using recent versions of Perl.  (The warning appears
with Perl 5.16.3, but not with Perl 5.14.4.)  This bug had no effect
other than printing the warning message.  I've corrected it.

### UPDATE, Sat 2014-04-12 :

A bug was recently discovered in the `gen-passphrase` command.
This bug did not affect the security of the generated passphrases,
but it did cause the command to go into an infinite loop if the
provided dictionary is very long (specifically, if there are more
than 65536 candidate words to choose from).

An update I made a few days ago did not correctly fix this problem.
It avoided the infinite loop, but caused the program to ignore all
but the first 65536 eligible words.  In some cases this could create
a bias for words earlier in the alphabet.  This shouldn't have caused
a problem if you specify the initials of the random words (unless you
have a *huge* dictionary), but it could show up if you instead specify
the number of words.  It could also cause a generated passphrase to be
(slightly) less secure than implied by statistics reported with the
"-v" option.

The problem is now corrected, and `gen-passphrase` should in principle
handle up to 2<sup>32</sup> words (though it would probably run out
of memory before that).

My thanks to Jimmy Wales (yes, *that* [Jimmy
Wales](http://en.wikipedia.org/wiki/Jimmy_wales)) for finding and
reporting the original bug, and for letting me know that somebody
out there is actually using this.

---

`random-passwords` is released under GPL version 2 or later.  See the
header comments in `gen-passphrase` and `gen-password` and the file
`COPYING`.

This is a small collection of utilities, written in Perl, for
generating random passwords and passphrases.

`gen-password` generates a random password of a specified length
(the default is 12 characters) from a specified character set.

`gen-passphrase` generates a random passphrase consisting of words from
a dictionary (`/usr/share/dict/words` by default), in the spirit of
[this XKCD cartoon](http://xkcd.com/936/).

Both utilities obtain random data from `/dev/urandom` by
default, but can be told to use `/dev/random`, which is much
slower. They will not work on systems that do not have these
device files. (I could have had it falling back to Perl's built-in
[rand()](http://perldoc.perl.org/functions/rand.html) function, but its
documentation explicitly says that it's not cryptographically secure.)

Note that the default `/dev/urandom` is almost
certainly random enough for most purposes. See [this
answer](http://superuser.com/a/359601/92954) I posted on
[superuser.com](http://superuser.com/) for more discussion.

---

## `gen-password`

This is the output of `gen-password -help2`:
```
NAME
    gen-password - Generate random passwords

SYNOPSIS
    gen-password [options]

     Options:
        -help|-help1|-help2  Show short|medium|long usage message
        -man                 Show long usage message (invokes pager)

    Too many options to show here.

    Use -help1, -help2, or -man to see more options.

DESCRIPTION
    gen-password generates random passwords.

    It is part of the random-passwords package, available at

    <https://github.com/Keith-S-Thompson/random-passwords>

    More documentation is available there.

    By default, a 12-character password is generated, consisting of
    lowercase letters and decimal digits. Options let you control the length
    and valid characters, and to add specified single characters (for
    example if you need a 16-character password with 1 digit, 1 uppercase
    letter, and 1 punctuation character).

    There is currently no option to use non-ASCII characters.

OPTIONS
    All options may be abbreviated uniquely. -help may be abbreviated as -h.

    -help
        Show short usage message

    -help1
        Show medium usage message

    -help2
        Show long usage message

    -man
        Show long usage message using perldoc, invokes pager

    -n  Don't print a newline after the password

    -length N
        Length of generated password, default is 12

    -charset ...
        Character set, default is "a-z0-9"

        The argument is a single word.

    -decimal, -digits
        Equivalent to -charset 0-9

    -hexadecimal
        Equivalent to -charset 0-9a-f

    -Hexadecimal
        Equivalent to -charset 0-9A-F

    -octal
        Equivalent to -charset 0-7

    -lower
        Equivalent to -charset a-z

    -upper
        Equivalent to -charset A-Z

    -alphanumeric
        Equivalent to -charset A-Za-z0-9

    -printable
        Equivalent to "-charset !-~" (ASCII non-blank printable characters)

    -1lower
        Include (at least) 1 lower case letter

    -1upper
        Include (at least) 1 upper case letter

    -1decimal -1digit
        Include (at least) 1 decimal digit

    -1punctuation
        Include (at least) 1 punctuation character

    -1charset ...
        Include (at least) 1 character from the specified set

        This option may be given multiple times. (The other -1... options
        may only be given once.) Use -1charset 0-9 -1charset 0-9 for 2
        decimal digits.

        NOTE: A literal hyphen - character should be specified first or
        last; otherwise it specifies a range.

    -split N
        Split with a blank every N characters

    -dev-random
        Use /dev/random rather than /dev/urandom

        This can be much slower and is probably unnecessary.

    -debugging
        Produce debugging output (developer option)

SEE ALSO
    gen-password, also part of the random-passwords package.

    <https://github.com/Keith-S-Thompson/random-passwords>.

AUTHOR
    Keith Thompson <Keith.S.Thompson@gmail.com>

LICENSE AND COPYRIGHT
    random-password is released under GPL version 2 or later.
```

The program assumes an ASCII character set. For example, it assumes that 
the set of lower case letters is `'a'` .. `'z'` 

---

## `gen-passphrase`

This is the output of `gen-passphrase -help2`:
```
NAME
    gen-passphrase - Generate random passphrases

SYNOPSIS
    gen-passphrase [options] initials|word-count min-len max-len

     Options:
        -help|-help1|-help2  Show short|medium|long usage message
        -man                 Show long usage message (invokes pager)

        -n                Don't print a newline after the passphrase
                          (This interacts poorly with "-verbose")
        -[no]suffix       Allow/disallow words ending in s, ed, ing (enabled by default)
        -verbose          Show statistics about the strength of the passphrase
        -dictionary file  Use specified word list
                          Default is /usr/share/dict/words or $PASSPHRASE_DICT
        -dev-random       Use /dev/random rather than /dev/urandom (slow)
        -debugging        Produce debugging output (developer option)

DESCRIPTION
    gen-passphrase generates random passphrases.

    It is part of the random-passwords package, available at

    <https://github.com/Keith-S-Thompson/random-passwords>

    More documentation is available there.

    gen-passphrase was partly inspired by this XKCD cartoon:
    <http://xkcd.com/936/>, which suggests using long passphrases consisting
    of randomly selected English words. The example in the cartoon was
    "correct horse battery staple" (of course you shouldn't use *that*
    specific passphrase).

    The passphrase consists of a sequence of words randomly selected from
    the specified word list file. Only words consisting entirely of ASCII
    lower-case letters are considered. The three command-line arguments
    (following any options) are:

    1. Either a string of ASCII lowercase letters or a decimal integer
    specifying the number of words;

    2. The minimum length of each word; and

    3. The maximum length of each word.

OPTIONS
    All options may be abbreviated uniquely. -help may be abbreviated as -h.

    -help
        Show short usage message

    -help1
        Show medium usage message

    -help2
        Show long usage message

    -man
        Show long usage message using perldoc, invokes pager

    -n  Don't print a newline after the passphrase.

        (This interacts poorly with the -verbose option.)

    -[no]suffix
        -suffix, the default, allows words ending in s, ed, and ing (which
        are typically forms of other words).

        -nosuffix excludes such words. This typically reduces the number of
        available words by about half. If you use this option, use -verbose
        to see the effects, and consider using more and/or longer words.

    -verbose
        Show statistics about the strength of the passphrase

    -dictionary *file*
        Use specified word list

        Default is /usr/share/dict/words or $PASSPHRASE_DICT

    -dev-random
        Use /dev/random rather than /dev/urandom

        This can be much slower and is probably unnecessary.

    -debugging
        Produce debugging output (developer option)

SEE ALSO
    gen-passphrase, also part of the random-passwords package.

    <https://github.com/Keith-S-Thompson/random-passwords>.

AUTHOR
    Keith Thompson <Keith.S.Thompson@gmail.com>

LICENSE AND COPYRIGHT
    random-passphrase is released under GPL version 2 or later.
```

The passphrase consists of a sequence of words randomly selected
from the specified word list file.  The three command-line arguments
(following any options) are:

1. Either:

   * A string of ASCII lowercase letters, specifying the initials
   of the generated passphrase; or
   * A decimal integer specifying the number of words (each of which
   will be selected randomly from the entire word list);

2. The minimum length of each word; and

3. The maximum length of each word.

This was partly inspired by [this XKCD cartoon](http://xkcd.com/936/),
which suggests using long passphrases consisting of randomly selected
English words.  The example in the cartoon was "correct horse battery
staple" (of course you shouldn't use *that* specific passphrase).

With the first option, giving a string of lowercase letters as the
first argument, you can specify a known word that will remind you
of the passphrase; for example, "hello" might yield "hellion erosion
leprosy legless outlook".

Words are randomly selected from the word list file, usually
`/usr/share/dict/words`. Only lines consisting entirely of
lowercase letters are considered. You can specify a different
dictionary file by using the `-dictionary` option or by setting the
`$PASSPHRASE_DICT` environment variable. (For example, Cygwin has no
`/usr/share/dict/words`, so I set `$PASSPHRASE_DICT` to point to a copy
from my Ubuntu system).

With the `-verbose` option, `gen-passphrase` shows some statistics
about the estimated strength of the generated passphrase, based on the
number of possibilities for each word. The statistics shown will depend
on the size of the dictionary file being used. For example, on Solaris
9 `/usr/dict/words` has 20,068 qualifying entries; on Ubuntu 12.04
`/usr/share/dict/words` has 62,887, and on Centos 5.7 it has 355,543.

Here's an example of `gen-passphrase` with options that *could*
generate "correct horse battery staple", executed on Ubuntu 12.04:
```
$ gen-passphrase -v chbs 5 7
chasing hearsay bygones smocked
    1881 * 843 * 1586 * 2817
    7.0844e12 possibilities, equivalent to:
    42.69 random bits,
    9.08 random lowercase letters,
    7.17 random mixed-case alphanumerics,
    6.51 random printable ASCII characters
```

and on CentOS 5.7, with a much larger dictionary:
```
$ gen-passphrase -v chbs 5 7
cepous halpace bundist subfix
    7117 * 2895 * 5952 * 9233
    1.1322e15 possibilities, equivalent to:
    50.01 random bits
    10.64 random lowercase letters
    8.40 random mixed-case alphanumerics
    7.63 random printable ASCII characters
```

This indicates that the generated passphrase on Ubuntu is approximately
as secure as `vsxdrnhli` (9 random lowercase letters) or `0Z4sLMl` (7
random mixed-case alphanumeric characters). Using a larger dictionary
gives better results, but can result in a passphrase that's more
difficult to remember (*"cepous halpace bundist subfix"? Really?*).

Note that this shows the number of possibilities *given the criteria
you chose*. With the Ubuntu example above ("chasing hearsay bygones
smocked"), a hypothetical attacker has over 7 trillion possibilities to
consider *if* they know that your passphrase consists of 4 words
starting with 'c', 'h', 'b', and 's', with 5 to 7 letters in each word.
Without that knowledge, the attacker's problem space is much larger.

---

If you find any bugs in these programs, *particularly* any security holes, please let me know.

-- Keith Thompson <[Keith.S.Thompson@gmail.com](mailto:Keith.S.Thompson@gmail.com)>
