#!/usr/bin/perl
#############################################################################
# Author: Timothy Mills
# Date  : 8 - 4 - 08
# File  : wiscan.pl
#
# wiscan.pl takes the output of 'iwlist scan' and makes it in an easier
# to read format for those of us who still deal with the terminal :)
#############################################################################


helpCheck();

#Run the command and suppress error output
$iwlistOut = `iwlist scan 2> /dev/null`; 

@myLines = split("\n", $iwlistOut);
@cellArr = [];

#printHeading();
#printFin("#", "Name", "Quality","Sig Lvl", "Enc", "Enc T.", "Auth T.");
#printHeading();

$currNum = 0;
varInit();

foreach (@myLines)
{
    if ($_ =~ "Cell [0-9][0-9]")
    {
	if ($currNum > 0)
	{
	    printFin($currNum, $name, $quality, $sigLvl, $enc, $encType,
		$authType);

	    varInit();
	}
	$currNum++;
    }

    $cellArr[$currNum] = $cellArr[$currNum]."$_"."\n";

    if ($_ =~ "ESSID")
    {
	handleName($_);
    }
    elsif($_ =~ "Encryption key")
    {
	handleKey($_);
    }
    elsif($_ =~ "Quality=[0-9]+/[0-9]+")
    {
	handleQuality($_);
    }
    elsif($_ =~ "IE: WPA .+ [0-9]")
    {
	handleEncType($_);
    }
    elsif($_ =~ "IE: IEEE 802.11i/WPA.+[0-9]")
    {
	handleEncType2($_);
    }
    elsif($_ =~ "Authentication Suites")
    {
	handleAuthType($_);
    }
    
}


if ($currNum > 0)
{
    printFin($currNum, $name, $quality, $sigLvl, $enc, $encType, $authType);
#    printHeading();
}
else
{
    print("No scan results :'( \n");
}

if (scalar @ARGV == 1)
{
    $myNum = ($ARGV[0] =~ "[0-9]+");
    
    print $cellArr[$ARGV[0]] if($myNum && ($ARGV[0]>0 && $ARGV[0] <= $currNum));
    
}

sub helpCheck ()
{
    foreach(@ARGV)
    {
	helpMsg() if ($_ =~ "--help");
    }

    if (scalar @ARGV == 1 && !($ARGV[0] =~ "[0-9]+"))
    {
	helpMsg();
    }
    elsif (scalar @ARGV > 1)
    {
	helpMsg();
    }
}

sub helpMsg ()
{
    printf("Usage: wiscan.pl [network number] \n\n");
    printf("wiscan is used to make the output of 'iwlist scan' be more readable"
	   ."\n");

    printf("from within a terminal. By using the optional argument you may \n");
    printf("get the full output for a network from 'iwlist scan'\n\n");

    printf("EXAMPLES: \n");
    printf("1: ./wiscan.pl   -- Lists all wireless networks within range\n");
    printf("2: ./wiscan.pl 2 -- Shows full output for second wireless network entry \n                    in the output of wiscan.pl\n");

    
    exit(0);
}
    

sub printFin()
{
    printf("%s,%s,%s,%s,%s,%s,%s\n", $_[0],
	   $_[1], $_[2], $_[3], $_[4], $_[5], $_[6]);
}

sub printHeading()
{
    printf("+ %-3s + %-22s + %-7s + %-8s + %-3s + %-6s + %-9s +",
	"---", "----------------------", "-------", "--------", "---", "------", "---------");
    
    
    printf("\n");
}

sub varInit()
{
    $name = "";
    $quality = "";
    $sigLvl = "";
    $enc = "";
    $encType = "WEP";
    $authType = "N/A";
}

sub handleEncType ()
{
    $encType = "WPA v".($_ =~ ".*[0-9]");
}

sub handleEncType2 ()
{
    $encType = "WPA2";
}

sub handleQuality ()
{
    $qual = $_[0];

    @qualArr = split(" ", $qual);

    $quality = (split("=", $qualArr[0]))[1];
    $sigLvl = (split("=", $qualArr[2]))[1]." dBm";
}

sub handleKey ()
{
    $enc = (split(":", $_[0]))[1];
}

sub handleName ()
{
    $name = (split(":", $_[0]))[1];
}

sub handleAuthType ()
{
    $authType = (split(" ", $_[0]))[4];
}


