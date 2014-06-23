#----------------------------------------------------------------------
#  uservacations.pm
#  support@dungog.net
#----------------------------------------------------------------------

package esmith::FormMagick::Panel::uservacations;

use strict;
use warnings;

use esmith::util;
use esmith::FormMagick;
use esmith::AccountsDB;
use esmith::ConfigDB;

use Exporter;
use Carp qw(verbose);

use HTML::Tabulate;

our @ISA = qw(esmith::FormMagick Exporter);

our @EXPORT = qw();

our $db  = esmith::ConfigDB->open();
our $adb = esmith::AccountsDB->open();

our $PanelUser = $ENV{'REMOTE_USER'} ||'';
$PanelUser = $1 if ($PanelUser =~ /^([a-z][\.\-a-z0-9]*)$/);

sub new {
    shift;
    my $self = esmith::FormMagick->new(filename => '/etc/e-smith/web/functions/uservacations');
    $self->{calling_package} = (caller)[0];
    bless $self;
    return $self;
}


#server-manager functions
sub user_accounts_exist
{
    my $self = shift;
    my $q = $self->{cgi};
    #return scalar $adb->users;
    if (scalar $adb->users)
    { return $self->localise('DESCRIPTION'); }
}

sub print_vacation_table
{
    my $self = shift;
    my $q = $self->{cgi};

    my @users = $adb->users;
    return $self->localise("ACCOUNT_USER_NONE") if (@users == 0);

    my $vacation_table =
    {
       title => $self->localise('USER_LIST_CURRENT'),

       stripe => '#D4D0C8',

       fields => [ qw(User FullName status Modify) ],

       labels => 1,

       field_attr => {
                       User          => { label => $self->localise('ACCOUNT')     },

                       FullName      => { label => $self->localise('USER_NAME') },

                       status        => { label => $self->localise('LABEL_VACATION') },

                       Modify        => {
                                           label => $self->localise('MODIFY'),
                                           link  => \&modify_link
                                        },
                      }
    };

    my @data = ();

    for my $user (@users)
    {
        # make it clearer which uses have vacation
        my $EmailVacation = $user->prop('EmailVacation') || '';
        my $status        = $user->prop('EmailVacation') || '';
        if ($status eq 'yes') { $status = 'YES'; } else { $status = ''; }

        push @data,
            { User           => $user->key,
              FullName       => $user->prop('FirstName') . " " .
                                $user->prop('LastName'),
              status         => $self->localise($status),
              EmailVacation  => $EmailVacation,
              Modify         => $self->localise('MODIFY'),
            }
    }

    my $t = HTML::Tabulate->new($vacation_table);

    $t->render(\@data, $vacation_table);
}

sub modify_link
{
    my ($data_item, $row, $field) = @_;

    return "uservacations?" .
        join("&",
        "page=0",
        "page_stack=",
        "Next=Next",
        "User="     . $row->{User},
        "FullName=" . $row->{FullName},
        "EmailVacation=" . $row->{EmailVacation},
        "wherenext=VACATION_PAGE_MODIFY");
}

# this formats the text to display on screen
sub get_vacation_text
{
    my $self = shift;
    my $q = $self->{cgi};

    my $domain = $db->get_value('DomainName');
    my $user = $q->param('User');

    my $fullname    = $adb->get_prop($user, "FirstName") . " " .
                      $adb->get_prop($user, "LastName");

    my $vfile = "/home/e-smith/files/users/$user/.vacation.msg";

    my $from = $self->localise('FROM');
    my $away = $self->localise('AWAY_FROM_MAIL');

    my $ExistingMessage = "$from $fullname &lt\;$user\@$domain&gt\;\n".
                          "$away";

    # if exists and is not empty
    if (( -e $vfile ) && (! -z $vfile ))
    {
        open (VACATION, "<$vfile")
          or die "Error: Could not open file: $vfile\n";
        my @vacationTemp;

        #reformat so email address isn't hidden inside < >
        while (<VACATION>)
        {
          $_ =~ s/</&lt\;/;
          $_ =~ s/>/&gt\;/;
          push (@vacationTemp, $_);
        }

        $ExistingMessage = join ("", @vacationTemp);

        close VACATION;
    }
    my $start = '<tr>
                 <td class="sme-noborders-label">' . $self->localise('MESSAGE') . '
                 <td class="sme-noborders-content"><TEXTAREA NAME="new_message" ROWS="10" COLS="60">';

    my $end   = '</TEXTAREA></td>
                 </tr>';

    return $start . $ExistingMessage . $end;
}

