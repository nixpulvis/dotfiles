function _preinstall.package.atom -e preinstall:package:atom
  rm -rf ~/.atom
end

function _postinstall.package.atom -e postinstall:package:atom
  if [ "$SKIP_APM_STARS_INSTALL" != "1" ]
    pip install jupyter
    apm stars --install
  end
end
