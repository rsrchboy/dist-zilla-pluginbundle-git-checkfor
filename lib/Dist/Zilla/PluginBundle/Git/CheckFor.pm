package Dist::Zilla::PluginBundle::Git::CheckFor;

# ABSTRACT: All Git::CheckFor plugins at once

use Moose;
use namespace::autoclean;

with 'Dist::Zilla::Role::PluginBundle::Easy';

sub configure {
    my ($self) = @_;

    $self->add_plugins(
        [ 'Git::CheckFor::CorrectBranch' => $self->config_slice('release_branch') ],
        'Git::CheckFor::Fixups',
    );

    return;
}



__PACKAGE__->meta->make_immutable;

!!42;

__END__

=for Pod::Coverage configure

=head1 SYNOPSIS

    ; in dist.ini
    [@Git::CheckFor]

=head1 DESCRIPTION

This bundles several plugins that do some sanity/lint checking of your git
repository; namely: you're on the right branch and you haven't forgotten any
autosquash commits (C<fixup!> or C<squash!>).

=head1 SEE ALSO

L<Dist::Zilla::Plugin::Git::CheckFor::Fixups>

L<Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch>

L<Dist::Zilla::PluginBundle::Git>

=cut
