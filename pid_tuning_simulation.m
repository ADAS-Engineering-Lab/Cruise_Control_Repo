% 🚀 Manual PID Tuning and Simulation
% Author: ADAS-Engineering-Lab

clc; clear; close all;

% Load the Simulink model
model_name = 'cruise_control_sim';
load_system(model_name);

% Set Simulation Parameters
sim_time = 20;  % Simulation duration (seconds)
set_param(model_name, 'StopTime', num2str(sim_time));

% Initialize PID Gains for Manual Tuning
P = 10;  % Proportional Gain
I = 1; % Integral Gain
D = 0.1; % Derivative Gain

% Apply PID Gains to Simulink Block
pid_controller_path = [model_name, '/PID_Controller'];
set_param(pid_controller_path, 'P', num2str(P), 'I', num2str(I), 'D', num2str(D));

% Simulate the System
disp('✅ Starting simulation...');
simOut = sim(model_name);

% Analyze Performance
logsout = simOut.logsout; % Extract logged signals
speed_signal = logsout.getElement('vehicle_speed');
 % Replace 'Vehicle_Speed' with your signal name
speed_data = speed_signal.Values;

% Plot Speed vs. Time
figure;
plot(speed_data.Time, speed_data.Data, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Speed (m/s)');
title(['Vehicle Speed vs. Time (P=', num2str(P), ', I=', num2str(I), ', D=', num2str(D), ')']);
grid on;

% Define the directory and file name
results_dir = 'results';
file_name = 'speed_vs_time_manual.png';

% Check if the directory exists, create it if not
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

% Save the figure
saveas(gcf, fullfile(results_dir, file_name));
disp(['Plot saved as ', fullfile(results_dir, file_name)]);

