function out = loadfrombytestream(filename)
 fid = fopen( filename, 'r' );
 bs = fread( fid, 'uint8=>uint8' );
 fclose(fid);
 out = getArrayFromByteStream(bs);
end
