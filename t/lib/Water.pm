package Water;
use Acme::Colour;

sub new {
  bless { colour => Acme::Colour->new("white") }, shift;
}

sub colour {
  my $self = shift;
  my $colour = shift;
  if (defined $colour) {
    $self->{colour} = Acme::Colour->new($colour);
  } else {
    my $colour = $self->{colour}->colour;
    $colour = "clear" if $colour eq "white";
    return $colour;
  }
}

sub dye {
  my $self = shift;
  my $ink = shift;
  $self->{colour}->mix($ink, 0.5);
}

1;
