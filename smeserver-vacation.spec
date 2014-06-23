# $Id: smeserver-vacation.spec,v 1.4 2013/07/15 23:31:55 unnilennium Exp $
# Authority: dungog
# Name: Stephen Noble

%define name smeserver-vacation
%define version 1.0
%define release 41
Summary: SME Server enhancement to enable vacation messages for users.
Name: %{name}
Version: %{version}
Release: %{release}%{?dist}
License: GNU GPL version 2
URL: http://www.dungog.net/sme
Group: SMEserver/addon
Source: %{name}-%{version}.tar.gz
BuildArchitectures: noarch
BuildRoot: /var/tmp/%{name}-%{version}
Requires: e-smith-release >= 7.0,
Requires: e-smith-formmagick >= 1.4.0-12
BuildRequires: e-smith-devtools >= 1.13.1-03
AutoReqProv: no

%description
SME Server enhancement to enable vacation messages for users.
Optionally provides a user-manager panel where users can
enable vacation for themselves and to modify their own message

%changelog
* Mon Jul 15 2013 JP Pialasse <tests@pialasse.com> 1.0-41.sme
- apply locale 2013-07-15 patch

* Sun Mar 06 2011 SME Translation Server <translations@contribs.org> 1.0-40.sme
- apply locale 2011-03-06 patch

* Sun May 23 2010 SME Translation Server <translations@contribs.org> 1.0-39.sme
- apply locale 2010-05-23 patch

* Tue Oct 27 2009 SME Translation Server <translations@contribs.org> 1.0-38.sme
- apply locale 2009-10-27 patch

* Mon Aug 24 2009 SME Translation Server <translations@contribs.org> 1.0-37.sme
- apply locale 2009-08-24 patch

* Thu Jun 11 2009 Stephen Noble <support@dungog.net> - 1.0-36
- send vacation mail in utf8 [SME 4389]

* Sat Jun 06 2009 Stephen Noble <support@dungog.net> - 1.0-35
- cp .qmail fragment before SME filtering with filterorder prop [SME: 5327]

* Wed May 20 2009 SME Translation Server <translations@contribs.org> 1.0-34.sme
- apply locale 2009-05-20 patch

* Mon Apr 27 2009 SME Translation Server <translations@contribs.org> 1.0-33.sme
- apply locale 2009-04-27 patch

* Sun Mar  1 2009 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-32
- Apply  1 Mar 2009 locale patch [SME: 5018]

* Thu Jan  1 2009 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-31
- Apply  1 Jan 2009 locale patch [SME: 4900]

* Tue Oct 14 2008 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-30
- Apply 14 Oct 2008 locale patch

* Sat Sep 27 2008 Stephen Noble <support@dungog.net> - 1.0-29
- move .qmail fragment after SME forwarding [SME: 4603]
- Apply 27 August 2008 locale patch

* Sat Aug 13 2008 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-28
- Add precedence list to ignore functions to ignore, for instance, 
  mail from contribs.org mailinglists [SME: 4549]

* Tue Aug 12 2008 Gavin Weight <gweight@gmail.com> 1.0-27
- Fix Locale to read vacation panel correctly. [SME: 4311] 

* Tue Jul 1 2008 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-26
- Apply 1 July 2008 locale patch

* Mon May 5 2008 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-25
- Apply 5 May 2008 locale patch

* Mon Apr 28 2008 Shad L. Lords <slords@mail.com> 1.0-24
- Convert dos line endings to unix

* Sat Apr 26 2008 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-23
- Add common <base> tags to e-smith-formmagick's general

* Tue Apr 22 2008 Jonathan Martens <smeserver-contribs@snetram.nl> 1.0-22
- Apply 22 April 2008 locale patch

* Tue Apr 1 2008 Shad L. Lords <slords@mail.com> 1.0-21
- Update to UTF-8 translations

* Fri Mar 14 2008 Stephen Noble <support@dungog.net> - 1.0-20
- update locale 2008-03-14, removed -13

* Fri Mar 14 2008 Stephen Noble <support@dungog.net> - 1.0-19
- update locale 2008-03-13

* Wed Mar 12 2008 Shad L. Lords <slords@mail.com> - 1.0-18
- Add requires for e-smith-formmagick for UTF-8 support [SME: 3858]

* Tue Mar 11 2008 Stephen Noble <support@dungog.net> - 1.0-17
- remove dud es patch

* Tue Mar 11 2008 Stephen Noble <support@dungog.net> - 1.0-16
- update locale 2008-03-11

* Sat Mar 07 2008 Stephen Noble <support@dungog.net> - 1.0-15
- prepare en lexicons for pootle translations

* Wed Dec 26 2007 Stephen Noble <support@dungog.net> 1.0-14
- fix spanish translation

* Mon Oct 29 2007 Stephen Noble <support@dungog.net> 1.0-13
- add spanish translation, thanks Normando Hall [SME 3503]

* Thu Jun 14 2007 Stephen Noble <support@dungog.net>
- apply updates up to -11

* Sun Apr 29 2007 Shad L. Lords <slords@mail.com>
- Clean up spec so package can be built by koji/plague

