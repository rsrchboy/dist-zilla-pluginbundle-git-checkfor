package Dist::Zilla::Role::Git::Repo::More;

# ABSTRACT: A little more than Dist::Zilla::Role::Git::Repo

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

use Git::Wrapper;

with
    'Dist::Zilla::Role::Git::Repo',
    ;

has _repo => (is => 'lazy', isa => 'Git::Wrapper');

sub _build__repo { Git::Wrapper->new(shift->repo_root) }

!!42;

__END__

=head1 SYNOPSIS

    # ta-da!
    with 'Dist::Zilla::Role::Git::Repo::More';

=head1 DESCRIPTION

This is a role that extends L<Dist::Zilla::Role::Git::Repo> to provide an
additional private attribute.  There's probably nothing here you'd be terribly
interested in.

=head1 SEE ALSO

L<Dist::Zilla::Role::Git::Repo>

=cut
