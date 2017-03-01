classdef accident_ambulance_expectation_test < ee_solns_demos.testers.GenericTester

    properties(SetAccess=private,GetAccess=public)
        d    % distances vector
        d_av % distances averaged
        
        d_av_normalized
        d_av_normalized_exact
    end

    methods(Access=public)
        function obj = accident_ambulance_expectation_test()
            title       = 'Expected Accident-to-Ambulance Distance on a Road of Length L';
            description = ...
                { ...
                'Location of the accident is a uniformly distributed random variable on [0,L].' , ...
                'So is the location of the ambulance at that instant. In this example, we are' , ...
                'computing the expected distance in absolute value between the accident and the' , ...
                'ambulance.' ...
                };
            
        
            flag_in_realquick     = 0;
            flag_expected_to_fail = 0;
            flag_plottable        = 1;
        
            obj@ee_solns_demos.testers.GenericTester ...
                ( ...
                    title , ...
                    description , ...
                    flag_in_realquick , ...
                    flag_expected_to_fail , ...
                    flag_plottable ...
                );
        end
        
        function delete(obj)
        end
    end
    
    methods(Access=private)
    
function core(obj)

rng('shuffle','twister');

L = 100;
N = 1000000;

ii_st = 10000;

d_amb = L * rand(N,1);
d_acc = L * rand(N,1);

obj.d    = abs( d_amb - d_acc );
obj.d_av = cumsum(obj.d) ./ (1:numel(obj.d))';

obj.d_av_normalized       = obj.d_av / L;
obj.d_av_normalized_exact = 1 / 3;

obj.d    = obj.d(ii_st:end);
obj.d_av = obj.d_av(ii_st:end);

obj.d_av_normalized = obj.d_av_normalized(ii_st:end);
end
    
    end
    
    methods(Access=public)
    
function run(obj,varargin)
obj.core()
end

function run_with_plots(obj,varargin)
FontSize = 16;

flag_quality_pub = 0;
if ( nargin >= 2 ) && ( varargin{1} > 0 )
    flag_quality_pub = 1;
end

obj.core()

figure;
stairs( 1:numel(obj.d_av_normalized) , obj.d_av_normalized , 'Color' , 'b' , 'LineWidth' , 4 )
hold off;
hold on;
plot ...
  ( ...
  1:numel(obj.d_av_normalized) , ...
  obj.d_av_normalized_exact * ones( numel(obj.d_av_normalized) , 1 ) , ....
  '--' , 'Color' , 'r' , 'LineWidth' , 4 ...
  )
hold off;

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

grid on;
title('Evolution of Average vs. Iterations')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end
end

    end
end
