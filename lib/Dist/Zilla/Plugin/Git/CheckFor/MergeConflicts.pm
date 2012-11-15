package Dist::Zilla::Plugin::Git::CheckFor::MergeConflicts;
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

=for Pod::Coverage before_release mvp_multivalue_args

=head1 SYNOPSIS

    ; in dist.ini
    [Git::CheckFor::MergeConflicts]

=head1 DESCRIPTION

This is a simple L<Dist::Zilla> plugin to check that the gathered files
contain no merge conflict markers.

=head1 SEE ALSO

L<Dist::Zilla>
L<Dist::Zilla::Plugin::Git::CheckFor>

=cut
