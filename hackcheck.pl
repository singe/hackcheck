#!/usr/bin/perl -w

# Dominic White
# http://singe.za.net/
# Aug 7th 2005
# Updated Nov 15th 2011
# GPL'ed

# Checks if the specified machine shows up as a reported source in DShield

use strict;
use LWP::Simple qw($ua get);
use HTML::TokeParser;

# Proxy init
# my proxy="http://username:password@proxy.org:3128";
my $proxy="";
$ua->proxy('http',$proxy);

# Var init
my $ip="";
my $content="";
my $stream="";
my $output="";

# Get cmd line IP
$ip = (($#ARGV == 0) ? $ARGV[0] : "");

# If no cmd line then use default
if ($ip eq "") {
	$ip = get("http://www.whatismyip.org/");
	die "Couldn't get external IP address. Are you online, check my proxy settings?.\n" unless defined $ip;
	print "No IP provided, detected your external IP as $ip\n";
}
$content = get("http://www.dshield.org/ipinfo.html?ip=$ip");
die "Couldn't fetch the page, something is wrong. Check that your proxy and the URL work.\n" unless defined $content;

# Init tokenizer
$stream = HTML::TokeParser->new(\$content) ||
	die "There was an error reading the page.\n";

# We want the 14th <td> tag
$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");$stream->get_tag("td");
$output = $stream->get_trimmed_text("/td");

if ($output =~ /- none -/) {
	print "There are no reports for $ip\n";
} else {
	print "$ip may be Hacked : It was reported $output times.\n";
	exit 1; #Exit with a return code of 1
}
