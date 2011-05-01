package Plack::Middleware::I18n;
use strict;
use parent qw(Plack::Middleware);
use Encode;
use Plack::Util;
use Plack::Request;

sub call {
    my ($self,$env)  = @_;
    
    my $lang = $self->_try_lang($env);
    
    if ( ref $env->{'psgix.session'} eq 'HASH' ) {
        if($lang) {
            $env->{'psgix.session'}->{'lang'} = $lang;
            my $prefix = $self->{prefix};
            Plack::Util::load_class($prefix);
            
            my $lh = $prefix->get_handle($lang);
            
            bless $lh, $prefix.'::'.$lang;
            
            use Data::Dumper;
            print "$lang=".Dumper $lh;
            
            $env->{'psgix.localize'} = $lh;
        }
    }
    
    $self->response_cb($self->app->($env), sub {});
} 

sub _try_lang {
    my ($self,$env)  = @_;
    
    my $lang = $env->{'psgix.session'}->{'lang'};
    unless ( $lang ) {
        my $req = Plack::Request->new($env);
        $lang = $req->param('lang');
        unless ($lang) {
            my $v = $env->{HTTP_ACCEPT_LANGUAGE};
            ($lang) = split ',',$v;
            if ($lang=~/-/) {
                $lang = (split '-',$lang)[0];
            }
        }
    }
    return $lang;
}

1;

__END__

=head1 Plack::Middleware::I18n

=head1 SYNOPSIS

# in psgi
builder {
    # blabla
    enable "I18n", prefix => 'WOAx::App::Test::I18n';
}

# in controller
my $localize = $self->get_env->{'psgix.localize'};
if( $localize ) {
    $res = $localize->loc('Version');
}
    
=head1 DESCRIPTION

Localization simple middlware for psgi woax application

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
