package Test::WOAx::App::REST::Simple::SP;
use strict;
use base 'WOA::REST::ServiceProvider';
use Data::Dumper;
use Test::WOAx::App::REST::Simple::Backend;
use Test::WOAx::App::REST::Simple::Map;
use Test::WOAx::App::REST::Simple::Engine;
use Test::WOAx::App::REST::Simple::ViewAsXML;

sub init {
    my ( $self, $env ) = @_;
    $self->{param} = $env;
    return;
}

sub service_object {
    my ( $self, $env ) = @_;
    
    my $view    = Test::WOAx::App::REST::Simple::ViewAsXML->new();
    my $backend = Test::WOAx::App::REST::Simple::Backend->new(
        {
            model       => $env->{model},
            config      => $env->{config},
            session     => $env->{'session'},
            formatter   => $env->{formatter},
            env         => $env->{env},
        }
    );
    
    my $rest = Test::WOAx::App::REST::Simple::Engine->new({
        map         =>  Test::WOAx::App::REST::Simple::Map->get_map,
        backend     =>  $backend,
        view        =>  $view,
        formatter   =>  $env->{formatter},
    });
    $rest->env($env->{env});
    
    return $rest;
}

1;


__END__


=head1 Test::WOAx::App::REST::Simple::SP

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

TODO

=head1 SEE ALSO

TODO



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
