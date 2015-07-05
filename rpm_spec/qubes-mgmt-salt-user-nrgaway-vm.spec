%{!?version: %define version %(make get-version)}
%{!?rel: %define rel %(make get-release)}
%{!?package_name: %define package_name %(make get-package_name)}
%{!?package_summary: %define package_summary %(make get-summary)}
%{!?package_description: %define package_description %(make get-description)}

%{!?formula_name: %define formula_name %(make get-formula_name)}
%{!?state_name: %define state_name %(make get-state_name)}
%{!?saltenv: %define saltenv %(make get-saltenv)}
%{!?pillar_dir: %define pillar_dir %(make get-pillar_dir)}
%{!?formula_dir: %define formula_dir %(make get-formula_dir)}

Name:      %{package_name}
Version:   %{version}
Release:   %{rel}%{?dist}
Summary:   %{package_summary}
License:   GPL 2.0
URL:	   http://www.qubes-os.org/

Group:     System administration tools
BuildArch: noarch
Requires:  qubes-mgmt-salt
Requires:  qubes-mgmt-salt-vm
BuildRequires: tree

%define _builddir %(pwd)

%description
%{package_description}

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
qubesctl top.enable %{state_name} saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true

# Enable Pillar States
qubesctl top.enable %{state_name} saltenv=%{saltenv} pillar=true -l quiet --out quiet > /dev/null || true

%files
%defattr(-,root,root)
%attr(750, root, root) %dir /srv/formulas/user/nrgaway-user-formula

/srv/formulas/user/nrgaway-user-formula/LICENSE
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.bash_aliases
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.bash_git
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.bash_history
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.bash_logout
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.bash_profile
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.bashrc
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/root/.vimrc
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.bash_aliases
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.bash_git
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.bash_history
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.bash_logout
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.bash_profile
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.bashrc
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vim/autoload
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vim/autoload/pathogen.vim
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vim/bundle
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vim/bundle/vim-sensible
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vim/bundle/vim-surround
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vim/PLUGINS.sh
/srv/formulas/user/nrgaway-user-formula/nrgaway/files/user/.vimrc
/srv/formulas/user/nrgaway-user-formula/nrgaway/init.sls
/srv/formulas/user/nrgaway-user-formula/nrgaway/init.top
/srv/formulas/user/nrgaway-user-formula/README.rst

%changelog
