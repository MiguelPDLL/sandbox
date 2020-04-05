% By I. Aguilar & M. Pacheco
% A fun little file to parse International orders!

close all;
clear;
clc;

fid = fopen('C:\Users\tediz\OneDrive\Documentos\Campos_trial\Second invt 030920.txt');
tline = fgetl(fid);

item_num = cell(1e4, 1);
item_name = cell(1e4, 1);
price_bulk = cell(1e4, 1);
price_more = cell(1e4, 1);
quantity_order = cell(1e4, 1);
temp_line = cell(1e4, 1);
quanity_box = cell(1e4,1);

index = 1;
while (ischar(tline))
    % disp(tline);
    
    str = strsplit(tline, ',');
    
    for ii = 1:numel(str)
        if (isempty(str{ii}))
            str(ii) = [];
        end
    end
    
    if (numel(str) < 7)
        tline = fgetl(fid);
        continue;
    end
    
    item_num{index} = str{2};
    item_name{index} = str{3};
    
    num_found =  false;
    for kk = 1:length(item_name{index})
        if (~isnan(str2double(item_name{index}(kk))) && kk > 5)
            num_found = true;
            break;
        end
    end
    
    if (kk == length(item_name{index}))
        % If this occurs then item name does not contain a number!
        2;
    end
    
    if (num_found)
        temp_line{index} = item_name{index}(kk:end);
        
        x = strsplit(temp_line{index}, '/');
        
        if (numel(x) == 1)
            % do something (e.g. 7lbs, 12 ct)
            %
            indices = false(length(x{1}));
            for mm = 1:length(x{1})
                if (~isnan(str2double(x{1}(mm))))
                    indices(mm) = true;
                end
            end
            
            z = x{1}(indices);
            
            quanity_box{index} = z;
            
        elseif (numel(x) == 2)
            % do something else 6/12oz
            %6 is he quanity per box
            for mm = length(x{1}):-1:1
                if (isnan(str2double(x{1}(mm))))
                    quanity_box{index} = x{1}(mm+1:end);
                    break;
                end
                
            end
            
            if (mm == 1)
                quanity_box{index} = x{1};
            end
            
        else
           % do something (e.g. 5/12/4.2oz)
           quanity_box{index} = num2str(str2double(x{1})*str2double(x{2}));
           
        end
        
    end  
    
    price_bulk{index} = str{4};
    price_more{index} = str{5};
    quantity_order{index} = str{7};
    
    tline = fgetl(fid);
    index = index+1;
end
fclose(fid);

temp_line = temp_line(~cellfun('isempty', temp_line));
item_num = item_num(~cellfun('isempty', item_num));
item_name = item_name(~cellfun('isempty', item_name));
price_bulk = price_bulk(~cellfun('isempty', price_bulk));
price_more = price_more(~cellfun('isempty', price_more));
quantity_order = quantity_order(~cellfun('isempty', quantity_order));
quanity_box = quanity_box(~cellfun('isempty', quanity_box));

quanity_box = str2double(quanity_box);
quantity_order = str2double(quantity_order);

price = zeros(length(quanity_box), 1);


for ii = 1:length(price_more)
    price_more{ii} = price_more{ii}(2:end);
    price_bulk{ii} = price_bulk{ii}(2:end);
end
price_more = str2double(price_more);
price_bulk = str2double(price_bulk);


flete = 4;
profit = .7;
for i = 1:length(quanity_box)
    if quantity_order(i) < 9
        price(i) = ((price_more(i) + flete)/quanity_box(i))/profit;
        
    else
        price(i) = (price_bulk(i) + flete)/quanity_box(i)/profit;
    end
end

final = containers.Map;
final2 = cell(length(price), 3);

for ii = 1:length(price)
    final(item_name{ii}) = price(ii);
    final2{ii, 1} = item_name{ii};
    final2{ii, 2} = price(ii);
    
   
    d = 100*rem(price(ii), 1);
    d1 = (round(d/10)*10-1)/100;
    y = floor(price(ii)) + d1;
    final2{ii, 3} = y;
    
end

%if p = 2.64    #.#4 < 5

%#.6# -.1 #.5#




%5.64 -> 5.69 or 5.59


