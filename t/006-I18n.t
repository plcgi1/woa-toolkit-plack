use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Builder;
use HTTP::Cookies;
use POSIX;
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
); 
use Test::WOAx::App::REST::Simple::SP;
use Plack::Middleware::WOAx::App;

my $app = Plack::Middleware::WOAx::App->new({
    service_provider    => 'Test::WOAx::App::REST::Simple::SP',
    \%ENV
});

$app = builder {
    enable "Session",   store       => "File";
    enable "I18n", prefix => 'Test::WOAx::App::I18n';
    
    mount "/version" => $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    
    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/version?lang=ru'));
    like $res->content, '/Версия/';
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    
    my $req = HTTP::Request->new();
    $req->method('GET');
    $req->uri('http://localhost/version');
    $req->header('Accept-Language' => 'ru-RU,ru;q=0.8');
    my $res = $cb->($req);

    like $res->content, '/Версия/';
    
    my $cookie_jar = HTTP::Cookies->new();
    $cookie_jar->extract_cookies( $res );
    
    $req = HTTP::Request->new();
    $req->header('Cookie' => 'plack_session='.$cookie_jar->{COOKIES}->{"localhost.local"}->{"/"}->{plack_session}->[1].';');
    $req->method('GET');
    $req->uri('http://localhost/version');
    $res = $cb->($req);
    like $res->content, '/Версия/';
};

done_testing;