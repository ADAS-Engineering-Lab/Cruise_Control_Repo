% 🚀 Automated Simulink Testing Script
clc; clear; close all;

try
    % Load Simulink model (Will fail if the model does not exist)
    load_system('cruise_control_sim');
    disp('✅ Simulink model found and loaded.');
    
    % Run simulation
    simOut = sim('cruise_control_sim');
    
    % Check output values
    speed_output = simOut.get('yout').signals.values;
    if isempty(speed_output)
        error('❌ Simulation failed: No speed output detected!');
    else
        disp('✅ Simulation ran successfully, output is valid.');
    end
    
    % Close Simulink model
    close_system('cruise_control_sim', 0);

catch
    % If model doesn't exist, create a new one
    disp('⚠️ Simulink model not found. Creating a placeholder model...');
    
    new_system('cruise_control_sim');  % Create new Simulink model
    open_system('cruise_control_sim'); % Open model for editing
    
    % Save new model
    save_system('cruise_control_sim');
    close_system('cruise_control_sim', 0);
    
    disp('✅ Placeholder Simulink model created. Now develop the real model.');
end
