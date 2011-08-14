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

# check - if WOA installed
BEGIN {
    use_ok('WOA::Config::Provider');
    use_ok('WOA::REST::ServiceProvider::Loader');
    use_ok('WOAx::Helper');
    use_ok('WOAx::Helper::App');
    use_ok('WOAx::Helper::Page');
    use_ok('WOAx::Helper::Service');
    use_ok('WOAx::Helper::Map');
}

my $app1 = 'app1';
my $app2 = 'app2';
my $data = {
    $app1 => [{ path => '/fake1',class => 'Fake::Class1'},{ path => '/fake12',class => 'Fake::Class12'}],
    $app2 => [{ path => '/fake21',class => 'Fake::Class21'},{ path => '/fake22',class => 'Fake::Class22'}]
};

# create app psgi
# run it
# check registrator storage content with app rules
# check if app works fine
# delete files for app

#my $app = Plack::Middleware::WOAx::App->new({
#    service_provider    => 'WOAx::App::Test::REST::Simple::SP',
#    {}
#});
#
#$app = builder {
#    mount "/version" => $app;
#};
#
#test_psgi app => $app, client => sub {
#    my $cb = shift;
#    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/version'));
#    like $res->content, '/VERSION/';
#
#};
#
#$app = Plack::Middleware::WOAx::App->new({
#    service_provider =>  WOA::REST::ServiceProvider::Loader->new,
#});
#
#test_psgi app => $app, client => sub {
#    my $cb = shift;
#    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/woax/test/rest/simple?what=thing'));
#    like $res->content, '/thing/';
#
#};
done_testing;