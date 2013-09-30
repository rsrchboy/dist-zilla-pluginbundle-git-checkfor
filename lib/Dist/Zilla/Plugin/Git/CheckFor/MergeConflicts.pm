#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts;
BEGIN {
  $Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts::AUTHORITY = 'cpan:RSRCHBOY';
}
{
  $Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts::VERSION = '0.007';
}
use strict;
use warnings;

# ABSTRACT: Check your repo for merge-conflicted files
use Moose;
use Moose::Autobox;
use autodie qw(:io);
use namespace::autoclean;
use List::MoreUtils qw(any);

with
    'Dist::Zilla::Role::BeforeRelease',
    'Dist::Zilla::Role::Git::Repo::More',
        #-excludes => [ qw { _build_version_regexp _build_first_version } ],
    ;

has merge_conflict_patterns => (
    is => 'ro',
    isa => 'ArrayRef[RegexpRef]',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $repo = $self->_repo;
        my ($branch) = $repo->branch;
        return [
            qr/^=======/,
            qr/^<<<<<<< Updated upstream/,
            qr/^>>>>>>> Stashed changes/,
            qr/^<<<<<<< HEAD/,
            qr/^>>>>>>> \Q$branch\E/,
        ];
    },
);

has ignore => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    predicate => 'has_ignore',
);

sub mvp_multivalue_args { qw( ignore ) }

sub before_release {
    my $self = shift;

    my %error_files;
    FILE:
    foreach my $file ( $self->zilla->files->flatten ) {
        next FILE
            if $self->has_ignore
            and any { $file->name eq $_ } @{ $self->ignore };

        my $text = $file->content;
        foreach my $re ( @{ $self->merge_conflict_patterns } ) {
            open my $from_mem_fh, '<', \$text;
            while (<$from_mem_fh>) {
                if ( m/($re)/ ) {
                    push @{ $error_files{ $file->name } }, "matched $re at line $.";
                }
            }
        }
    }

    if (%error_files) {
        my $error_msg = "Aborting release; found merge conflict markers:\n";
        while ( my ($filename, $error) = each %error_files ) {
            $error_msg .= "$filename $_\n" for @$error;
        }
        $self->log_fatal( $error_msg );
    }

    $self->log('No merge conflict markers found; OK to release');
    return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Karen Etheridge <ether@cpan.org> Mike Doherty
<doherty@cs.dal.ca>

=head1 NAME

Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts - Check your repo for merge-conflicted files

=head1 VERSION

This document describes version 0.007 of Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts - released September 29, 2013 as part of Dist-Zilla-PluginBundle-Git-CheckFor.

=head1 SYNOPSIS

    ; in dist.ini
    [Git::CheckFor::MergeConflicts]

=head1 DESCRIPTION

This is a simple L<Dist::Zilla> plugin to check that the gathered files
contain no merge conflict markers.

=for Pod::Coverage before_release mvp_multivalue_args

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla::PluginBundle::Git::CheckFor|Dist::Zilla::PluginBundle::Git::CheckFor>

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Plugin::Git::CheckFor>

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
