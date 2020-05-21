clear
close all
clc

file = uigetfile('*.*')
excel = readcell(file);

question = 'Enter a value for fright';
title = 'Input';
fright = inputdlg(question,title);

mm = {};

actual = excel([6 : end] , :);

j=0;

for i = 1 : max(size(actual))
    if ismissing(actual{i,8}) == 1
        mm{i} = 'not a number';
    else
        j = j+1;
        
        
        mm{i} = 'number';
        itemNum{j} = actual{i,1};
        itemQuanityBox{j} = actual{i,2};
        itemName{j} = actual{i,4};
        UPCCode{j} = actual{i,5};
        itemPrice{j} = actual{i,6};
        Price{j} = (itemPrice{j} + str2num(fright{1}))/(itemQuanityBox{j})/(.7);
        
    end
end

mm = mm';
itemName = itemName';
itemNum = itemNum';
itemQuanityBox = itemQuanityBox';
UPCCode = UPCCode';
itemPrice = itemPrice';
Price = Price';

final  = {itemNum{1:end} ; itemName{1:end} ;  itemQuanityBox{1:end};itemPrice{1:end}; Price{1:end}}';

writecell(final,'mm.txt')

display(final)

% itemNum = actual(:,1);
% itemQuanityBox = actual(:,2);
% itemName = actual(:,4);
% UPCCode = actual(:,5);
% itemPrice = actual(:,6);

