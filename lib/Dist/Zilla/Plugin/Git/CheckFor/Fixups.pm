package Dist::Zilla::Plugin::Git::CheckFor::Fixups;

# ABSTRACT: Check your repo for fixup! and squash! before release

use Moose;
use namespace::autoclean;

use Git::Wrapper;

with
    'Dist::Zilla::Role::BeforeRelease',
    'Dist::Zilla::Role::Git::Repo::More',
    ;

sub before_release {
    my $self = shift @_;

}


__PACKAGE__->meta->make_immutable;

!!42;

__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Dist::Zilla>

=cut

