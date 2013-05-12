function grabcut(im_name)

% convert the pixel values to [0,1] for each R G B channel.
im_data = double(imread(im_name)) / 255;
% display the image
imagesc(im_data);

% a bounding box initialization
disp('Draw a bounding box to specify the rough location of the foreground');
set(gca,'Units','pixels');
ginput(1);
p1=get(gca,'CurrentPoint');fr=rbbox;p2=get(gca,'CurrentPoint');
p=round([p1;p2]);
xmin=min(p(:,1));xmax=max(p(:,1));
ymin=min(p(:,2));ymax=max(p(:,2));
[im_height, im_width, channel_num] = size(im_data);
xmin = max(xmin, 1);
xmax = min(im_width, xmax);
ymin = max(ymin, 1);
ymax = min(im_height, ymax);

bbox = [xmin ymin xmax ymax];
line(bbox([1 3 3 1 1]),bbox([2 2 4 4 2]),'Color',[1 0 0],'LineWidth',1);
if channel_num ~= 3
    disp('This image does not have all the RGB channels, you do not need to work on it.');
    return;
end

% for h = 1 : im_height
%     for w = 1 : im_width
%         if (w > xmin) && (w < xmax) && (h > ymin) && (h < ymax)
%             % this pixel belongs to the initial foreground
%         else
%             % this pixel belongs to the initial background
%         end
%     end
% end

% grabcut algorithm
disp('grabcut algorithm');

num_components_fg = 5;
num_components_bg = 5;
pi_fg = {0.2, 0.2, 0.2, 0.2, 0.2};
pi_bg = {0.2, 0.2, 0.2, 0.2, 0.2};
mu_fg = {zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1)};
mu_bg = {zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1)};
sigma_fg = {eye(3), eye(3), eye(3), eye(3), eye(3)};
sigma_bg = {eye(3), eye(3), eye(3), eye(3), eye(3)};
beta = 2.0;
gamma = 1.0;
use_diagonals = 0;
epsilon_U_kmeans = 0.001;
epsilon_U = 0.001;
epsilon_E = 0.001;
z = im_data;
flat_z = flatten_z(z);
connection_weights = get_connection_weights(z, beta, gamma, use_diagonals);
[flat_alpha, U_infinitizer] = init_alpha(z, bbox);

k_fg = random('unid', num_components_fg * ones(1, size(flat_z, 2)));
k_bg = random('unid', num_components_bg * ones(1, size(flat_z, 2)));

last_E = inf;
[pi_fg, mu_fg, sigma_fg, k_fg, pi_bg, mu_bg, sigma_bg, k_bg] = update_GMM(flat_z, flat_alpha, pi_fg, mu_fg, sigma_fg, k_fg, num_components_fg, pi_bg, mu_bg, sigma_bg, k_bg, num_components_bg, epsilon_U_kmeans, 1);
while True,
	[pi_fg, mu_fg, sigma_fg, k_fg, pi_bg, mu_bg, sigma_bg, k_bg] = update_GMM(flat_z, flat_alpha, pi_fg, mu_fg, sigma_fg, k_fg, num_components_fg, pi_bg, mu_bg, sigma_bg, k_bg, num_components_bg, epsilon_U, 0);
	[flat_alpha, E] = update_alpha(pi_fg, mu_fg, sigma_fg, pi_bg, mu_bg, sigma_bg, U_infinitizer, connection_weights);
	if E > last_E - epsilon_E
		break;
	end;
	last_E = E;
end;

alpha = unflatten_alpha(flat_alpha, z);
imagesc(alpha);

% INITIALIZE THE FOREGROUND & BACKGROUND GAUSSIAN MIXTURE MODEL (GMM)
% 
% while CONVERGENCE
%     
%     UPDATE THE GAUSSIAN MIXTURE MODELS
%     
%     MAX-FLOW/MIN-CUT ENERGY MINIMIZATION
%     
%     IF THE ENERGY DOES NOT CONVERGE
%         
%         break;
%     
%     END
% end
