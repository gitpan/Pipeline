package Water;

sub new {
  bless { colour => "clear" }, shift;
}

sub colour {
  my $self = shift;
  my $colour = shift;
  if (defined $colour) {
    $self->{colour} = $colour;
  } else {
    return $self->{colour};
  }
}

1;
