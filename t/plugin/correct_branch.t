use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose::More 0.004;
use Test::TempDir;

require 't/funcs.pm' unless eval { require funcs };

use Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch;

my $THING = 'Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch';

validate_class $THING => (
    does => [
        'Dist::Zilla::Role::Git::Repo::More',
        'Dist::Zilla::Role::BeforeRelease',
    ],
    attributes => [ qw{ release_branch } ],
    methods    => [ qw{ current_branch } ],
);

# XXX need real tests :)

use Test::DZil;

subtest 'simple repo, on wrong, divergent branch' => sub {

    # make some basic commits, branch...
    my ($repo_root) = make_test_repo(
        'mkdir -p lib/DZT',
        _ack('lib/DZT/Sample.pm' => 'package DZT::Sample; use Something; 1;'),
        _ack(foo => 'bap'),
        _ack(bap => 'bink'),
        'git checkout -b other_branch',
        _ack(foo  => 'bink'),
        _ack(bink => 'bink'),
    );

    # ...then create a Builder and check for exception
    my $tzil = Builder->from_config(
        { dist_root => "$repo_root" },
        {
            add_files => {
                'source/dist.ini' => simple_ini(
                    qw(GatherDir Git::CheckFor::CorrectBranch FakeRelease),
                ),
            },
        },
    );

    my $dies = exception { $tzil->release };

    # e.g.: [Git::CheckFor::CorrectBranch] Your current branch (other_branch) is not the release branch (master)
    diag_log($tzil,
        like(
            $dies,
            qr/Your current branch \(.+\) is not the release branch/,
            'Correctly barfed on incorrect branch',
        ),
    );
};

done_testing;
