use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::NoTabsTests 0.04

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Dist/Zilla/Plugin/Git/CheckFor/CorrectBranch.pm',
    'lib/Dist/Zilla/Plugin/Git/CheckFor/Fixups.pm',
    'lib/Dist/Zilla/Plugin/Git/CheckFor/MergeConflicts.pm',
    'lib/Dist/Zilla/PluginBundle/Git/CheckFor.pm',
    'lib/Dist/Zilla/Role/Git/Repo/More.pm'
);

notabs_ok($_) foreach @files;
done_testing;
