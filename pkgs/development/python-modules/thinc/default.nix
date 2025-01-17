{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, blis
, catalogue
, cymem
, cython
, darwin
, hypothesis
, mock
, murmurhash
, numpy
, pathlib
, plac
, preshed
, pydantic
, srsly
, tqdm
, wasabi
}:

buildPythonPackage rec {
  pname = "thinc";
  version = "8.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w3CnpG0BtYjY1fmdjV42s8usRRJjg1b6Qw9/Urs6iJc=";
  };

  buildInputs = [ cython ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate
    CoreFoundation
    CoreGraphics
    CoreVideo
  ]);

  propagatedBuildInputs = [
    blis
    catalogue
    cymem
    murmurhash
    numpy
    plac
    preshed
    srsly
    tqdm
    pydantic
    wasabi
  ] ++ lib.optional (pythonOlder "3.4") pathlib;


  checkInputs = [
    hypothesis
    mock
    pytest
  ];

  # Cannot find cython modules.
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "blis>=0.4.0,<0.8.0" "blis>=0.4.0,<1.0" \
      --replace "pydantic>=1.7.1,<1.8.0" "pydantic~=1.7"
  '';

  checkPhase = ''
    pytest thinc/tests
  '';

  pythonImportsCheck = [ "thinc" ];

  meta = with lib; {
    description = "Practical Machine Learning for NLP in Python";
    homepage = "https://github.com/explosion/thinc";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
