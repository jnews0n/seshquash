package MyApp::Controller::Auth;
use strict;
use warnings;
use base qw( Catalyst::Controller );

sub check_login : Private {
    my ( $self, $c ) = @_;
 
    if ( $c->user_exists ) { return 1 }
 
    my $username = delete $c->request->params->{ '__username' };
    my $password = delete $c->request->params->{ '__password' };
 
    if ( $username && $password ) {
        return 1 if $c->authenticate( {
            username    => $username,
            password    => $password,
        } );
        $c->stash->{ 'error_msg' } = 'Incorrect username or password';
    }
 
    $c->stash->{ 'template' } = 'auth/login.tt2';
    return 0;
}

sub auto : Private {
    my ( $self, $c ) = @_;
 
    $c->forward( '/auth/check_login' ) || return 0;
    return 1;
}
