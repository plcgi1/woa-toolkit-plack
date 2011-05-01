use inc::Module::Install;

# Define metadata
name 'WOA';
abstract
  'web oriented toolkit for easy building REST services - Plack middlware';
version '0.001';
author 'plcgi1@gmail.com';
license 'perl';

# Specific dependencies
requires 'CGI::Cookie';
requires 'Plack';
requires 'WOAx::App::Test::REST::Simple::SP';
requires 'WOA::REST::ServiceProvider::Loader';

requires 'Test::Strict';
requires 'Test::Pod';
requires 'Test::Builder';
requires 'Test::Builder::Module';

requires 'Getopt::Long' => 2.38;
requires 'Pod::Usage'   => 1.36;

requires 'parent' => 0.225;

install_script glob('bin/*.pl');
auto_install;
WriteAll;

1;
