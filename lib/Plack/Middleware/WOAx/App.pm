package Plack::Middleware::WOAx::App;
use strict;
use warnings;
use parent qw(Plack::Middleware Class::Accessor::Fast);
use Plack::Request;
use Plack::Session;
use Carp qw(croak);
use Data::Dumper;
use HTTP::Exception;

__PACKAGE__->mk_accessors(
    qw(service_provider sp_param config formatter cache tt error_handler));

sub prepare_app {
    my $self = shift;
    my $env  = shift;
    $env->{'psgix.session.options'} = $self->{config}->{session};
    $ENV{TMPDIR} = $self->{config}->{session}->{dir};
    return;
}

sub call {
    my $self = shift;
    my $env  = shift;

    my $req = Plack::Request->new($env);

    #my $session = Plack::Session->new($env);
    my ($sp_class,$cant_load_error);
    
    $self->_set_path_info_to_env($env);    
    if ( ref $self->{service_provider} ) {
        $self->{service_provider}->load( $env->{'PATH_INFO'}, $self->{config}->{app_name} );

        if ( $self->{service_provider}->loaded_class ) {
            $sp_class = $self->{service_provider}->loaded_class;
        }
        else {
            $cant_load_error = 1;
        }
    }
    else {
        $sp_class = $self->{service_provider};
    }
    my $res;
    if ( $cant_load_error ) {
        $res = $self->_error($req,$env->{'PATH_INFO'} . '  '. $self->{service_provider}->error,$self->{service_provider} );
    }
    else {
        $res = $self->_success($sp_class,$env,$req);
    }
    
    return $res->finalize;
}

# not found err
sub _error {
    my($self,$req,$error,$loader) = @_;
    #my $res = $req->new_response( 404 );
    #if ( $self->{default_locations}->{404} ) {
    #    $res->headers( { Location => $self->{default_locations}->{404} } );
    #}
    #return $res;
    #if ( $self->config->{default}->{locations}->{404} ) {
    #    my $res = $req->new_response( 302 );
    #    $res->headers( { Location => $self->config->{default}->{locations}->{404} } );
    #    $res->{env}->{'psgix.logger'}({level => 'debug', message => $error });
    #    return $res;
    #}
    #else {
        my $e = HTTP::Exception->new(500);
        $e->status_message($error);
        $e->throw;
    #}
}

sub _success {
    my($self,$sp_class,$env,$req) = @_;
    my $sp = $sp_class->new( {}, $self->{sp_param} );
    my %hash;
    if ( $self->{sp_param} ) {
        %hash = $self->{sp_param};
    }
    
    my $rest = $sp->service_object(
        {
            config    => $self->{config},
            model     => $self->{model},
            formatter => $self->{formatter},
            session   => $env->{'psgix.session'},
            cache     => $self->{cache},
            env       => $env,
            log       => $self->{log} || $env->{'psgix.logger'},
            renderer  => $self->{renderer},
            fast_storage  => $self->{fast_storage},
            request   => $req,
            app_name  => $self->{config}->{app_name},
            %hash
        }
    );
    if ( $rest->can('cache') ) {
        $rest->cache( $self->{cache} );
    }
    $rest->env($env);
    $rest->request($req);
    
    $rest->process;

    my $res = $req->new_response( $rest->status );
    if ( $res->{status} eq '303' ) {
        $res->headers( { Location => $rest->location } );
    }
    else {
        $res->content_type( $rest->content_type );
        $res->body( $rest->output );
    }
    $res->status( $rest->status );
    if ( $rest->cookies ) {
        $res->headers( { 'Set-Cookie' => $rest->cookies } );
    }

    if ( $rest->headers ) {
        $res->headers( $rest->headers );
    }
    $env->{'psgix.session'} = $rest->backend->get_session;
    $env->{'psgix.session'} ||= {};
    
    return $res;
}

sub _set_path_info_to_env {
    my($self,$env)=@_;
    # $env->{'PATH_INFO'} in nginx-fcgi is empty by default
    unless ( $env->{'PATH_INFO'} ) {
        ($env->{'PATH_INFO'}) = split '\?',$env->{REQUEST_URI};     
    }
    return;
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
