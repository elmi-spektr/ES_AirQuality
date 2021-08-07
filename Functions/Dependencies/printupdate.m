function printupdate(S,Init)
if nargin<2 Init = 0; end
persistent NWritten
if Init NWritten = 0; end
if ~isempty(NWritten)
  fprintf(repmat('\b',1,NWritten));
end
NWritten = fprintf(S);