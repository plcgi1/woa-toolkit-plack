#!/usr/bin/perl -w
use strict;
use Test::More qw/no_plan/; 
use FindBin qw($Bin);
use lib ($Bin,$Bin.'/../lib');
use Data::Dumper;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Builder;
use POSIX;
use Plack::Middleware::WOAx::App;
use WOAx::App::Test::REST::Simple::SP;

BEGIN { use_ok('Plack::Middleware::WOAx::Project'); }

my $app = Plack::Middleware::WOAx::App->new({
    service_provider    => 'WOAx::App::Test::REST::Simple::SP',
    {}
});


$app = builder {
    enable "WOAx::Project";
    mount "/version" => $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $req = HTTP::Request->new(GET => 'http://localhost/version?prj=ru');
    my $res = $cb->($req);

    like $res->headers->{'set-cookie'}, '/prj=ru/','Check project cookies';
};

$app = builder {
    enable "WOAx::Project",config => { cookie_name => 'bla' };
    mount "/version" => $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $req = HTTP::Request->new(GET => 'http://localhost/version?prj=ru');
    my $res = $cb->($req);

    like $res->headers->{'set-cookie'}, '/bla=ru/','Check project cookies';
};

$app = builder {
    enable "WOAx::Project",config => { cookie_name => 'bla' };
    mount "/version" => $app;
};
test_psgi app => $app, client => sub {
    my $cb = shift;
    my $h = HTTP::Headers->new('Cookies' => 'bla=ru;');
    my $req = HTTP::Request->new('GET', 'http://localhost/version',$h);
    
    my $res = $cb->($req);

    like $res->headers->{'set-cookie'}, '/bla=ru/','Check project cookies';
};

done_testing;