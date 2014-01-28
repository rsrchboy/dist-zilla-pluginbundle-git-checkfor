#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Dist::Zilla::Role::Git::Repo::More;
BEGIN {
  $Dist::Zilla::Role::Git::Repo::More::AUTHORITY = 'cpan:RSRCHBOY';
}
$Dist::Zilla::Role::Git::Repo::More::VERSION = '0.009';
# ABSTRACT: A little more than Dist::Zilla::Role::Git::Repo

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

with
    'Dist::Zilla::Role::Git::Repo',
    ;

has _repo => (is => 'lazy', isa => 'Git::Wrapper');
sub _build__repo {
  require Git::Wrapper;
  Git::Wrapper->new(shift->repo_root)
}


# -- attributes

#has version_regexp => (is => 'rwp', isa=>'Str', lazy => 1, predicate => 1, builder => sub { '^v(.+)$' });
#has first_version  => (is => 'rwp', isa=>'Str', lazy => 1, predicate => 1, default => sub { '0.001' });

has _previous_versions => (

    traits  => ['Array'],
    is      => 'lazy',
    isa     => 'ArrayRef[Str]',
    handles => {

        has_previous_versions => 'count',
        previous_versions     => 'elements',
        earliest_version      => [ get =>  0 ],
        last_version          => [ get => -1 ],
    },
);

sub _build__previous_versions {
  my ($self) = @_;

  local $/ = "\n"; # Force record separator to be single newline

  require Git::Wrapper;
  my $git  = Git::Wrapper->new( $self->repo_root );
  my $regexp = $self->version_regexp;

  my @tags = $git->tag;
  @tags = map { /$regexp/ ? $1 : () } @tags;

  # find tagged versions; sort least to greatest
  my @versions =
    sort { version->parse($a) <=> version->parse($b) }
    grep { eval { version->parse($_) }  }
    @tags;

  return [ @versions ];
}

# -- role implementation

#sub provide_version {
  #my ($self) = @_;

  ## override (or maybe needed to initialize)
  #return $ENV{V} if exists $ENV{V};

  #return $self->first_version
    #unless $self->has_previous_versions;

  #my $last_ver = $self->last_version;
  #my $new_ver  = Version::Next::next_version($last_ver);
  #$self->log("Bumping version from $last_ver to $new_ver");

  #return "$new_ver";
#}

!!42;

__END__

=pod

=encoding UTF-8

=for :stopwords Chris Weyl Christian Walde <walde.christian@googlemail.com> Karen Etheridge
<ether@cpan.org> Mike Doherty <doherty@cs.dal.ca> Olivier Mengué
<dolmen@cpan.org>

=head1 NAME

Dist::Zilla::Role::Git::Repo::More - A little more than Dist::Zilla::Role::Git::Repo

=head1 VERSION

This document describes version 0.009 of Dist::Zilla::Role::Git::Repo::More - released January 28, 2014 as part of Dist-Zilla-PluginBundle-Git-CheckFor.

=head1 SYNOPSIS

    # ta-da!
    with 'Dist::Zilla::Role::Git::Repo::More';

=head1 DESCRIPTION

This is a role that extends L<Dist::Zilla::Role::Git::Repo> to provide an
additional private attribute.  There's probably nothing here you'd be terribly
interested in.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla::PluginBundle::Git::CheckFor|Dist::Zilla::PluginBundle::Git::CheckFor>

=item *

L<Dist::Zilla::Role::Git::Repo>

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

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
