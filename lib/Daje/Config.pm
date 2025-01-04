package Daje::Config;
use Mojo::Base -base, -signatures;


use Mojo::JSON qw {decode_json from_json};
use Mojo::File;

# NAME
# ====
#
# Daje::Config - Loads the JSON based configs and put them in a hash
#
# SYNOPSIS
# ========
#
#    use Daje::Config;
#
#    # Single file
#    my $config = Daje::Config->new(
#       path => "path",
#    )->load($filename);
#
#    # All files in path
#    my $config = Daje::Config->new(
#       path => "path",
#    )->load();
#
#
# DESCRIPTION
# ===========
#
# Daje::Config is loading workflows from JSON files in a set folder
#
# LICENSE
# =======
#
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
# ======
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#

our $VERSION = "0.05";

has 'path';
has 'type' => "config";

# Load all workflows in the given path
sub load($self, $filename = "") {
    my $config;
    unless (defined $filename and length($filename) > 0) {
        my $collection = $self->_load_list();
        $collection->each(sub($file, $num) {
            $config = $self->_load_config($config, $file);
        });
    } else {
        my $path = $self->path();
        $path .= "/" unless (substr($path, -1) eq "/");
        $config = $self->_load_config($config, $path . $filename);
    }
    return $config;
}

sub _load_config($self, $config, $file) {
    my $path = Mojo::File->new($file);
    my $tag = substr($path->basename(), 0, index($path->basename(), '.json'));
    $config->{$tag} = from_json($path->slurp())->{$self->type()};

    return $config;
}

# List of workflows in path (for internal use)
sub _load_list($self) {
    my $collection;
    eval {
        my $path = Mojo::File->new($self->path());
        $collection = $path->list();
    };

    return $collection;
}

1;
__END__





#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME


Daje::Workflow::Loader::Load - Loads the JSON based workflows and put them in a hash



=head1 SYNOPSIS


   use Daje::Config;

   # Single file
   my $config = Daje::Config->new(
      path => "path",
   )->load($filename);

   # All files in path
   my $config = Daje::Config->new(
      path => "path",
   )->load();




=head1 DESCRIPTION


Daje::Config is loading workflows from JSON files in a set folder



=head1 REQUIRES

L<Mojo::File> 

L<Mojo::JSON> 

L<Mojo::Base> 


=head1 METHODS

=head2 load($self,

 load($self,();

Load all workflows in the given path



=head1 AUTHOR


janeskil1525 E<lt>janeskil1525@gmail.comE<gt>



=head1 LICENSE


Copyright (C) janeskil1525.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.



=cut

