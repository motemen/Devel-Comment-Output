use strict;
use Test::More tests => 2;
use File::Temp;

my $IN = <<'__IN__';
use strict;
use utf8;
use Devel::Comment::Output;

print 1 + 2, "\n";
print "foo\nbar";
print '☁';
__IN__

my $OUT = <<'__OUT__';
use strict;
use utf8;
# use Devel::Comment::Output;

print 1 + 2, "\n"; # => 3
print "foo\nbar";
# foo
# bar
print '☁'; # => ☁
__OUT__

my $temp = File::Temp->new;
print $temp $IN;
close $temp;

open (my $pipe, '-|') || exec $^X, ( map "-I$_", @INC ), $temp->filename;
is do { local $/; <$pipe> }, "3\nfoo\nbar";

open my $fh, '<', $temp->filename;

is do { local $/; <$fh> }, $OUT;
