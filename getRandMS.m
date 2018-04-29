function [MS] = getRandMS(M = 10, ITER_COUNT = 1000, Xc = 0, Yc = 0)
    % Input Arguments:
    % M : Number of UEs
    
    Rc = 500;
    R = Rc*cos(pi/6);

    X = Rc*[1, cos(pi/3), -cos(pi/3), -1, -cos(pi/3), cos(pi/3)];
    Y = Rc*[0, sin(pi/3), sin(pi/3), 0, -sin(pi/3), -sin(pi/3)];

    x_temp = -Rc + 2*Rc*rand(1,2.5*M);
    y_temp = -R + 2*R*rand(1,2.5*M);

    flag = inpolygon(x_temp,y_temp,X,Y);
	flag2 = ( sqrt(x_temp.^2 + y_temp.^2) > 1);
  	flag = flag & flag2;

    SS = [-1 1];

	if(sum(flag) >= M)
		x_coordinate = x_temp(flag);
		y_coordinate = y_temp(flag);
		x_coordinate = x_coordinate(1:M);
		y_coordinate = y_coordinate(1:M);

        R_seq = randi(2, M, 512);
        data = randi(2,M,ITER_COUNT);

        for index = 1 : M
            % Positions
            MS(index).x = Xc + x_coordinate(index);
            MS(index).y = Yc + y_coordinate(index);
            MS(index).distance = sqrt( MS(index).x^2 + MS(index).y^2 );

            % Random Sequence of length 512, and
            % Data of length 1000(# of Iternations)
            MS(index).r_seq = SS(R_seq(index, :));
            MS(index).data = SS(data(index, :));
            d = sqrt( MS(index).x^2 + MS(index).y^2 );
            A = sqrt(10^(-60/10 -3)*d^(3.5));
            MS(index).data = A*MS(index).data;
        end
    else
        disp('Recursive call within getRandMS fn');
        MS = getRandMS(M);
    end

end
