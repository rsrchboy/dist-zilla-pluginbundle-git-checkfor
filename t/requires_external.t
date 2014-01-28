#!perl
#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#

use Test::Most;
plan tests => 1;
bail_on_fail if 0;
use Env::Path 'PATH';

ok(scalar PATH->Whence($_), "$_ in PATH") for qw(git);

