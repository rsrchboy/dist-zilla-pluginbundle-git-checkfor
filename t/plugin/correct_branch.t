use strict;
use warnings;

use autodie 'system';
use IPC::System::Simple (); # for autodie && prereqs

use File::chdir;
use Path::Class;

use Test::More;
use Test::Fatal;
use Test::Moose::More 0.004;
use Test::TempDir;

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

sub make_test_repo {
    my @commands = @_;

    my $tempdir = tempdir;
    my $repo_root = dir($tempdir)->absolute;
    note "Repo being created at $repo_root";
    local $CWD = "$repo_root";

    unshift @commands, 'git init'
        unless $commands[0] =~ /git init/;

    system "($_) 2> /dev/null > /dev/null" for @commands;

    return $repo_root;
}

sub _ack {
    my ($fn, $text) = @_;
    $text ||= 'whee';

    return (
        qq{echo "$text" >> $fn},
        qq{git add $fn && git commit -m "ack"},
    );
}

# blatantly stolen from Dist-Zilla-Plugin-CheckPrereqsIndexed-0.008/t/basic.t
# Write the log messages as diagnostics:
sub diag_log
{
  my $tzil = shift;

  # Output nothing if all tests passed:
  my $all_passed = shift;
  $all_passed &&= $_ for @_;

  return if $all_passed;

  diag(map { "$_\n" } @{ $tzil->log_messages });
}

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
