package Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch;

# ABSTRACT: Check that you're on the correct branch before release

use Moose;
use namespace::autoclean;

use Git::Wrapper;

with
    'Dist::Zilla::Role::BeforeRelease',
    'Dist::Zilla::Role::Git::Repo::More',
    ;

has release_branch => (is => 'ro', isa => 'Str', default => 'master');

sub current_branch {
    my $self = shift @_;

    my ($branch) = map { /^\*\s+(.+)/ ? $1 : () } $self->_repo->branch;
    return $branch;
}

sub before_release {
    my $self = shift @_;

    my $cbranch = $self->current_branch;
    my $rbranch = $self->release_branch;

    my $fatal_msg
        = !$cbranch                 ? 'Cannot determine current branch!'
        : $cbranch eq '(no branch)' ? 'You do not appear to be on any branch.  This is almost certainly an error.'
        : $cbranch ne $rbranch      ? "Your current branch ($cbranch) is not the release branch ($rbranch)"
        :                             undef
        ;

    $self->log_fatal($fatal_msg) if $fatal_msg;

    # if we're here, we're good
    $self->log("Current branch ($cbranch) and release branch match ($rbranch)");
    return;
}

__PACKAGE__->meta->make_immutable;

!!42;

__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Dist::Zilla>

=cut

