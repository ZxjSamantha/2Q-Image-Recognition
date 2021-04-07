function net = getnetfromweb( URL )

 URL = directlink(URL);
 bs = webread(URL);
 net=getArrayFromByteStream(bs);

end


function dst = directlink( src )
 dst = src;

 s=strsplit(src,'/');
 if( strcmpi( s{2}, 'drive.google.com' ) )
  s=strsplit(src,'?');
  dst = ['https://drive.google.com/uc?', s{2} ];

 elseif( strcmpi( s{2}, 'www.mediafire.com' ) )
  code = webread( src );
  m = regexp( code, '"http://download\d*\.mediafire\.com/.+?"', 'match');
  dst = m{1}(2:numel(m{1})-1);
 end
end
