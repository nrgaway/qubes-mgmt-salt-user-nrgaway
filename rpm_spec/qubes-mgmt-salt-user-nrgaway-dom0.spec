%{!?version: %define version %(cat version)}

Name:      qubes-mgmt-salt-user-nrgaway-dom0
Version:   %{version}
Release:   1%{?dist}
Summary:   Nrgaway's personal mgmt-salt Dom0 configuration
License:   GPL 2.0
URL:	   http://www.qubes-os.org/

Group:     System administration tools
BuildArch: noarch
Requires:  qubes-mgmt-salt
Requires:  qubes-mgmt-salt-dom0
BuildRequires: tree

%define _builddir %(pwd)

%description
Nrgaway's personal mgmt-salt Dom0 configuration

%prep
# we operate on the current directory, so no need to unpack anything
# symlink is to generate useful debuginfo packages
rm -f %{name}-%{version}
ln -sf . %{name}-%{version}
%setup -T -D

%build

%install
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} BINDIR=%{_bindir} SBINDIR=%{_sbindir} SYSCONFDIR=%{_sysconfdir}

%post
# Update Salt Configuration
qubesctl state.sls config -l quiet --out quiet > /dev/null || true
qubesctl saltutil.clear_cache -l quiet --out quiet > /dev/null || true
qubesctl saltutil.sync_all refresh=true -l quiet --out quiet > /dev/null || true

# Enable States
qubesctl top.enable nrgaway saltenv=user -l quiet --out quiet > /dev/null || true

%files
%defattr(-,root,root)
%doc LICENSE README.rst
%attr(750, root, root) %dir /srv/formulas/user/nrgaway-user-formula

/srv/formulas/user/nrgaway-user-formula/LICENSE
/srv/formulas/user/nrgaway-user-formula/README.rst

%changelog
