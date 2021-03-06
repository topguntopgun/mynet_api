#! /usr/bin/perl
##
## vtysh/extract.pl.  Generated from extract.pl.in by configure.
##
## Virtual terminal interface shell command extractor.
## Copyright (C) 2000 Kunihiro Ishiguro
##
## This file is part of GNU Zebra.
##
## GNU Zebra is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by the
## Free Software Foundation; either version 2, or (at your option) any
## later version.
##
## GNU Zebra is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with GNU Zebra; see the file COPYING.  If not, write to the Free
## Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
## 02111-1307, USA.
##

print <<EOF;
#include <zebra.h>
#include "command.h"
#include "vtysh.h"

EOF

$ignore{'"router test"'} = "ignore";
$ignore{'"acl ""<2000-5999>"""'} = "ignore";
$ignore{'"acl ipv6 <1-3999>"'} = "ignore";
$ignore{'"interface ge"'} = "ignore";
$ignore{'"interface xge"'} = "ignore";
$ignore{'"interface link-aggregation"'} = "ignore";
$ignore{'"interface gtf <0-0>"'} = "ignore";
$ignore{'"interface mgmt"'} = "ignore";
$ignore{'"interface vlanif ""<1-4092>"'} = "ignore";
$ignore{'"interface vlanif ""<1-4094>"'} = "ignore";
$ignore{'"dba-profile {profile-id <0-128>|profile-name PROFILE-NAME}"'} = "ignore";
$ignore{'"dba-profile"'} = "ignore";
$ignore{'"ont-srvprofile gtf {profile-id <1-512>|profile-name PROFILE-NAME}"'} = "ignore";
$ignore{'"ont-srvprofile gtf"'} = "ignore";
$ignore{'"ont-lineprofile gtf {profile-id <1-512>|profile-name PROFILE-NAME}"'} = "ignore";
$ignore{'"ont-lineprofile gtf"'} = "ignore";
$ignore{'"ont-slaprofile {profile-id <1-256>|profile-name PROFILE-NAME}"'} = "ignore";
$ignore{'"ont-slaprofile"'} = "ignore";
$ignore{'"classification {profile-id <1-512>|profile-name PROFILE-NAME}"'} = "ignore";
$ignore{'"classification"'} = "ignore";
$ignore{'"exit"'} = "ignore";
$ignore{'"end"'} = "ignore";
$ignore{'"show process"'} = "ignore";
$ignore{'"multicast-vlan ""<1-4092>"'} = "ignore";
$ignore{'"multicast-vlan ""<1-4094>"'} = "ignore";
$ignore{'"btv"'} = "ignore";

$ignore{'"line vty"'} = "ignore";
$ignore{'"who"'} = "ignore";
$ignore{'"terminal monitor"'} = "ignore";
$ignore{'"terminal no monitor"'} = "ignore";
$ignore{'"show history"'} = "ignore";

$ignore{'"yes"'} = "ignore";
$ignore{'"no"'} = "ignore";
$ignore{'"y"'} = "ignore";
$ignore{'"n"'} = "ignore";
$ignore{'"load configuration ftp A.B.C.D USER-NAME USER-PASSWORD FILE-NAME"'} = "ignore";
$ignore{'"erase saved-config"'} = "ignore";
$ignore{'"manufacture"'} = "ignore";
$ignore{'"ont delete ""<1-16>"" all"'} = "ignore";
$ignore{'"ont delete ""<1-8>"" all"'} = "ignore";
$ignore{'"ont delete ""<1-4>"" all"'} = "ignore";
$ignore{'"ont delete ""<1-4>"" all"'} = "ignore";
$ignore{'"dhcp-snooping (disable|enable)"'} = "ignore";
$ignore{'"debug"'} = "ignore";
$ignore{'"terminal debugging"'} = "ignore";
$ignore{'"acl ""<8000-8199>"""'} = "ignore";

