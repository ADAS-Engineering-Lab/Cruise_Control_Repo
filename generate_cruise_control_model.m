% 🚀 Automated Cruise Control Simulink Model Generation
% Author: ADAS-Engineering-Lab

clc; clear; close all;

% ✅ Create a new Simulink model
model_name = 'cruise_control_sim';
new_system(model_name);
open_system(model_name);

% 🔹 Define block positions for readability
x = 30; y = 30;
dx = 150; dy = 100;

% ✅ Add Vehicle Dynamics Subsystem
vehicle_dynamics = [model_name, '/Vehicle_Dynamics'];
add_block('built-in/SubSystem', vehicle_dynamics, 'Position', [x, y, x+dx, y+dy]);

% Add input and output ports to Vehicle_Dynamics subsystem
inport_vd = [vehicle_dynamics, '/In1'];
outport_vd = [vehicle_dynamics, '/Out1'];
add_block('simulink/Sources/In1', inport_vd, 'Position', [20, 50, 50, 70]);
add_block('simulink/Sinks/Out1', outport_vd, 'Position', [120, 50, 150, 70]);
add_line(vehicle_dynamics, 'In1/1', 'Out1/1'); % Connect input to output in Vehicle_Dynamics

% ✅ Add PID Controller
pid_controller = [model_name, '/PID_Controller'];
add_block('simulink/Continuous/PID Controller', pid_controller, ...
    'Position', [x+dx+100, y, x+dx+200, y+dy], ...
    'P', '1', 'I', '0.5', 'D', '0');

% ✅ Add Desired Speed Input (Setpoint)
desired_speed = [model_name, '/Desired Speed'];
add_block('simulink/Sources/Constant', desired_speed, ...
    'Position', [x, y+200, x+50, y+230], 'Value', '25');  % Target speed = 25 m/s

% ✅ Add Road Disturbance Source
road_disturbance = [model_name, '/Disturbance Force'];
add_block('simulink/Sources/Step', road_disturbance, ...
    'Position', [x, y+300, x+50, y+330], 'Time', '5', 'After', '200'); % Introduce a disturbance at 5s

% ✅ Add Vehicle Speed Sensor
vehicle_speed = [model_name, '/Speed Sensor'];
add_block('simulink/Sinks/Out1', vehicle_speed, 'Position', [x+dx+250, y, x+dx+280, y+30]);

% ✅ Add Sum Block for Combining Signals
sum_block = [model_name, '/Sum'];
add_block('simulink/Math Operations/Sum', sum_block, ...
    'Position', [x+dx+50, y+100, x+dx+100, y+140], ...
    'Inputs', '|+-'); % One positive (PID output), one negative (disturbance)

% ✅ Connect Blocks
add_line(model_name, 'Desired Speed/1', 'PID_Controller/1'); % Desired Speed → PID Input
add_line(model_name, 'PID_Controller/1', 'Sum/1'); % PID Output → Sum Input 1
add_line(model_name, 'Disturbance Force/1', 'Sum/2'); % Disturbance → Sum Input 2
add_line(model_name, 'Sum/1', 'Vehicle_Dynamics/In1'); % Sum Output → Vehicle Dynamics Input
add_line(model_name, 'Vehicle_Dynamics/Out1', 'Speed Sensor/1'); % Vehicle Dynamics Output → Speed Sensor

% ✅ Save & Close System
save_system(model_name);
close_system(model_name);

disp('✅ Simulink Model Created Successfully!');
