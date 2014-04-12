Copyright (C) 2014 Keith Thompson

### UPDATE, Thu 2014-04-10 :

A bug in `gen-passphrase` caused it to go into an infinite loop if the
number of selected words (words from the dictionary file consisting
entirely of lower case letters) exceeds 65536.  I've patched the
command to increase the upper bound to 16777216.  I'll work on a more
robust patch later.  Please let me know if you run into any problems.
My thanks to the person who pointed this out (who may or may not wish
to be identified).

### UPDATE, Sat 2014-04-12 :

The fix for the bug was not entirely correct. It avoids the infinite
loop, but it still limits the generated random numbers to the range
0..65535.  This means that if you have a large dictionary file, only
the first 65536 qualifying words will be considered, which in some
cases will create a bias for words that appear early in the alphabet.
I expect to have a fix for this bug before anyone has a chance to
read this note.

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

# `gen-password`

`gen-password -help` shows the following message:

    Usage: gen-password [options]
        -help         Display this message and exit
        -length N     Length of generated password, default is 12
        -charset ...  Character set, default is "a-z0-9"
                      The argument is a single word.
        -decimal      Equivalent to "-charset 0-9"
        -hexadecimal  Equivalent to "-charset 0-9a-f"
        -Hexadecimal  Equivalent to "-charset 0-9A-F"
        -octal        Equivalent to "-charset 0-7"
        -lower        Equivalent to "-charset a-z"
        -upper        Equivalent to "-charset A-Z"
        -alphanumeric Equivalent to "-charset A-Za-z0-9"
        -printable    Equivalent to "-charset !-~"
                      (ASCII non-blank printable characters)
        -split N      Split with a blank every N characters
        -dev-random   Use /dev/random rather than /dev/urandom (slow)
        -debugging    Produce debugging output

The program assumes an ASCII character set. For example, it assumes that 
the set of lower case letters is `'a'` .. `'z'` 

---

# `gen-passphrase`

`gen-password -help` shows the following message:

    Usage: gen-passphrase [options] initials   min-len max-len
           gen-passphrase [options] word-count min-len max-len
        -help             Show this message and exit
        -verbose          Show statistics about the strength of the passphrase
        -dictionary file  Use specified word list
                          Default is /usr/share/dict/words or $PASSPHRASE_DICT
        -dev-random       Use /dev/random rather than /dev/urandom (slow)
        -debugging        Produce debugging output

Option names may be abbreviated; for example, "-verbose" may be given as "-v".
The passphrase consists of a sequence of words randomly selected
from the specified word list file.
The first argument is either a string of lowercase letters
(specifying the initial letters of the generated passphrase) or a
decimal integer specifying the number of words.
"min-len" and "max-len" are decimal integers determine the lengths
of the chosen words

The passphrase consists of a sequence of words randomly selected
from the specified word list file.  The three command-line arguments
(following any options) are:

1. Either:

   * A string of ASCII lowercase letters, specifying the initials
   of the generated passphrase; or
   * A decimal integer specifying the
   number of words (each of which will be selected randomly from the
   entire word list);

2. The minimum length of each word; and

3. The maximum length of each word.

This was partly inspired by [this XKCD cartoon](http://xkcd.com/936/),
which suggests using long passphrases consisting of randomly selected
English words.  The example in the cartoon was "correct horse battery
staple" (of course you shouldn't use *that* specific passphrase).

With the first option, giving a string of lowecase letters as the
first argument, you can specify a known word that will remind you
of the passphrase; for example, "hello" might yield "hellion erosion
leprosy legless outlook".

Words are randomly selected from `/usr/share/dict/words`. Only lines
consisting entirely of lowercase letters are considered. You can
specify a different dictionary file by using the `-dictionary` option
or by setting the `$PASSPHRASE_DICT` environment variable. (For
example, Cygwin has no `/usr/share/dict/words`, so set
`$PASSPHRASE_DICT` to point to a copy from my Ubuntu system).

With the `-verbose` option, `gen-passphrase` shows some statistics
about the estimated strength of the generated passphrase, based on the
number of possibilities for each word. The statistics shown will depend
on the size of the dictionary file being used. For example, on Solaris
9 `/usr/dict/words` has 20,068 qualifying entries; on Ubuntu 12.04
`/usr/share/dict/words` has 62,887, and on Centos 5.7 it has 355,543.

Here's an example of `gen-passphrase` with options that *could*
generate "correct horse battery staple", executed on Ubuntu 12.04:

    $ gen-passphrase -v chbs 5 7
    chasing hearsay bygones smocked
        1881 * 843 * 1586 * 2817
        7.0844e12 possibilities, equivalent to:
        42.69 random bits,
        9.08 random lowercase letters,
        7.17 random mixed-case alphanumerics,
        6.51 random printable ASCII characters

and on CentOS 5.7, with a much larger dictionary:

    $ gen-passphrase -v chbs 5 7
    ciders honour blowout scamles
        7117 * 2895 * 5952 * 9233
        1.1322e15 possibilities, equivalent to:
        50.01 random bits,
        10.64 random lowercase letters,
        8.40 random mixed-case alphanumerics,
        7.63 random printable ASCII characters

This indicates that the generated passphrase on Ubuntu is approximately
as secure as `vsxdrnhli` (9 random lowercase letters) or `0Z4sLMl` (7
random mixed-case alphanumeric characters). Using a larger dictionary
gives better results, but can result in a passphrase that's more
difficult to remember (*scamles??*).

Note that this shows the number of possibilities *given the criteria
you chose*. With the Ubuntu example above ("chasing hearsay bygones
smocked"), a hypothetical attacker has over 7 trillion possibilities to
consider *if* he or she knows that your passphrase consists of 4 words
starting with 'c', 'h', 'b', and 's', with 5 to 7 letters in each word.
Without that knowledge, the attacker's problem space is much larger.

---

If you find any bugs in these programs, *particularly* any security holes, please let me know.

-- Keith Thompson <[Keith.S.Thompson@gmail.com](mailto:Keith.S.Thompson@gmail.com)>, Sat 2012-09-29
