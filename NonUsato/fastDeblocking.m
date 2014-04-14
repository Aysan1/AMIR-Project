function [ X ] = fastDeblocking( Xi, height, width, NB, SX)
%deblocking reshape the denoised signal in order to obtain the matrix of
%the wavelets tranform
%   rows and cols are the rows and coloumn of the original matrix (the
%   wavelts transform)

%all block is written in one cloum
Xi2 = reshape(Xi.',width,NB(1)*NB(2)*height).';

%fix the block entities
B2=mat2cell(Xi2, ones(1,NB(1)*NB(2))*height, ones(1,1)*width);

%split the block in lines and columns
B = reshape(B2.',NB(2),NB(1)).';

%back to matrix
X1=cell2mat(B);

X = X1(1:SX(1),1:SX(2));

end
