# SICK experiments

echo "cd quant; lambda = 0.0003; dim = 50; ed = 200; td = 1; penult = 75; lr = 0.02; dropout = [0.75, 0.9]; rtemult = 0; nlimult = 0; mult = 8; collo = 1; tscale = 1; wscale = 0.01; mbs = 32; dataflag='sick-plus-600k-ea'; name='demo-rntn'; TrainModel('', 1, @Sick, name, dataflag, ed, dim, td, penult, lambda, 1, 0, mbs, lr, dropout(1), dropout(2), mult, rtemult, nlimult, collo, tscale, wscale, 1, 1e-7);"  | /afs/cs/software/bin/matlab_r2012b -nodisplay
echo "cd quant; lambda = 0.0001; dim = 30; ed = 200; td = 1; penult = 75; lr = 0.02; dropout = [0.75, 0.9]; rtemult = 0; nlimult = 0; mult = 8; collo = 1; tscale = 1; wscale = 0.01; mbs = 32; dataflag='sick-plus-600k-ea'; name='demo-rnn'; TrainModel('', 1, @Sick, name, dataflag, ed, dim, td, penult, lambda, 0, 0, mbs, lr, dropout(1), dropout(2), mult, rtemult, nlimult, collo, tscale, wscale, 1, 1e-7);"  | /afs/cs/software/bin/matlab_r2012b -nodisplay
echo "cd quant; lambda = 0.0001; dim = 30; ed = 200; td = 1; penult = 75; lr = 0.02; dropout = [0.75, 0.9]; rtemult = 0; nlimult = 0; mult = 8; collo = 1; tscale = 1; wscale = 0.01; mbs = 32; dataflag='sick-plus-600k-ea'; name='demo-sumnn'; TrainModel('', 1, @Sick, name, dataflag, ed, dim, td, penult, lambda, 0, 1, mbs, lr, dropout(1), dropout(2), mult, rtemult, nlimult, collo, tscale, wscale, 1, 1e-7);"  | /afs/cs/software/bin/matlab_r2012b -nodisplay