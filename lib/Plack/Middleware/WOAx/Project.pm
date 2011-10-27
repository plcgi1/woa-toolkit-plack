package Plack::Middleware::WOAx::Project;
use strict;
use warnings;
use parent qw(Plack::Middleware Class::Accessor::Fast);
use Plack::Request;
use Data::Dumper;
use CGI::Cookie;

__PACKAGE__->mk_accessors(qw(config));

our $DEFAULT_COOKIE_NAME = 'prj';
our $DEFAULT_PARAM_NAME  = 'prj';

sub call {
    my ( $self, $env ) = @_;

    my $req         = Plack::Request->new($env);
    my $config      = $self->config;
    my $cookie_name = $self->_get_cookie_name($config);
    my $p           = $self->_try_project( $config, $req );
    my $cookie      = $self->_make_cookie( $config, $p );
    $env->{'psgix.session'}->{$cookie_name} = $p;

    $self->response_cb(
        $self->app->($env),
        sub {
            my $res = shift;

            return unless defined $res->[2];
            return if ( Plack::Util::status_with_no_entity_body( $res->[0] ) );

            my $h = Plack::Util::headers( $res->[1] );

            $h->set( 'Set-Cookie', $cookie );
        }
    );
}

sub _get_cookie_name {
    my ( $self, $config ) = @_;
    return $config->{cookie_name} || $DEFAULT_COOKIE_NAME;
}

sub _try_project {
    my ( $self, $config, $req ) = @_;
    my $pname = $config->{param_name} || $DEFAULT_PARAM_NAME;

    my $n = $req->param($pname);
    unless ($n) {
        $pname = $config->{cookie_name} || $DEFAULT_COOKIE_NAME;
        my $cookies = $req->cookies;
        if ( $cookies->{$pname} ) {
            $n = $cookies->{$pname};
        }
    }
    return $n;
}

sub _make_cookie {
    my ( $self, $config, $p ) = @_;
    my $pname = $config->{cookie_name} || $DEFAULT_COOKIE_NAME;
    if ($p) {
        my $res = join '=', ( $pname, $p );
        $res .= ';path=/';
        return $res;
    }
    return;
}

1;

__END__

=head1 Plack::Middleware::WOAx::Project - []

=head1 SYNOPSIS

# in psgi
my $config = {
    cookie_name => prj,
    param_name  => prj
};
enable "Plack::Middleware::WOAx::Project",   config => $config;

=head1 DESCRIPTION

Set project name for example - to service two or more sites/projects with own headers/footers in templates

=head2 EXPORT

[]

=head1 SEE ALSO

[]


=head1 GIT repository

=begin html

https://github.com/plcgi1/woa-toolkit-plack

=end html


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
