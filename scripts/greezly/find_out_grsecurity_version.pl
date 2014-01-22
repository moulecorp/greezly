#!/usr/bin/perl

# Copyright (C) 2014, Antoine Tenart <atenart@n0.pe>

use strict;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new ();

$mech->get ('https://grsecurity.net/download.php');
die "Connexion error" unless $mech->success ();

my $link = $mech->find_link (text_regex => qr/\.patch$/, n => 1);
print $link->text ();
