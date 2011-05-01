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
use WOAx::App::Test::REST::Simple::SP;
use Plack::Middleware::WOAx::App;

my $app = Plack::Middleware::WOAx::App->new({
    service_provider    => 'WOAx::App::Test::REST::Simple::SP',
    \%ENV
});

$app = builder {
    enable "I18n", prefix => 'WOAx::App::Test::I18n';
    mount "/version" => $app;
};

test_psgi app => $app, client => sub {
    my $cb = shift;
    
    my $res = $cb->(HTTP::Request->new(GET => 'http://localhost/version?lang=ru'));
    like $res->content, '/Версия/';
};

done_testing;