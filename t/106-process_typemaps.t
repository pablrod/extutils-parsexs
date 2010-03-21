#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use Cwd;
use File::Temp qw( tempdir );
use Test::More qw(no_plan); # tests =>  5;
use lib qw( lib );
use ExtUtils::ParseXS::Utilities qw(
  process_typemaps
);

#my ($input, $output);
#my ($result, $expected);
my ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref);
my $startdir  = cwd();
{
    my $typemap = 'typemap';
    my $tdir = tempdir( CLEANUP => 1 );
    chdir $tdir or croak "Unable to change to tempdir for testing";
    eval {
        ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref)
            = process_typemaps( $typemap, $tdir );
    };
    like( $@, qr/Can't find $typemap in $tdir/, #'
        "Got expected result for no typemap in current directory" );
    chdir $startdir;
}

{
    my $typemap = [ qw( pseudo typemap ) ];
    my $tdir = tempdir( CLEANUP => 1 );
    chdir $tdir or croak "Unable to change to tempdir for testing";
    open my $IN, '>', 'typemap' or croak "Cannot open for writing";
    print $IN "\n";
    close $IN or croak "Cannot close after writing";
    eval {
        ($type_kind_ref, $proto_letter_ref, $input_expr_ref, $output_expr_ref)
            = process_typemaps( $typemap, $tdir );
    };
    like( $@, qr/Can't find pseudo in $tdir/, #'
        "Got expected result for no typemap in current directory" );
    chdir $startdir;
}