foreach (@ARGV) {
    $file = $_;

    open (FH, "$ENV{CROSS_COMPILE}gcc -E -D$ENV{TF_PRODUCT} -D$ENV{CPU_ENDIAN} -DHAVE_CONFIG_H -DVTYSH_EXTRACT_PL -I./include -I../lib -I../../include -I../switch/include -I$ENV{SWSDK_DIR}/include -I$ENV{APP_DIR}/include -I$ENV{COM_DIR}/include -I$ENV{SYSTEM_DIR}/include $ENV{GTF_INC} $ENV{GTF_SUB_INC_DIRS} $ENV{APP_DIR}/gtf/profile/include $ENV{APP_DIR}/gtf/tfcfg/include $file |");
    local $/; undef $/;
    $line = <FH>;
    close (FH);

    @defun = ($line =~ /(?:DEFUN|ALIAS)\s*\((.+?)\);?\s?\s?\n/sg);
    @install = ($line =~ /install_element\s*\(\s*[0-9A-Z_]+,\s*&[^;]*;\s*\n/sg);
    @install2 = ($line =~ /install_element_with_right\s*\(\s*[0-9A-Z_]+,\s*[0-9A-Z_|\s]+,\s*&[^;]*;\s*\n/sg);
    @install3 = ($line =~ /install_element_with_style\s*\(\s*[0-9A-Z_]+,\s*[0-9A-Z_|\s]+,\s*&[^;]*;\s*\n/sg);

    # DEFUN process
    foreach (@defun) {
	my (@defun_array);
	@defun_array = split (/,/);
	$defun_array[0] = '';


	# Actual input command string.
	$str = "$defun_array[2]";
	$str =~ s/^\s+//g;
	$str =~ s/\s+$//g;

	# Get VTY command structure.  This is needed for searching
	# install_element() command.
	$cmd = "$defun_array[1]";
	$cmd =~ s/^\s+//g;
	$cmd =~ s/\s+$//g;

        # $protocol is VTYSH_PROTO format for redirection of user input
        if ($file =~ /lib\/vty\.c$/) {
           $protocol = "VTYSH_ALL";
        }
    elsif ($file =~ /^.*\/([a-z0-9]+)\/gtf\/[a-zA-Z0-9_\-]+\/src\/[a-zA-Z0-9_\-]+\.c$/) {
           $protocol = "VTYSH_GTF";
        }
	else {
           ($protocol) = ($file =~ /^.*\/([a-z0-9]+)\/src\/[a-zA-Z0-9_\-]+\.c$/);
           $protocol = "VTYSH_" . uc $protocol;
        }

	# Append _vtysh to structure then build DEFUN again
	$defun_array[1] = $cmd . "_vtysh";
	$defun_body = join (", ", @defun_array);

	# $cmd -> $str hash for lookup
	$cmd2str{$cmd} = $str;
	$cmd2defun{$cmd} = $defun_body;
	$cmd2proto{$cmd} = $protocol;
    }

    # install_element() process
    foreach (@install) {
	my (@element_array);
	@element_array = split (/,/);

	# Install node
	$enode = $element_array[0];
	$enode =~ s/^\s+//g;
	$enode =~ s/\s+$//g;
	($enode) = ($enode =~ /([0-9A-Z_]+)$/);

	# VTY command structure.
	($ecmd) = ($element_array[1] =~ /&([^\)]+)/);
	$ecmd =~ s/^\s+//g;
	$ecmd =~ s/\s+$//g;

	# Register $ecmd
	if (defined ($cmd2str{$ecmd})
	    && ! defined ($ignore{$cmd2str{$ecmd}})) {
	    my ($key);
	    $key = $enode . "," . $cmd2str{$ecmd};
	    $ocmd{$key} = $ecmd;
	    $odefun{$key} = $cmd2defun{$ecmd};
	    push (@{$oproto{$key}}, $cmd2proto{$ecmd});
	}
    }

    # install_element() process
    foreach (@install2) {
	my (@element_array);
	@element_array = split (/,/);

	# Install node
	$enode = $element_array[0];
	$enode =~ s/^\s+//g;
	$enode =~ s/\s+$//g;
	($enode) = ($enode =~ /([0-9A-Z_]+)$/);

	# VTY right.
	$eright = $element_array[1];
	$eright =~ s/^\s+//g;
	$eright =~ s/\s+$//g;
	($eright) = ($eright =~ /([0-9A-Z_|\s]+)$/);

	# VTY command structure.
	($ecmd) = ($element_array[2] =~ /&([^\)]+)/);
	$ecmd =~ s/^\s+//g;

	# Register $ecmd
	if (defined ($cmd2str{$ecmd})
	    && ! defined ($ignore{$cmd2str{$ecmd}})) {
	    my ($key);
	    $key  = $enode . "," . $cmd2str{$ecmd};
	    $ocmd{$key} = $ecmd;
	    $odefun{$key} = $cmd2defun{$ecmd};
	    $oright{$key} = $eright;
	    push (@{$oproto{$key}}, $cmd2proto{$ecmd});
	}
    }

    # install_element() process
    foreach (@install3) {
	my (@element_array);
	@element_array = split (/,/);

	# Install node
	$enode = $element_array[0];
	$enode =~ s/^\s+//g;
	$enode =~ s/\s+$//g;
	($enode) = ($enode =~ /([0-9A-Z_]+)$/);

	# VTY right.
	$estyle = $element_array[1];
	$estyle =~ s/^\s+//g;
	$estyle =~ s/\s+$//g;
	($estyle) = ($estyle =~ /([0-9A-Z_|\s]+)$/);

	# VTY command structure.
	($ecmd) = ($element_array[2] =~ /&([^\)]+)/);
	$ecmd =~ s/^\s+//g;

	# Register $ecmd
	if (defined ($cmd2str{$ecmd})
	    && ! defined ($ignore{$cmd2str{$ecmd}})) {
	    my ($key);
	    $key  = $enode . "," . $cmd2str{$ecmd};
	    $ocmd{$key} = $ecmd;
	    $odefun{$key} = $cmd2defun{$ecmd};
	    $ostyle{$key} = $estyle;
	    push (@{$oproto{$key}}, $cmd2proto{$ecmd});
	}
    }
}

# Check finaly alive $cmd;
foreach (keys %odefun) {
    my ($node, $str) = (split (/,/));
    my ($cmd) = $ocmd{$_};
    $live{$cmd} = $_;
}

# Output DEFSH
foreach (keys %live) {
    my ($proto);
    my ($key);
    $key = $live{$_};
    $proto = join ("|", @{$oproto{$key}});
    printf "DEFSH ($proto$odefun{$key})\n\n";
}

# Output install_element
print <<EOF;
void
vtysh_init_cmd ()
{
EOF

foreach (keys %odefun) {
    my ($node, $str) = (split (/,/));
    $cmd = $ocmd{$_};
    $cmd =~ s/_cmd/_cmd_vtysh/;
    $right = $oright{$_};
	$style = $ostyle{$_};
    if (defined $right) {
        printf "  install_element_with_right ($node, $right, &$cmd);\n";
    }
    elsif (defined $style) {
        printf "  install_element_with_style ($node, $style, &$cmd);\n";
    }
    else {
        printf "  install_element ($node, &$cmd);\n";
    }
}

print <<EOF
}
EOF
