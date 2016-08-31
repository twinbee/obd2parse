#!/usr/bin/perl
use strict;
#suse warnings;
use Cwd 'abs_path';

#Important strings here
my $sampleStr = "Sample";
my $stFTStr = "Short Term Fuel Trim -Bank 1\\(\%\\)";
my $ltFTStr = "Long Term Fuel Trim - Bank 1\\(\%\\)";
my $RPMStr = "Engine RPM\\(rpm\\)";
my $ITAStr = "Ignition Timing Advanece for #1 Cylinder";
my $mafRateStr = "Air Flow Rate from Mass Air Flow\\(g/s\\)";
my $throttlePosStr = "Absolute Throttle Position\\(\%\\)";
my $endSampleStr = "----------------------";
my $outLine = "";

#Important variables here
my $numArgs;
my $inFileName;
my $outFileName;

my $key;
my $value;

my $sample = 0;

#Create some file handles
my $inFileHandle;
my $outFileHandle;

#Regular variables here
my $grepLine;
my $outLine;
my @currentLine;

my $notDone;
#Get the number of args
$numArgs = $#ARGV + 1;

#Print syntax if we need to, otherwise parse the arguments
if ( $numArgs < 1) {
    print "Error: Invalid syntax\n";
    print "Usage: repConv.pl <Input file name>.txt";
    exit;
}
else {
    $inFileName = sprintf("%s.txt",$ARGV[0]);
    $outFileName = sprintf("%s.csv",$ARGV[0]);
}

#Open the input file and create the output file
open($inFileHandle, $inFileName) || die "Can't open $inFileName!\n";
open($outFileHandle, "+>$outFileName") || die "Can't create $outFileName!\n";

#Modify code found here

$notDone = 1;

$outLine = sprintf("%s,%s,%s,%s,%s,%s,%s\n", $sampleStr, $stFTStr, $ltFTStr, $RPMStr, $ITAStr, $mafRateStr, $throttlePosStr);
print $outFileHandle $outLine;
$outLine = sprintf("%s,", $sample);
print $outFileHandle $outLine;

while($notDone) {
    $grepLine = <$inFileHandle>;
    
    if($grepLine =~ /$stFTStr/) {
        @currentLine = split($stFTStr, $grepLine);
        $outLine = sprintf("%s,", trim(@currentLine[-1]));
        print $outFileHandle $outLine;
    }
    elsif($grepLine =~ /$ltFTStr/) {
        @currentLine = split($ltFTStr, $grepLine);
        $outLine = sprintf("%s,", trim(@currentLine[-1]));
        print $outFileHandle $outLine;
    }
    elsif($grepLine =~ /$RPMStr/) {
        @currentLine = split($RPMStr, $grepLine);
        $outLine = sprintf("%s,", trim(@currentLine[-1]));
        print $outFileHandle $outLine;
    }
    elsif($grepLine =~ /$ITAStr/) {
        @currentLine = split(/\)/, $grepLine);
        $outLine = sprintf("%s,", trim(@currentLine[-1]));
        print $outFileHandle $outLine;
    }
    elsif($grepLine =~ /$mafRateStr/) {
        @currentLine = split($mafRateStr, $grepLine);
        $outLine = sprintf("%s,", trim(@currentLine[-1]));
        print $outFileHandle $outLine;
    }
    elsif($grepLine =~ /$throttlePosStr/) {
        @currentLine = split($throttlePosStr, $grepLine);
        $outLine = sprintf("%s", trim(@currentLine[-1]));
        print $outFileHandle $outLine;
    }
    elsif($grepLine =~ /$endSampleStr/) {
        $sample = $sample + 1;
        $outLine = sprintf("\n%s,", $sample);
    print $outFileHandle $outLine;
    }
    
    if(eof($inFileHandle)) {
        $notDone = 0;
    }
}

print "Conversion Complete!";

#Close our input and output files
close $inFileHandle || die "Can't close $inFileName!\n";
close $outFileHandle || die "Can't close $outFileName!\n";

#Trim functions
sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };