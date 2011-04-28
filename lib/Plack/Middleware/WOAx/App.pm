package Plack::Middleware::WOAx::App;
use strict;
use warnings;
use parent qw(Plack::Middleware Class::Accessor::Fast);
use Plack::Request;
use Plack::Session;
use Carp qw(croak);
use Data::Dumper;

__PACKAGE__->mk_accessors(qw(service_provider sp_param config formatter cache tt));

sub call {
    my $self = shift;
    my $env  = shift;

    my $req = Plack::Request->new($env);
    #my $session = Plack::Session->new($env);
    my $sp_class;

    if ( ref $self->{service_provider} ) {
        $self->{service_provider}->load($env->{'PATH_INFO'});
        
        if ( $self->{service_provider}->loaded_class ) {
            $sp_class = $self->{service_provider}->loaded_class;
        }
        else {
            croak($self->{service_provider}->error);
        }
    }
    else {
        $sp_class = $self->{service_provider};
    }
    my $sp = $sp_class->new(
        {},
        $self->{sp_param}
    );
    my %hash;
    if ( $self->{sp_param} ){
        %hash = $self->{sp_param};
    }

    my $rest = $sp->service_object({
        config      =>  $self->{config},
        model       =>  $self->{model},
        formatter   =>  $self->{formatter},
        session     =>  $env->{'psgix.session'},
        cache       =>  $self->{cache},
        env         =>  $env,
        log         =>  $self->{log},
        renderer    =>  $self->{renderer},
        request     =>  $req, 
        %hash
    });
    if ( $rest->can('cache') ){
        $rest->cache($self->{cache});
    }
    $rest->env($env);
    $rest->request($req);
    $rest->process;
    
    my $res = $req->new_response($rest->status);
    if ( $res->{status} eq '303' ) {
        $res->headers({ Location => $rest->location });
    }
    else {
        $res->content_type($rest->content_type);
        $res->body($rest->output);
    }
    $res->status($rest->status);
    if ( $rest->cookies ){
        $res->headers({ 'Set-Cookie' => $rest->cookies });
    }

    if ( $rest->headers ){
        $res->headers($rest->headers);
    }
    #if ( $env->{'psgix.logger'} ) {
    #    $env->{'psgix.logger'}->({
    #        level   => 'info',
    #        module  => 'Plack.Middleware.WOAx.App',
    #        message => '[REQUEST_AFTER_PROCESS] '.Dumper ($req->parameters)
    #    });
    #}
    return $res->finalize;
}

1;

__END__

=head1 Plack::Middleware::WOAx::App

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut