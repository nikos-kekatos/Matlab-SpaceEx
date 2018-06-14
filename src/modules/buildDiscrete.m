function [  sys_dis] = buildDiscrete( sys )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

sys_ss=ss(sys.A,sys.B,eye(length(sys.A)),zeros(size(sys.B)));
system_discrete=c2d(sys_ss,sys.dt);

sys_dis.Ad=system_discrete.A;
sys_dis.Bd=system_discrete.B;

sys_dis.n=sys.n;
sys_dis.k=sys.k;
sys_dis.inputs=sys.inputs;
sys_dis.states=sys.states;
sys_dis.T=sys.T;
sys_dis.output=sys.output;
sys_dis.states=sys.states;
sys_dis.dt=sys.dt;
sys_dis.IC=sys.IC;

end

