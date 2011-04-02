use inc::Module::Install;
  
# Define metadata
name        'WOA';
abstract    'web oriented arch';
version     '1.00';
author      'nobody lab';

# Specific dependencies

requires    'Class::Accessor::Fast'         => 0.31;

requires    'Test::Strict';
requires    'Test::Pod';
requires    'Test::Builder';
requires    'Test::Builder::Module';

requires    'Data::Dumper';
requires    'Plack';

auto_install;
WriteAll;

1;