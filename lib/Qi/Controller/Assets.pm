package Qi::Controller::Assets;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub asset {
    my $self = shift;
    
    my $tag = $self->param('tag');
    
    #If the asset is in the database, return it as json. Otherwise, return a code signifying that a new asset needs to be created for that tag
    
    my $data->{response} = "You requested tag " . $tag;
    
    $self->render(json => $data);
}

#probably should use a better name for this subroutine
sub update {
    my $self = shift;
    
    my $data;
    
    $data->{tag} = $self->param('tag');
    $data->{customer} = $self->param('customer');
    $data->{asset_type} = $self->param('asset_type');
    
    #create new asset or update an existing one
    
    $data->{response} = "updating the information in the table, or creating a new entry HAH";
    
    $self->render(json => $data);
}

sub table {
    my $self = shift;
    
    my $data->{response} = "you requested the table";
    
    $self->render(json => $data);
}

sub specialinputs {
    my $self = shift;
    
    #this will be changed to be pulled from the database from the model probably
    #or maybe just stash this data when the page is loaded
    my $data->{tag} = "nochange";
    $data->{received} = "date";
    $data->{customer} = "select";
    $data->{asset_type} = "select";
    $data->{price} = "number";
    
    $self->render(json => $data);
}

sub mastercontroller {
    my $self = shift;
    
    my $tag = $self->param('tag');
    
    my $map;
    
    #Checks if the tag has exactly 6 digits followed by a capital Y, if it does, goes in the if statement
    #  the ( ) in the expression is the selection, so anything found between the () will be extracted and placed into variable $1
    #  in this case, there will be exactly 6 digits in $1
    if($tag =~ m/(\d{6})Y/) {
        $map = eval {$self->pg->db->query('select map from barcode_map where id = ?', $1)->hash}; #move to a model
    }
    
    if($map != undef) {
        $map = $map->{map};
    }
    
    #the data to be sent back to the client
    my $data->{response} = "hello";
    
    if($map =~ m/QIM/) {
        #Could simply return the name from the barcode map has, but here it also checks the database to make sure the user has a barcode and is in the database
        if($map =~ m/_who:(.*)/) {
            $data->{name} = $self->pg->db->query('select username from users where username = ?', $1)->hash->{username}; #move to a model
        }
    }
    
    $self->render(json => $data);
}

1;
