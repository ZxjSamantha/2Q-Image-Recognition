function saveasbytestream(filename, var)
 bytestream = getByteStreamFromArray(var);
 fid = fopen( filename, 'w' );
 fwrite( fid, bytestream, 'uint8' );
 fclose(fid);
end
