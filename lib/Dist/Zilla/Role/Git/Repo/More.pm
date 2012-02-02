package Dist::Zilla::Role::Git::Repo::More;

# ABSTRACT: Check your repo for fixup! and squash! before release

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

=head1 DESCRIPTION

=head1 SEE ALSO

L<Dist::Zilla>

=cut

