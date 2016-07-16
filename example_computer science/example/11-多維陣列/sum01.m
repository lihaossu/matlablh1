A = [1 1 1 1; 2 2 2 2; 3 3 3 3];
B = [0 0 0 0; 1 1 1 1; 1 2 3 4];
Z = cat(3, A, B);	% 將矩陣 A, B 疊成一個三維陣列
S = sum(Z, 1)		% 根據第一維度來對元素進行相加
size(S)