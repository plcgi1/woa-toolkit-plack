package Plack::Session::Store::FastMmap;
use strict;
use warnings;
use Cache::FastMmap;
use Storable ();
use parent 'Plack::Session::Store';

our $VERSION   = '0.1';
our $AUTHORITY = 'cpan:HARPER';

use Plack::Util::Accessor qw[
    dir
    serializer
    deserializer
];

sub new {
    my ($class, %params) = @_;

    $params{'cache'} = Cache::FastMmap->new(share_file=>$params{storage});

    bless { %params } => $class;
}

sub fetch {
    my ($self, $session_id) = @_;

    $self->{cache}->get($session_id);
}

sub store {
    my ($self, $session_id, $session) = @_;
    $self->{cache}->set($session_id,$session);
}

sub remove {
    my ($self, $session_id) = @_;
    $self->{cache}->remove($session_id);
}

1;

__END__

=pod

=head1 NAME

Plack::Session::Store::FastMmap - FastMmap session store

=head1 SYNOPSIS

  use Plack::Builder;
  use Plack::Middleware::Session;
  use Plack::Session::Store::FastMmap;

  my $app = sub {
      return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'Hello Foo' ] ];
  };

  builder {
      enable 'Session',
          store => Plack::Session::Store::FastMmap->new(
              config => {
                expires => time_in_seconds
                storage => path_to_file
                session_key => session_cookie_name
              }
          );
      $app;
  };

=head1 DESCRIPTION

See L<Cache::FastMmap> for info

=head1 METHODS

=over 4

=item B<new ( %params )>

The C<%params> can include I<dir>, I<serializer> and I<deserializer>
options. It will check to be sure that the I<dir> is writeable for
you.

=item B<dir>

This is the directory to store the session data files in, if nothing
is provided then "/tmp" is used.

=item B<serializer>

This is a CODE reference that implements the serialization logic.
The CODE ref gets two arguments, the C<$value>, which is a HASH
reference to be serialized, and the C<$file_path> to save it to.
It is not expected to return anything.

=item B<deserializer>

This is a CODE reference that implements the deserialization logic.
The CODE ref gets one argument, the C<$file_path> to load the data
from. It is expected to return a HASH reference.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.

=cut

