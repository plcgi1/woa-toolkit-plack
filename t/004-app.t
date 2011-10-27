use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Builder;
use POSIX;
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);
use Plack::Middleware::WOAx::App;
use Test::WOAx::App::REST::Simple::SP;
use WOA::REST::ServiceProvider::Loader;

my $app = Plack::Middleware::WOAx::App->new({
    service_provider    => 'Test::WOAx::App::REST::Simple::SP',
    {}
});

$app = builder {
    mount "/version" => $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/version'));
    like $res->content, '/VERSION/';

};

$app = Plack::Middleware::WOAx::App->new({
    service_provider =>  WOA::REST::ServiceProvider::Loader->new({rules => { path => '/version', class => 'Test::WOAx::App::REST::Simple::SP' }}),
});

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/woax/test/rest/simple?what=thing'));
    like $res->{_rc}, '/404/';

};
done_testing;