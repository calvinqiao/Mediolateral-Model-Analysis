function T = frame(n,o,a,p)
    switch nargin
        case 4
            if isrow(n)
                n = n';
            end
            if isrow(o)
                o = o';
            end
            if isrow(a)
                a = a';
            end
            if isrow(p)
                p = p';
            end
            T = [n,o,a,p];
            T = [T;0,0,0,1];
        case 3
            p = a;
            if isrow(n)
                n = n';
            end
            if isrow(o)
                o = o';
            end
            if isrow(p)
                p = p';
            end
            T = [n,o,p];
            T = [T;0,0,1];
    end
end