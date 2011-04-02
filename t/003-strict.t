use Test::Strict;
use FindBin qw($Bin);
use lib (
    $Bin,
    $Bin.'/../lib',
);

$Test::Strict::TEST_SYNTAX = 1;
$Test::Strict::TEST_STRICT = 0;
$Test::Strict::TEST_WARNINGS = 0;

all_perl_files_ok("./lib"); # Syntax ok and use strict;

all_cover_ok(80);    # at least 80% test coverage