function [xValues,yValues]=scatter_points_even(yValues)
%Written by J.M.Stujenske, 2022
%Modified from UniVarScatter
% Copyright (c) 2015, Manuel Lera Ramírez
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution.
% 
% * Neither the name of the {organization} nor the names of its
%   contributors may be used to endorse or promote products derived from
%   this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
xValues=ones(size(yValues));
Width=.4;
Compression=5;
range_val=norminv([0.025 0.975],nanmean(yValues),nanstd(yValues));
    numPoints=sum(~isnan(yValues));
    yValues=yValues(~isnan(yValues));
    xValues=xValues(~isnan(yValues));
    RangeCut=(log(numPoints)/log(150)+3*(numPoints).^(1/3))';
%range_val=quantile(yValues,[0.025 0.975]);
cuts=abs(range_val(1)-range_val(2))/RangeCut;

% In case one of the variables has equal values for all its points, the
% norminv will return a nan, since std(yValues) will be 0, in that case we
% arbitrarily give cuts the value of cuts=mean(yValues)/2, this value does not
% really matter because there will only be one group anyway
if isnan(cuts)
    cuts=mean(yValues)/2;
end
% The "seed" group contains the values which are in the range of the
% mean+-1/2cuts. cutUp is the higher border of the interval. So we
% take this value, and from it we move up and down in this two loops(steps is a variable 
% that allows us to use the same while loop to move in both directions,
% selecting the subset of yValues that are in each group range, and modifying
% their xValues, so that they are spread and do not overlap.

for steps=[-1,1]
    cutUp=mean(yValues)+cuts/2;
    subsetind= yValues<=cutUp & yValues>cutUp-cuts; 
    keep_going=true;
    iter=0;
while keep_going
    iter=iter+1;
    % subsetind is a logical variable that represents how many points are
    % in that group
    if all(sum(subsetind)~=[1 0]) %If there's only one point, we represent it in the middle, and xValues remains equal to i
        
        % distmaker is a variable that is equal to Width when sum(subsetind)=1 , and gets smaller when the number of points
        % gets bigger in a group, exponentially, and it tends to zero in
        % the infinite. I don't have strong arguments for the choice of
        % this particular expression, but for me it works very well, and
        % you can tune with Width and Compression very well the appereance of
        % the plot
        distmaker=Width./(exp((sum(subsetind).^2-1)./(sum(subsetind)*Compression)));

        % xSubset is a column vector with all values equal to i, and as
        % long as the subset of the number of values in yValues that belong
        % to this particular group range
        xSubset=ones(sum(subsetind),1);
        
        %oddie is a variable that indicates whether the number of points in
        %the group is odd or even, it's very important for the indexing
        %afterwards
        oddie=mod(size(xSubset,1),2);
        
        % xb is a symmetrical vector with mean=0, and the values in it have
        % the displacements in x that we want to apply to xValues, but if
        % we just applied it increasingly, the smaller yValue would get the most negative 
        % xValues displacement,etc. and what we would have is a series of lines of points, and
        % in publications, what you usually get is that the points with
        % either the highest or
        % lowest values get the positions that are more outside, and then the lowest or 
        % the highest get the central position. In this function, the lowest values of yValues
        % get the external positions, and the highest values get the central positions, making
        % some sort of eyebrow or sad mouth shape)
        % The range of xb gets bigger as the number of points inside the
        % group increases due to the action of distmaker, which gets
        % smaller as number of points increases.
        xb=linspace(1-Width+distmaker,1+Width-distmaker,size(yValues(subsetind),1))-1;
        
        % Since xb is symmetrical it's easy to add the more extreme values
        % of xb to the xValues with the lower yValues. oddie is needed to
        % index properly depending on wether the number of elements is even
        % or odd. If we sorted the values of xb by their absolute value,
        % their index would be (1,end,2,end-1,3,end-2,etc.) If you think of
        % an example or you debug the function and observe the values of xb
        % it's very easy to understand the indexing done here. Also, it's
        % here where oddie is useful
        
        xSubset(1:2:end-oddie)=xSubset(1:2:end-oddie)+xb(1:round(end/2)-oddie)';
        xSubset(2:2:end)=xSubset(2:2:end)-xb(1:round(end/2)-oddie)';
        xValues(subsetind)= xSubset;    
        
        %This following code line is very useful to see how the groups are made,
        %for watching it, comment the scatter lines in the end, and
        %uncomment this line, however groups with one point won't be shown
        %scatter(xValues(subsetind),yValues(subsetind),PointStyle)
    end
    % advance in the while loop as long as the cutUp value is out of the
    % range of the points
    keep_going=~(cutUp>max(yValues) | cutUp<min(yValues));
    if iter>1000
        keep_going=false;
    end
    cutUp=cutUp+steps*cuts;
    subsetind= yValues<cutUp & yValues>cutUp-cuts;
end
end