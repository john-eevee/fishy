function res4k --description "Set resolution to 4k"
  niri msg output "DP-2" mode "3840x2160"
  niri msg output "DP-2" scale "1.5"
end
