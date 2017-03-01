classdef accident_ambulance_pdf_test < ee_solns_demos.testers.GenericTester

    properties(SetAccess=private,GetAccess=public)
        L
        noPartitions
        
        d         % distances vector
        groups
        
        freqCount
    end

    methods(Access=public)
        function obj = accident_ambulance_pdf_test()
            title       = 'PDF of the Accident-to-Ambulance Distance on a Road of Length L';
            description = ...
                { ...
                'Location of the accident is a uniformly distributed random variable on [0,L].' , ...
                'So is the location of the ambulance at that instant. In this example, we are' , ...
                'computing the pdf of the absolute value between the accident and the' , ...
                'ambulance. We are plotting the approximation to the pdf through a bar plot.' , ...
                'CDF plots have now also been incorporated.' ...
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

L = 150;
N = 1000000;

noPartitions = 30;

obj.L = L;
obj.noPartitions = noPartitions;

d_amb = L * rand(N,1);
d_acc = L * rand(N,1);

obj.d      = abs( d_amb - d_acc );
obj.groups = floor( obj.d / L * noPartitions );

obj.freqCount = zeros(noPartitions,1);
for kk = 1:length(obj.freqCount)
    obj.freqCount(kk) = length( find( obj.groups == kk-1 ) );
end
obj.freqCount(end) = obj.freqCount(end) + length( find( obj.groups == length(obj.freqCount) ) );

obj.freqCount = obj.freqCount / N * noPartitions / L;
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

pRange = ( (0:obj.noPartitions-1) + 0.5 ) / obj.noPartitions * obj.L;

figure;
plot( pRange , cumsum(obj.freqCount) / obj.noPartitions * obj.L , 'Color' , 'b' , 'LineWidth' , 4 )
hold off;
hold on;
plot ...
    ( ...
    pRange , cumsum(obj.freqCount) / obj.noPartitions * obj.L , ...
    'o' , 'LineWidth' , 2 , 'MarkerSize' , 12 , 'MarkerEdgeColor' , 'k' , ...
    'MarkerFaceColor' , 'r' ...
    )
hold off;

axis([0 obj.L 0 1]);

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

grid on;
title('CDF vs Support Range')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

figure;
bar( pRange , cumsum(obj.freqCount) / obj.noPartitions * obj.L )
colormap(cool)

axis([0 obj.L 0 1]);

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

title('CDF vs Support Range')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

figure;
plot( pRange , obj.freqCount , 'Color' , 'b' , 'LineWidth' , 4 )
hold off;
hold on;
plot ...
    ( ...
    pRange , obj.freqCount , ...
    'o' , 'LineWidth' , 2 , 'MarkerSize' , 12 , 'MarkerEdgeColor' , 'k' , ...
    'MarkerFaceColor' , 'r' ...
    )
hold off;

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

grid on;
title('PDF vs Support Range')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

figure;
bar( pRange , obj.freqCount )
colormap(cool)

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

title('PDF vs Support Range')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

end

    end
end