* Fri Dec 29 2006  Stephen Noble <support@dungog.net>
- display Vacation status correctly on modify page in server-manager [sme 2200]
- [1.0-11]

* Thu Dec 07 2006 Shad L. Lords <slords@mail.com>
- Update to new release naming.  No functional changes.
- Make Packager generic

* Mon Oct 30 2006  Stephen Noble <support@dungog.net>
- display description unshaded *
- german lexicon fix
- cosmetic log error fixed [sme 1992]
- [1.0-10]

* Thu Aug 24 2006 Stephen Noble <support@dungog.net>
- now finds corrects vacation text when used under userpanel.
- german translation [sme 1101]
- [1.0-9]

* Wed Apr 6 2006 Stephen Noble <support@dungog.net>
- suppress description if no users [contribs 1243]
- [1.0-8]

* Wed Apr 6 2006 Stephen Noble <support@dungog.net>
- say no users if none exist [contribs 1243]
- display DomainName in email address [contribs 1242]
- [1.0-7]

* Wed Apr 6 2006 Stephen Noble <support@dungog.net>
- unlink .vacation.msg before writing [contribs 1192]
- vacation doesn't respond to spam [contribs 1190]
- [1.0-6]

* Sat Mar 25 2006 Stephen Noble <support@dungog.net>
- updated lexicons
- removed event
- [1.0-5]

* Fri Mar 24 2006 Stephen Noble <support@dungog.net>
- Change the interval between repeat replies to the same sender
- config setprop qmail VacationDelay -t3d, man vacation
- reset vacationDB when setting status to no
- modified to, Subject: Re: $SUBJECT - Away from my email
- updated fr lexicon
- [1.0-4]

* Wed Mar 22 2006 Stephen Noble <support@dungog.net>
- updated lexicons
- [1.0-3]

* Wed Mar 22 2006 Stephen Noble <support@dungog.net>
- fr lexicon
- expand ~/.qmail on uninstall
- [1.0-2]

* Mon Mar 20 2006 Stephen Noble <support@dungog.net>
- FormMagick version
- [1.0-1]

* Mon Dec 12 2005 Stephen Noble <support@dungog.net>
- Strip out DOS Carriage Returns (CR)
- thanks to mike sensney
- [0.9-2]

* Sat Sep 03 2005 Stephen Noble <support@dungog.net>
- renamed smeserver-vacation,
- contains vacation & userpanel-vacation
- [0.9-1]

* Sat Sep 03 2005 David Beveridge <davidb@nass.com.au>
- [0.3-2]
- upgrade to work with AccountsDB on SME 7.0

* Mon Dec 31 2001 Daniel van Raay <danielvr@caa.org.au>
- [0.2-4]
- Added generated 'From:' lines to default reply message
- Minor cosmetic cleaning

* Fri Nov 23 2001 Daniel van Raay <danielvr@caa.org.au>
- [0.2-3]
- .vacation.db files are now deleted in the user-modify event

* Tue Nov 14 2001 Daniel van Raay <danielvr@caa.org.au>
- [0.2-2]
- fixed bug in vacation script that delivered multiple bounces to users

* Mon Sep 04 2001 Daniel van Raay <danielvr@caa.org.au>
- [0.2-1]
- added -j option to vacation command line
- updated for compatibility with e-smith 4.1

* Wed Dec 27 2000 Daniel van Raay <danielvr@caa.org.au>
- [0.1-1]
- initial release

%prep
%setup

%build
perl createlinks

LEXICONS=$(find root/etc/e-smith/{locale/,web/functions/} -type f )
for lexicon in $LEXICONS
do
    /sbin/e-smith/validate-lexicon $lexicon
done

LINKS=$(find root/etc/e-smith/locale/ -type d -maxdepth 1 | sed 's/root\/etc\/e-smith\/locale\///')
for link in $LINKS
do
 /bin/ln -s uservacations root/etc/e-smith/locale/$link/etc/e-smith/web/functions/userpanel-vacation
done

%install
rm -rf $RPM_BUILD_ROOT
(cd root   ; find . -depth -print | cpio -dump $RPM_BUILD_ROOT)
rm -f %{name}-%{version}-filelist
/sbin/e-smith/genfilelist $RPM_BUILD_ROOT \
     --file '/usr/local/bin/vacation' 'attr(0755,root,root)' \
     > %{name}-%{version}-filelist
echo "%doc COPYING"  >> %{name}-%{version}-filelist

%clean
rm -rf $RPM_BUILD_ROOT

%pre
%preun

%post
if [ -d /etc/e-smith/events/conf-userpanel ] ; then
   /sbin/e-smith/signal-event conf-userpanel
fi

%postun
#uninstall
if [ $1 = 0 ] ; then

 DBS=`find /home/e-smith/db/navigation -type f -name "navigation.*"`
 for db in $DBS ; do
          /sbin/e-smith/db $db delete userpanel-vacation 2>/dev/null
          /sbin/e-smith/db $db delete uservacations 2>/dev/null
	done
	
 #need to expand ~/.qmail for users who are still enabled
 /etc/e-smith/events/actions/qmail-update-user

fi


%files -f %{name}-%{version}-filelist
%defattr(-,root,root)
