#!/usr/bin/perl -w
use strict;
use Test::More qw/no_plan/; 
use FindBin qw($Bin);
use lib ($Bin,$Bin.'/../lib');
use Data::Dumper;

BEGIN { use_ok('Plack::Middleware::WOAx::Project'); }