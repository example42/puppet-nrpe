#!/usr/bin/perl
# File Managed by Puppet
#===============================================================================
#
#         FILE:  check_ageandcontent.pl
#
#        USAGE:  ./check_ageandcontent.pl  
#
#  DESCRIPTION:  Nagios plugin to check file content and age
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  Based on check_file_content.pl by Pierre Mavro (), pierre@mavro.fr
#       AUTHOR:  Alessandro Franceschi, al@lab42.it
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  30/05/2011 12:10:56
#     REVISION:  ---
#===============================================================================
#
#
#===============================================================================
#
#         FILE:  check_file_content.pl
#
#        USAGE:  ./check_file_content.pl  
#
#  DESCRIPTION:  Nagios plugin to check file content
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Pierre Mavro (), pierre@mavro.fr
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  10/05/2010 09:25:56
#     REVISION:  ---
#===============================================================================

use warnings;
use strict;
use Getopt::Long;
use File::stat;

my %RETCODES = ('OK' => 0, 'WARNING' => 1, 'CRITICAL' => 2, 'UNKNOWN' => 3);

# Help
sub help
{
    print "Usage : check_ageandcontent.pl -f file -i include -e exclude -n lines_number -m minutes [-h]\n\n";
    print "Options :\n";
    print " -f\n\tFull path to file to analyze\n";
    print " -n\n\tNumber of lines to find (default is 1)\n";
    print " -m\n\tNumber of minutes before considering a file old\n";
    print " -i\n\tInclude pattern (can add multiple include)\n";
    print " -e\n\tExclude pattern (can add multiple include)\n";
    print " -h, --help\n\tPrint this help screen\n";
    print "\nExample : check_ageandcontent.pl -f /var/log/report/check1 -i OKK -m 30 -n 0\n";
    exit $RETCODES{"UNKNOWN"};
}

sub check_args 
 {
    help if !(defined(@ARGV));
        
    my ($file,@include,@exclude);
    my $num=1;
    my $mins=5;

    # Set options
    GetOptions( "help|h" => \&help,
                "f=s"    => \$file,
                "m=s"    => \$mins,
                "i=s"    => \@include,
                "e=s"    => \@exclude,
                "n=i"    => \$num);

    unless (($file) and (@include))
    {
        &help;
    }
    else
    {
        check_soft($file,$num,$mins,\@include,\@exclude);
    }
}

sub check_soft
{
    my $file=shift;
    my $num=shift;
    my $mins=shift;
    my $ref_include=shift;
    my $ref_exclude=shift;
    my @include = @$ref_include;
    my @exclude = @$ref_exclude;
    my $i=0;

    if (!open(FILER, "<$file"))
    {
        print "Can't open $file: $!\n";
        exit $RETCODES{"CRITICAL"};
    }

    while(<FILER>)
    {
        chomp($_);
        my $line=$_;
        my $found=0;

        # Should match
        foreach (@include)
        {
            if ($line =~ /$_/)
            {
                $found=1;
                last;
            }
        }
        
        # Shouldn't match 
        if (@exclude)
        {
            foreach (@exclude)
            {
                if ($line =~ /$_/)
                {
                    $found=0;
                    last;
                }
            }
        }

        $i++ if ($found == 1);
    }
    close(FILER);
    
    if ($i > 0)
    {
        if ($i > $num)
        {
            if  ( ( time - stat($file)->mtime) >  60*$mins )
            {
                print "WARNING for $file ($i found but older than $mins mins)\n";
                exit $RETCODES{"WARNING"};
            }
            else
            {
                print "OK for $file ($i found)\n";
                exit $RETCODES{"OK"};
            }
        }
        else
        {
            print "FAILED on $file. Found only $i on $num\n";
            exit $RETCODES{"CRITICAL"};            
        }
    }
    else
    {
        print "FAILED on $file\n";
        exit $RETCODES{"CRITICAL"};
    }
}

check_args;

