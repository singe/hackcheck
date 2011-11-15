#!/usr/bin/perl -w

#Dominic White
#http://singe.rucus.net/
#Aug 7th 2005
#GPL'ed

#Checks DSheilds 'Are you cracked?' site to see if an IP address is listed
#in the DShield database as an attacker
#http://www.dshield.org/warning_explanation.php

use strict;
use LWP::Simple qw($ua get);
use HTML::TokeParser;

#Proxy init
#my proxy="http://username:password@proxy.org:3128";
my $proxy="";
$ua->proxy('http',$proxy);

#Var init
my $ip="";
my $content="";
my $stream="";
my $output="";

#Get cmd line IP
$ip = (($#ARGV == 0) ? $ARGV[0] : "");

#If no cmd line then use default
if ($ip eq "") {
	$content = get("http://www.dshield.org/warning_explanation.php");
} else {
	$content = get("http://www.dshield.org/warning_explanation.php?fip=$ip");
}
die "Couldn't fetch the page, something is wrong. Check that your proxy and the
URL work.\n" unless defined $content;

#Init tokenizer
$stream = HTML::TokeParser->new(\$content) ||
	die "There was an error reading the page.\n";

#We want the 3rd <img> tag
$stream->get_tag("img");
$stream->get_tag("img");
$stream->get_tag("img");

#The good stuff is in the <b> tag
$stream->get_tag("b");

#Output data
$output = $stream->get_trimmed_text("/b");
$ip=$output;
$ip =~ s/^.*IP.\((.*)\).*$/$1/;

if ($output =~ /does not appear/) {
	print "$ip is Safe\n";
} else {
	$output =~ s/^.*attacker.(.*).times.*$/$1/;
	print "$ip is Hacked : It appears $output times.\n";
	exit 1; #Exit with a return code of 1
}
