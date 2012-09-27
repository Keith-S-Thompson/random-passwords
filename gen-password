#!/usr/bin/perl

use strict;
use warnings;

use File::Spec ();
use Getopt::Long ();

my $Program_Name = (File::Spec->splitpath($0))[2];

my %Opt = ( length => 12 );
my @Opts = ( \%Opt, qw( length=i
                        charset=s
                        decimal!
                        hexadecimal!
                        Hexadecimal|HEXADECIMAL!
                        octal!
                        lower!
                        upper!
                        alphanumeric!
                        printable!
                        split=i
                        dev-random!
                        help!
                        debugging! ) );
$Getopt::Long::ignorecase = 0; # hexadecimal vs. -Hexadecimal
Getopt::Long::GetOptions @Opts or Usage();
Usage() if $Opt{help};
Usage() if @ARGV;

$| = 1;

my $format_count = 0;
foreach my $opt (qw(charset decimal hexadecimal Hexadecimal octal
                    lower upper alphanumeric printable))
{
    $format_count ++ if defined $Opt{$opt};
}

if    ($format_count == 0) { $Opt{charset} = '0-9a-z' }
elsif ($format_count > 1)  { Usage("Use only one charset option\n") }
elsif ($Opt{decimal})      { $Opt{charset} = '0-9' }
elsif ($Opt{hexadecimal})  { $Opt{charset} = '0-9a-f' }
elsif ($Opt{Hexadecimal})  { $Opt{charset} = '0-9A-F' }
elsif ($Opt{octal})        { $Opt{charset} = '0-7' }
elsif ($Opt{lower})        { $Opt{charset} = 'a-z' }
elsif ($Opt{upper})        { $Opt{charset} = 'A-Z' }
elsif ($Opt{alphanumeric}) { $Opt{charset} = 'A-Za-z0-9' }
elsif ($Opt{printable})    { $Opt{charset} = '!-~' }

my @Valid_Chars = split //, Build_Charset($Opt{charset});

my $result = '';

for (my $i = 0; $i < $Opt{length}; $i ++) {
    $result .= $Valid_Chars[Random(scalar @Valid_Chars)];
}

if (defined $Opt{split}) {
    my $N_chars = '.' x $Opt{split};
    $result =~ s/$N_chars(?!$)/$& /g;
}

print "$result\n";

########################################################################

#
# Random($upper) returns a random number in the range 0 .. $upper-1
#
sub Random {
    my($upper) = @_;
    my $buf;
    my $short_bound = 2**16;
    my $value_bound = $short_bound - ($short_bound % $upper);
    my $value;

    # Values read from the device will be in the range 0 .. $short_bound-1
    # (0..65535).  Repeat if necessary to get a value in the range
    # 0..$value_bound-1, which is computed to avoid bias; the number of possible
    # values read is a multiple of $upper.

    my $device = $Opt{'dev-random'} ? '/dev/random' : '/dev/urandom';
    Debug("Reading from $device\n");
    open my $RANDOM, $device or die "${device}: $!\n";

    #
    # Read 2 bytes from device.
    # Discard high values to avoid bias.
    #
    do {
        my $bytes_read = read $RANDOM, $buf, 2;
        die "Failed to read from $device\n" if $bytes_read != 2;
        $value = unpack 'S', $buf;
        Debugf("Read value 0x%04x\n", $value);
    } while $value >= $value_bound;

    close $RANDOM;

    my $result = $value % $upper;
    Debugf("Random: 0x%04x %% %d --> %d\n",
           $value, $upper, $result);
    return $result;
} # Random

# ----------------------------------------------------------------------

sub Expand_Range {
    my($range) = @_;
    my $result;
    die "Internal error in Expand_Range\n" if $range !~ /^(.)-(.)$/;
    my($lo, $hi) = ($1, $2);
    die "Bad range $range\n" if ord $lo > ord $hi;
    for (my $i = ord $lo; $i <= ord $hi; $i ++) {
        $result .= chr $i;
    }
    return $result;
} # Expand_Range

# ----------------------------------------------------------------------

sub Build_Charset {
    my($charset) = @_;
    $charset =~ s/.-./Expand_Range($&)/eg;
    my %result = map { $_ => 1 } split //, $charset;
    return join '', sort keys %result;
} #  Build_Charset

# ----------------------------------------------------------------------

sub Usage {
    print @_ if defined @_;
    print <<"EOF";
Usage: $Program_Name [options]
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
EOF
    exit 1;
} # Usage

# ----------------------------------------------------------------------

sub Debug {
    print @_ if $Opt{debugging};
} # Debug

# ----------------------------------------------------------------------

sub Debugf {
    printf @_ if $Opt{debugging};
} # Debugf
