{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, jsonrpc-async
, jsonrpc-websocket
}:

buildPythonPackage rec {
  pname = "pykodi";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SDp2S9HeqejRM3cf4x+5RLUQMPhjieQaXoubwf9Q/d4=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-async
    jsonrpc-websocket
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykodi" ];

  meta = with lib; {
    description = "An async python interface for Kodi over JSON-RPC";
    homepage = "https://github.com/OnFreund/PyKodi";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ];
  };
}
