package Test::WOAx::App::REST::Simple::Map;
use strict;

my $map = [
    {
        regexp      => '/version$',
        func_name	=>	'version',
        out			=>	{ mime_type => 'application/xml', view_method => 'xml' },
        req_method  => 'GET'
    },

];

sub get_map { return $map; }

1;

__END__


=head1 NAME

Test::WOAx::App::REST::Simple::Map - []

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

WOA.LABS E<lt>woa.develop.labs at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by WOA.LABS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut