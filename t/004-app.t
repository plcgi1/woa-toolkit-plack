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
use WOAx::App::Test::REST::Simple::SP;
use WOA::REST::ServiceProvider::Loader;

my $app = Plack::Middleware::WOAx::App->new({
    service_provider    => 'WOAx::App::Test::REST::Simple::SP',
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
    service_provider =>  WOA::REST::ServiceProvider::Loader->new,
});

test_psgi app => $app, client => sub {
    my $cb = shift;
    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/woax/test/rest/simple?what=thing'));
    like $res->content, '/thing/';

};
done_testing;