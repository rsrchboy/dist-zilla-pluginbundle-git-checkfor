use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.13

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Dist/Zilla/Plugin/Git/CheckFor/CorrectBranch.pm',
    'lib/Dist/Zilla/Plugin/Git/CheckFor/Fixups.pm',
    'lib/Dist/Zilla/Plugin/Git/CheckFor/MergeConflicts.pm',
    'lib/Dist/Zilla/PluginBundle/Git/CheckFor.pm',
    'lib/Dist/Zilla/Role/Git/Repo/More.pm',
    't/00-check-deps.t',
    't/00-compile.t',
    't/000-report-versions-tiny.t',
    't/funcs.pm',
    't/plugin/correct_branch.t',
    't/plugin/fixups.t',
    't/role.t'
);

notabs_ok($_) foreach @files;
done_testing;
