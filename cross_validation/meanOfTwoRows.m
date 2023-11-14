function newMatrix = meanOfTwoRows(matrix)
% MEANOFTWOROWS  Takes average of two rows to form a new matrix.
%   NEWMATRIX = MEANOFTWOROWS(MATRIX) takes average of each two rows of MATRIX,
%   like first and second, third and fourth to form a new matrix and output as
%   NEWMATRIX.

    [rows, col] = size(matrix);
    newRows = rows / 2;
    
    newMatrix = zeros(newRows, col);
    
    for i = 1:newRows
        row1 = matrix((2*i)-1, :);
        row2 = matrix(2*i, :);
        
        newRow = (row1 + row2) / 2;
        % newRow = mean(row1, row2, 'omitnan');
        
        newMatrix(i, :) = newRow;
    end
end