# saves the text to .vacation.msg
sub change_settings
{
    my $self = shift;
    my $q = $self->{cgi};

    my $domain = $db->get_value('DomainName');
    my $user = $q->param('User');

    my $EmailVacation  = $q->param('EmailVacation');
    my $new_message    = $q->param('new_message');
    my $vfile = "/home/e-smith/files/users/$user/.vacation.msg";

    my $fullname    = $adb->get_prop($user, "FirstName") . " " .
                      $adb->get_prop($user, "LastName");

    my $from = $self->localise('FROM');
    my $away = $self->localise('AWAY_FROM_MAIL');

    my $vacation_text   = "$from $fullname \<$user\@$domain\>\n".
                          "$away \n";

    my $reset = $vacation_text;

    # if exists and is not empty
    if (( -e $vfile ) && (! -z $vfile ))
    {
        open (VACATION, "<$vfile")
          or die "Error: Could not open file: $vfile\n";
        my @vacationTemp = <VACATION>;
        $vacation_text = join ("", @vacationTemp);

        close VACATION;
    }

    chomp $new_message;

    # reset msg to default,
    if ($new_message =~ /reset/)
    { $vacation_text = $reset; }
    else
    {
        #or save new_message
        unless ($new_message eq "")
        { $vacation_text = $new_message; }
    }

    # Strip out DOS Carriage Returns (CR)
    $vacation_text =~ s/\r//g;

    unlink $vfile;
    open (VACATION, ">$vfile")
      or die ("Error opening vacation message.\n");

    print VACATION "$vacation_text";
    close VACATION;

    esmith::util::chownFile($user, $user,
    "/home/e-smith/files/users/$user/.vacation.msg");

    $adb->set_prop($user, 'EmailVacation', $EmailVacation);

    #the first is more correct but is slower
    #system ("/sbin/e-smith/signal-event", "email-update", $user) == 0
    system ("/etc/e-smith/events/actions/qmail-update-user event $user") == 0
        or die ("Error occurred updating .qmail\n");

    if (($EmailVacation eq 'no') && ( -e "/home/e-smith/files/users/$user/.vacation"))
    {
        system ("/bin/rm /home/e-smith/files/users/$user/.vacation") == 0
          or die ("Error resetting vacation db.\n");
    }

    return $self->success("SUCCESS");
}

#userpanel functions   ######################################################
sub get_panel_user
{
    return $PanelUser;
}

sub get_full_name
{
    return  $adb->get_prop($PanelUser, "FirstName") . " " .
            $adb->get_prop($PanelUser, "LastName");
}

sub get_vacation_status
{
    return $adb->get_prop($PanelUser, "EmailVacation");
}

# this formats the text to display on screen
sub userpanel_get_vacation_text
{
    my $self = shift;
    my $q = $self->{cgi};

    my $domain = $db->get_value('DomainName');

    # single difference in userpanel function
    my $user = $PanelUser;

    my $fullname    = $adb->get_prop($user, "FirstName") . " " .
                      $adb->get_prop($user, "LastName");
    my $vfile = "/home/e-smith/files/users/$user/.vacation.msg";

    my $from = $self->localise('FROM');
    my $away = $self->localise('AWAY_FROM_MAIL');

    my $ExistingMessage = "$from $fullname &lt\;$user\@$domain&gt\;\n".
                          "$away";

    # if exists and is not empty
    if (( -e $vfile ) && (! -z $vfile ))
    {
        open (VACATION, "<$vfile")
          or die "Error: Could not open file: $vfile\n";
        my @vacationTemp;

        #reformat so email address isn't hidden inside < >
        while (<VACATION>)
        {
          $_ =~ s/</&lt\;/;
          $_ =~ s/>/&gt\;/;
          push (@vacationTemp, $_);
        }

        $ExistingMessage = join ("", @vacationTemp);

        close VACATION;
    }
    my $start = '<tr>
                 <td class="sme-noborders-label">' . $self->localise('MESSAGE') . '
                 <td class="sme-noborders-content"><TEXTAREA NAME="new_message" ROWS="10" COLS="60">';

    my $end   = '</TEXTAREA></td>
                 </tr>';

    return $start . $ExistingMessage . $end;
}

# saves the text to .vacation.msg
sub userpanel_change_settings
{
    my $self = shift;
    my $q = $self->{cgi};

    my $domain = $db->get_value('DomainName');

    # single difference in userpanel function
    my $user = $PanelUser;

    my $EmailVacation  = $q->param('EmailVacation');
    my $new_message    = $q->param('new_message');
    my $vfile = "/home/e-smith/files/users/$user/.vacation.msg";

    my $fullname    = $adb->get_prop($user, "FirstName") . " " .
                      $adb->get_prop($user, "LastName");

    my $from = $self->localise('FROM');
    my $away = $self->localise('AWAY_FROM_MAIL');

    my $vacation_text   = "$from $fullname \<$user\@$domain\>\n".
                          "$away \n";

    my $reset = $vacation_text;

    # if exists and is not empty
    if (( -e $vfile ) && (! -z $vfile ))
    {
        open (VACATION, "<$vfile")
          or die "Error: Could not open file: $vfile\n";
        my @vacationTemp = <VACATION>;
        $vacation_text = join ("", @vacationTemp);

        close VACATION;
    }

    chomp $new_message;

    # reset msg to default,
    if ($new_message =~ /reset/)
    { $vacation_text = $reset; }
    else
    {
        #or save new_message
        unless ($new_message eq "")
        { $vacation_text = $new_message; }
    }

    # Strip out DOS Carriage Returns (CR)
    $vacation_text =~ s/\r//g;

    unlink $vfile;
    open (VACATION, ">$vfile")
      or die ("Error opening vacation message.\n");

    print VACATION "$vacation_text";
    close VACATION;

    esmith::util::chownFile($user, $user,
    "/home/e-smith/files/users/$user/.vacation.msg");

    $adb->set_prop($user, 'EmailVacation', $EmailVacation);

    #the first is more correct but is slower
    #system ("/sbin/e-smith/signal-event", "email-update", $user) == 0
    system ("/etc/e-smith/events/actions/qmail-update-user event $user") == 0
        or die ("Error occurred updating .qmail\n");

    if (($EmailVacation eq 'no') && ( -e "/home/e-smith/files/users/$user/.vacation"))
    {
        system ("/bin/rm /home/e-smith/files/users/$user/.vacation") == 0
          or die ("Error resetting vacation db.\n");
    }

    return $self->success("SUCCESS");
}

1;
