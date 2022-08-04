function out=conv2_symmetric(X,Y,padding)
%same functionality as conv2, except will return matrix with same
%dimensions using a symmetric padding
%third argument is 'same','start',or 'end' for padding
if nargin<3
    padding='same';
end
[m1,n1]=size(X);
[m2,n2]=size(Y);
if m1<m2 && n1<n2
    temp=X;
    X=Y;
    Y=temp;
    disp('Smaller matrix should be second; reversing order.')
    tempm=m1;    tempn=n1;    m1=m2;    n1=n2;    m2=tempm;    n2=tempn;
end
switch padding
    case 'same'
        if m2>1
    X=[X(floor(m2/2)+1:-1:2,:);X;X(end-1:-1:end-floor(m2/2),:)];
end
if n2>1
    
    X=[X(:,floor(n2/2)+1:-1:2) X X(:,end-1:-1:end-floor(n2/2))];
    if m2>1
        X([1:floor(m2/2) end-floor(m2/2)+1:end],[1:floor(n2/2) end-floor(n2/2)+1:end])=0;
    end
end
    case 'start'
        if m2>1
    X=[X(m2+1:-1:2,:);X];
end
if n2>1
    X=[X(:,n2+1:-1:2) X];
    if m2>1
        X(1:m2,1:n2)=0;
    end
end
    case 'end'
                if m2>1
    X=[X;X(end-1:-1:end-m2,:)];
end
if n2>1
    X=[X X(:,end-1:-1:end-n2)];
    if m2>1
        X(m2+1:end,end-n2+1:end)=0;
    end
end
end

out=conv2(X,Y,'valid');
%correct for even filter lengths
[m3,n3]=size(out);
if ~(m3==m1 && n3==n1)
if m3~=m1
    switch padding
        case 'finish'
            x_range=1:m3-1;
        otherwise 
    x_range=2:m3;
    end
else
    x_range=1:m3;
end
if n3~=n1
    switch padding
        case 'finish'
            y_range=1:n3-1;
        otherwise 
    y_range=2:n3;
    end
else
    y_range=1:n3;
end
out=out(x_range,y_range);
end