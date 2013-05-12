function connection_weights = get_connection_weights(z, beta, gamma, use_diagonals)
    connection_weights = zeros((4 + 4 * use_diagonals) * size(z, 1) * size(z, 2), 3); %this is an overestimate
    t = 1;
    tt = 1;
    for i = 1:size(z, 1)
	%i,
        for j = 1:size(z, 2)
            pa = z(i, j, :);
            if j > 1
                pb = z(i, j - 1, :);
                d = norm(pa(:) - pb(:), 2);
                connection_weights(tt, :) = [t, t - 1, exp(-1.0 * beta * d^2)];
		tt = tt + 1;
            end;
            if j < size(z, 2)
                pb = z(i, j + 1, :);
                d = norm(pa(:) - pb(:), 2);
                connection_weights(tt, :) = [t, t + 1, exp(-1.0 * beta * d^2)];
		tt = tt + 1;
            end;
            if i > 1
                pb = z(i - 1, j, :);
                d = norm(pa(:) - pb(:), 2);
                connection_weights(tt, :) = [t, t - size(z, 2), exp(-1.0 * beta * d^2)];
		tt = tt + 1;
                if use_diagonals
                    if j > 1
                        pb = z(i - 1, j - 1, :);
                        d = norm(pa(:) - pb(:), 2);
                        connection_weights(tt, :) = [t, t - size(z, 2) - 1, exp(-1.0 * beta * d^2)];
			tt = tt + 1;
                    end;
                    if j < size(z, 2)
                        pb = z(i - 1, j + 1, :);
                        d = norm(pa(:) - pb(:), 2);
                        connection_weights(tt, :) = [t, t - size(z, 2) + 1, exp(-1.0 * beta * d^2)];
			tt = tt + 1;
                    end;
                end;
            end;
            if i < size(z, 1)
                pb = z(i + 1, j, :);
                d = norm(pa(:) - pb(:), 2);
                connection_weights(tt, :) = [t, t + size(z, 2), exp(-1.0 * beta * d^2)];
		tt = tt + 1;
                if use_diagonals
                   if j > 1
                       pb = z(i + 1, j - 1, :);
                       d = norm(pa(:) - pb(:), 2);
                       connection_weights(tt, :) = [t, t + size(z, 2) - 1, exp(-1.0 * beta * d^2)];
		       tt = tt + 1;
                   end;
                   if j < size(z, 2)
                       pb = z(i + 1, j + 1, :);
                       d = norm(pa(:) - pb(:), 2);
                       connection_weights(tt, :) = [t, t + size(z, 2) + 1, exp(-1.0 * beta * d^2)];
		       tt = tt + 1;
                   end;
                end;
            end;
            t = t + 1;
        end;
    end;
    connection_weights = connection_weights(1:(tt - 1), :);
    connection_weights(:,3) = gamma * connection_weights(:,3);
