x = zeros(1,6);		% 變數 x 是一個 1×6 大小的零矩陣  
for i = 1:6
	x(i) = 1/i;
end
disp(x)			% 顯示 x
format rat		% 使用分數形式來顯式數值
disp(x)			% 顯示 分數形式的 x