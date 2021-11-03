

[status,msg,msgID] = mkdir('Dataset/64');

snr = -12:2:20;
i_train = 700;
i_test = 300;

total = length(snr)*23;


Xs_train = zeros(total*i_train,64,64,2);
Xw_train = zeros(total*i_train,64,64,1);
Xc_train = zeros(total*i_train,64,64,1);
Y_train = zeros(total*i_train, 23);
lbl_train = zeros(total*i_train, 6);

Xs_test = zeros(total*i_test,64,64,2);
Xw_test = zeros(total*i_test,64,64,1);
Xc_test = zeros(total*i_test,64,64,1);
Y_test = zeros(total*i_test, 23);
lbl_test = zeros(total*i_test, 6);

ii = 1;
for i = 1:5
cAl = 1;
j = 1;
k = 1;
switch i
    case 1
        [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('LFM generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        ii = ii+1;
        fprintf('LFM stored\n');
    case 2
        for j = 1:3
            [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
            [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
            fprintf('FSK generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
            ii = ii+1;
            fprintf('FSK stored\n');
        
        end
        cAl = 0;
        [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('Costas generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        ii = ii+1;
        fprintf('Costas Stored\n');
    case 3
        cAl = 1;
        for j = 1:3
            [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[2,5, 10, 15, 20],j,1,cAl,k,[],[],[]);
            [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[2,5, 10, 15, 20],j,1,cAl,k,[],[],[]);
            fprintf('PSK generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
            ii = ii+1;
            fprintf('PSK stored\n');
        end
        cAl = 0;
        for k = 1:13
            [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[7 10 15 20],j,1,cAl,k,[],[],[]);
            [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[7 10 15 20],j,1,cAl,k,[],[],[]);
            fprintf('Phase modulation generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
            ii = ii+1;
            fprintf('Phase modulation stored\n');
        end
    case 4
        [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],i,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('NM generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        ii = ii+1;
        fprintf('NM stored\n');
    case 5
        [Xs1,Xw1,Xc1,Y1,lbl1] = signal_generator_2d(snr,i_train,[1024, 1024],8,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        [Xs2,Xw2,Xc2,Y2,lbl2] = signal_generator_2d(snr,i_test,[1024, 1024],8,[1/20, 1/4],[],[],[],[1, 2, 5, 10, 15],[1/100, 1/20],j,[20],j,1,cAl,k,[],[],[]);
        fprintf('Noise generated\n');
        Xs_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xs1;
        Xw_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xw1;
        Xc_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:,:,:) = Xc1;
        Y_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = Y1;
        lbl_train(length(snr)*i_train*(ii-1)+1:length(snr)*i_train*(ii),:) = lbl1;
        
        Xs_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xs2;
        Xw_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xw2;
        Xc_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:,:,:) = Xc2;
        Y_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = Y2;
        lbl_test(length(snr)*i_test*(ii-1)+1:length(snr)*i_test*(ii),:) = lbl2;
        fprintf('Noise stored\n');

end
end

fprintf('Beginning to save\n');
save('Dataset/64/Xs_train.mat', 'Xs_train', '-v7.3', '-nocompression')
save('Dataset/64/Xw_train.mat', 'Xw_train', '-v7.3', '-nocompression')
save('Dataset/64/Xc_train.mat', 'Xc_train', '-v7.3', '-nocompression')
fprintf('X train saved\n');
save('Dataset/64/Y_train.mat', 'Y_train')
fprintf('Y train saved\n');
save('Dataset/64/lbl_train.mat', 'lbl_train')
fprintf('lbl train saved\n');
save('Dataset/64/Xs_test.mat', 'Xs_test','-v7.3', '-nocompression')
save('Dataset/64/Xw_test.mat', 'Xw_test','-v7.3', '-nocompression')
save('Dataset/64/Xc_test.mat', 'Xc_test','-v7.3', '-nocompression')
fprintf('X_test saved\n');
save('Dataset/64/Y_test.mat', 'Y_test')
fprintf('Y test saved\n');
save('Dataset/64/lbl_test.mat', 'lbl_test')
fprintf('lbl_test saved\n');


