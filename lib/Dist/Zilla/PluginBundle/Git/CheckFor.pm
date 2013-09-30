#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Dist::Zilla::PluginBundle::Git::CheckFor;
BEGIN {
  $Dist::Zilla::PluginBundle::Git::CheckFor::AUTHORITY = 'cpan:RSRCHBOY';
}
{
  $Dist::Zilla::PluginBundle::Git::CheckFor::VERSION = '0.007';
}
# git description: 0.006-14-g425b56f


# ABSTRACT: All Git::CheckFor plugins at once

use Moose;
use namespace::autoclean;

with 'Dist::Zilla::Role::PluginBundle::Easy';

sub configure {
    my ($self) = @_;

    $self->add_plugins(
        [ 'Git::CheckFor::CorrectBranch' => $self->config_slice('release_branch') ],
        'Git::CheckFor::Fixups',
        'Git::CheckFor::MergeConflicts',
    );

    return;
}



__PACKAGE__->meta->make_immutable;

!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Karen Etheridge Mike Doherty <ether@cpan.org>
<doherty@cs.dal.ca>

=head1 NAME

Dist::Zilla::PluginBundle::Git::CheckFor - All Git::CheckFor plugins at once

=head1 VERSION

This document describes version 0.007 of Dist::Zilla::PluginBundle::Git::CheckFor - released September 29, 2013 as part of Dist-Zilla-PluginBundle-Git-CheckFor.

=head1 SYNOPSIS

    ; in dist.ini
    [@Git::CheckFor]

=head1 DESCRIPTION

This bundles several plugins that do some sanity/lint checking of your git
repository; namely: you're on the right branch and you haven't forgotten any
autosquash commits (C<fixup!> or C<squash!>).

=for Pod::Coverage configure

=for :spelling autosquash

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla::Plugin::Git::CheckFor::Fixups>

=item *

L<Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch>

=item *

L<Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts>

=item *

L<Dist::Zilla::PluginBundle::Git>

=back

=head1 SOURCE

The development version is on github at L<http://github.com/RsrchBoy/dist-zilla-pluginbundle-git-checkfor>
and may be cloned from L<git://github.com/RsrchBoy/dist-zilla-pluginbundle-git-checkfor.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/RsrchBoy/dist-zilla-pluginbundle-git-checkfor/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 CONTRIBUTORS

=over 4

=item *

Karen Etheridge <ether@cpan.org>

=item *

Mike Doherty <doherty@cs.dal.ca>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
