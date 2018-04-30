function [MS] = getRandMS(M = 10, Xc = 0, Yc = 0, Rc = 500)
    % Input Arguments:
    % M : Number of UEs (defaults tlo 10)
    % Rc: Cell Radius in meters (defaults to 500m)

    % Output Arguments:
    % MS : It is an array of Objects, with parameters:
        % uid       : Index Number
        % x         : x co-ordinate (unit is meters)
        % y         : y co-ordinate (unit is meters)
        % d_refcell : Distance from eNB of Referece Cell (unit is meters)
        % distance  : Array of Distances from BS(eNB)s travelled in Anti-Clock wise sense in 1st Tier.
        % Other Parameters---------------------------------
        % SINR      : Single value (ratio) - WideBand SINR
        % SINRk     : Array (ratio) - for all RBs
        % drate_wb  : Wide-Band Expected Data-Rate for ith user at time t => di(t)
        % drate_rb_array : Expected Data-Rate for ith user at time t on "k-th" Resource Block(RB)

    R = Rc*cos(pi/6);

    X = Rc*[1, cos(pi/3), -cos(pi/3), -1, -cos(pi/3), cos(pi/3)];
    Y = Rc*[0, sin(pi/3), sin(pi/3), 0, -sin(pi/3), -sin(pi/3)];

    BSx = 2*R*cos( (0:5)*pi/3 );
    BSy = 2*R*sin( (0:5)*pi/3 );

    x_temp = -Rc + 2*Rc*rand(1,2.5*M);
    y_temp = -R + 2*R*rand(1,2.5*M);

    flag = inpolygon(x_temp,y_temp,X,Y);
	flag2 = ( sqrt(x_temp.^2 + y_temp.^2) > 1);
  	flag = flag & flag2;

	if(sum(flag) >= M)
		x_coordinate = x_temp(flag);
		y_coordinate = y_temp(flag);
		x_coordinate = x_coordinate(1:M);
		y_coordinate = y_coordinate(1:M);

        for index = 1 : M
            % Positions
            MS(index).uid = index;
            MS(index).x = Xc + x_coordinate(index);
            MS(index).y = Yc + y_coordinate(index);
            MS(index).d_refcell = sqrt( MS(index).x^2 + MS(index).y^2 );
            for bs_index = 1:6
                MS(index).distance = sqrt( (BSx - MS(index).x ).^2 + (BSy - MS(index).y ).^2 );
            end
        end
    else
        disp('Recursive call within getRandMS fn');
        MS = getRandMS(M);
    end

end
