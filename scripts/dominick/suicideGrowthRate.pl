#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)

#
#   Variables to be used
#
my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $filename     = $EMPTY;
my $fileStart = $EMPTY;
my $fileEnd = $EMPTY;
my $fileInc = $EMPTY;
my $fileCIS = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my @records;
my $record_count = 0;
my $record2 = 0;
my $count;
my @date;
my @gender;
my @mod;
my @age;
my @Ftotal;
my @month;
my @month1;
my @Mtotal;
my @hold;
my $suffix = ".txt";
my $baseName = "Test";
my $firstSuicideCount = 0;

# $month1[1] = "January";
# $month1[2] = "February";
# $month1[3] = "March";
# $month1[4] = "April";
# $month1[5] = "May";
# $month1[6] = "June";
# $month1[7] = "July";
# $month1[8] = "August";
# $month1[9] = "September";
# $month1[10] = "October";
# $month1[11] = "November";
# $month1[12] = "December";

#
#   Check that you have the right number of parameters
#
my $firstYear = $ARGV[0];
my $secondYear = $ARGV[1];
my $yearDifference = ($secondYear - $firstYear);
if ($#ARGV != 1 ) {
    print "Usage: readStats.pl <input csv file>\n" or
        die "Print failure\n";
    exit;
} else {
# my $firstYear = $ARGV[0];
    my $secondYear = $ARGV[1];
    $filename = "$firstYear"."$baseName"."$suffix"
#$filename = $ARGV[0];
}

#
#   Open the input file and load the contents into records array
#
open my $names_fh, '<', $filename
or die "Unable to open names file: $filename\n";

@records = <$names_fh>;

close $names_fh or
die "Unable to close: $ARGV[0]\n";   # Close the input file

#print qq["Sex","Month","Suicide"\n];

#
#   Parse each line and print out the information
#

if ($firstYear > 2002 || $secondYear > 2002)
{
    foreach my $name_record ( @records ) {
        if ( $csv->parse($name_record) ) {
            my @master_fields = $csv->fields();
            $record2++;
            $gender[$record2] = $master_fields[4];
            $date[$record2] = $master_fields[1];
            $mod[$record2] = $master_fields[2];
            $age[$record2] = $master_fields[3];
        } else {
            warn "Line/record could not be parsed: $records[$record_count]\n";
        }
        $record_count++;
    }
}
else
{
    foreach my $name_record ( @records )
    {
        if ( $csv->parse($name_record) ) 
        {
            my @master_fields = $csv->fields();
            $record2++;
            $gender[$record2] = $master_fields[4];
            $date[$record2] = $master_fields[1];
            $mod[$record2] = $master_fields[2];
        } 
        else 
        {
            warn "Line/record could not be parsed: $records[$record_count]\n";
        }

    }
}

for (my $c = 1; $c <= 12; $c++)
{
    if ($c < 10)
    {
        $month[$c] = "0".$c;
    }
    if ($c >= 10)
    {
        $month[$c] = $c;
    }
}
for (my $b = 1; $b <= 12; $b++)
{
    $count = 0;
    for (my $i = 1; $i < $record2; $i++)
    {
        if ($mod[$i] eq '2' && $date[$i] eq $month[$b] && $age[$i] > '1012' && $age[$i] < '1020')
        {
            $count++;
            $firstSuicideCount++;
        }
    }
}
my $secondSuicideCount = 12;
my $subYearDifference = (1/$yearDifference);
my $subPercentGrowthRate = ((($secondSuicideCount - $firstSuicideCount)/$firstSuicideCount) * 100);
my $percentGrowthRate = ($subPercentGrowthRate / $yearDifference);

print "Total Teen Suicides in ".$firstYear.": ".$firstSuicideCount."\n";
print "Total Teen Suicides in ".$secondYear.": ".$secondSuicideCount."\n";
print "Year Difference is ".$yearDifference."\n";
 print "The growth rate of suicides between ".$firstYear." and ".$secondYear." is ".$percentGrowthRate."%\n";

# for (my $b = 1; $b <= 12; $b++)
# {
#     $count = 0;
#     for (my $i = 1; $i < $record2; $i++)
#     {
#         if ($mod[$i] eq '2' && $gender[$i] eq 'F' && $date[$i] eq $month[$b])
#         {
#             $count++;
#         }
#     }
#     $hold[$b] = $count;
#     print "Female,".$month[$b]."/".$month1[$b].",".$hold[$b]."\n";
# }


# for (my $b = 1; $b <= 12; $b++)
# {
#     $count = 0;
#     for (my $i = 1; $i < $record2; $i++)
#     {
#         if ($mod[$i] eq '2' && $gender[$i] eq 'M' && $date[$i] eq $month[$b])
#         {
#             $count++;
#         }
#     }
#     $hold[$b] = $count;
#     print "Male,".$month[$b]."/".$month1[$b].",".$hold[$b]."\n";
# }


#
#   End of Script
#
