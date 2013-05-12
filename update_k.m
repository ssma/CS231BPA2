function [k, U] = update_k(flat_z, pi, mu, sigma)
%Note: This gives you the k that you would get from ONE of the GMM's for ALL pixels - that's why we don't take alpha as an argument.
    min_component_size = 50;
    num_to_reset = 50;
    num_components = length(pi);
    U = [];
    for c = 1:num_components
        U = [U ; get_U_for_one_component(flat_z, pi{c}, mu{c}, sigma{c})];
    end;
    [U, k] = min(U, [], 1);
%    s = 0;
%    while true
%    	    red_flag = 0;
%	    for c = 1:num_components
%		if length(find(k == c)) < min_component_size
%			red_flag = 1;
%			k(randsample(size(flat_z, 2), num_to_reset)) = c;
%		end;
%	    end;
%	    if ~red_flag,
%		break;
%	    else
%		if mod(s, 10) == 0
%			disp('shit');
%		end;
%	    end;
%	    s = s + 1;
%    end;
