function [  sys] = constructDiscrete( sys )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

sys_ss=ss(sys.A,sys.B,eye(length(sys.A)),zeros(size(sys.B)));
system_discrete=c2d(sys_ss,sys.dt);

sys.Ad=system_discrete.A;
sys.Bd=system_discrete.B;


end

