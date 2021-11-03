

[status,msg,msgID] = mkdir('Dataset');

snr = -12:2:20;
i_train =  1200;
i_test = 500;

total = length(snr)*12;

X_train = zeros(total*i_train,1024,2);
Y_train = zeros(total*i_train, 12);
lbl_train = zeros(total*i_train, 6);

X_test = zeros(total*i_test,1024,2);
Y_test = zeros(total*i_test, 12);
lbl_test = zeros(total*i_test, 6);

l_s = 1024;

ii = 1;
for i = [1,2,3]
cAl = 1;
j = 1;
k = 1;
switch i
    case 1
        [X1,Y1,lbl1] = signal_generator_wan(snr,i_train,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [X2,Y2,lbl2] = signal_generator_wan(snr,i_test,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('LFM generated\n');
        X_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:) = X1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        X_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:) = X2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        ii = ii+1;
        fprintf('LFM stored\n');
    case 2
        cAl = 0;
        [X1,Y1,lbl1] = signal_generator_wan(snr,i_train,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [X2,Y2,lbl2] = signal_generator_wan(snr,i_test,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('Costas generated\n');
        X_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:) = X1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        X_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:) = X2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        ii = ii+1;
        fprintf('Costas Stored\n');
    case 3
        cAl = 0;
        for k = [1,3,4,5,6,7,10,11,12,13]
            [X1,Y1,lbl1] = signal_generator_wan(snr,i_train,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[7 10 15 20],j,1,cAl,k,[],[],[]);
            [X2,Y2,lbl2] = signal_generator_wan(snr,i_test,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[7 10 15 20],j,1,cAl,k,[],[],[]);
            fprintf('Phase modulation generated\n');
            X_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:) = X1;
            Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
            lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
            
            X_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:) = X2;
            Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
            lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
            ii = ii+1;
            fprintf('Phase modulation stored\n');
        end
    case 4
        [X1,Y1,lbl1] = signal_generator_wan(snr,i_train,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [X2,Y2,lbl2] = signal_generator_wan(snr,i_test,[l_s, l_s],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('NM generated\n');
        X_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:) = X1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        X_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:) = X2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        ii = ii+1;
        fprintf('NM stored\n');
    case 5
        [X1,Y1,lbl1] = signal_generator_wan(snr,i_train,[l_s, l_s],8,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [X2,Y2,lbl2] = signal_generator_wan(snr,i_test,[l_s, l_s],8,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('Noise generated\n');
        X_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:) = X1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        X_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:) = X2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        fprintf('Noise stored\n');

end
end

fprintf('Beginning to save\n');
save('Dataset/X_train.mat', 'X_train', '-v7.3', '-nocompression')
fprintf('X train saved\n');
save('Dataset/Y_train.mat', 'Y_train')
fprintf('Y train saved\n');
save('Dataset/lbl_train.mat', 'lbl_train')
fprintf('lbl train saved\n');
save('Dataset/X_test.mat', 'X_test','-v7.3', '-nocompression')
fprintf('X_test saved\n');
save('Dataset/Y_test.mat', 'Y_test')
fprintf('Y test saved\n');
save('Dataset/lbl_test.mat', 'lbl_test')
fprintf('lbl_test saved\n');

