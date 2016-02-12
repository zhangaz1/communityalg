function [S, pars] = asymptotic_surprise(W, ci)
%ASYMPTOTIC_SURPRISE

%ASYMPTOTIC_SURPRISE      Compute surprise of a vertex partition on a binary network.
%
%   If you use this program, please cite:
%   V.A.Traag, R.Aldecoa. 2015. “Detecting Communities Using Asymptotical Surprise.” 
%   http://arxiv.org/abs/1503.0044.
%
%   Inputs      A,  undirected weighted or unweighted network.
%               ci, membership vector
%
%   Outputs:    S,  value of Asymptotic Surprise (natural logs).
%               pars, partition parameters. [intraclusteredges,
%               intracluster_pairs, number of edges, number of pairs]
%
%   Carlo Nicolini, Istituto Italiano di Tecnologia (2015).
%

n = length(W);
m = sum(nonzeros(triu(W)));
p = n*(n-1)/2;
groups = membership2groups(ci); % convert membership vector to groups
ncomms = length(groups); % number of communities
intraedges = 0; % number of intracluster edges
intrapairs = 0; % number of intracluster pairs
for i=1:ncomms
    nodes = groups{i};
    % generate subgraph
    g = W(nodes,nodes);
    wc = sum(nonzeros(triu(g)));
    nc = length(nodes);
    pc = nc*(nc-1)/2;
    %fprintf('%d\t%.2f\t%d\t%d\n',i,wc,nc,pc);
    intraedges = intraedges + wc;
    intrapairs = intrapairs + pc;
end
% Clustering parameters.
pars = [intraedges,intrapairs,m,p];
% Use Kullback Leibler divergence to compute asymptotic surprise
S = m*KL(intraedges/m, intrapairs/p);

function D = KL(q,p)

if (q==p)
    D=0;
    return;
end

D = 0.0;
if (q > 0.0 && p > 0.0)
    D = D + q*log10(q/p);
end

if (q < 1.0 && p < 1.0)
    D = D + (1.0-q)*log10((1.0-q)/(1.0-p));
end
