function PRO=ell2tm(ELL,sys,L0,UND,FileOut)

% ELL2TM performs transformation from ellipsoidal coordinates to a transverse mercator mapping projection
%
% PRO=ell2tm(ELL,sys,L0,UND,FileOut)
%
% Also necessary:   Projections.mat   Ellipsoids.mat   (see beneath)
%
% Inputs:  ELL  coordinates on ellipsoid as nx2-matrix (longitude, latitude) [degree]
%               2xn-matrices are allowed. Be careful with 2x2-matrices!
%               If for (some) points ellipsoidic height is available, ELL may be a nx3-matrix also.
%               Southern hemisphere is signalled by negative latitude.
%               ELL may also be a file name with ASCII data to be processed. No point IDs, only
%               coordinates as if it was a matrix.
%
%          sys  is the projection system type as string in lower case letters
%               Default if omitted or set to [] is 'gk' (German GK projection)
%               Information about the projection systems is stored in the mat-File "Projections.mat"
%               which has cell-array members named by the projection type, e.g. 'gk' for
%               Gauss-Kruger projection.
%               Feel free to add individual tm projections.
%               See Projections.m for details.
%               
%           L0  central meridian longitude (scalar or length ELL) [degree]
%               If left out or empty, L0 is detected automatically due to projection type settings
%
%          UND  undulation values from geoid model to calculate projected height from ellipsoidal height.
%               If omitted or set to [], no correction is done on the height in PRO.
%               Ellipsoidal height = Projected height + Undulation value
%                   
%      FileOut  File to write the output to. If omitted, no output file is generated.
%
% Outputs: PRO nx2- resp. nx3- matrix with abscissa, ordinate (and height) in the projection system
%
% ell2gk is meant as last step for geodetic transformations, when global coordinates or other
% projections have to be transformed to gk projection coordinates.
%
% Note: Naturally, in most cases ell2utm() and ell2tm('utm') give identical results when the same 
%       ellipsoids are used. However, ell2utm() uses standard output formats (which contain at least one 
%       letter showing the vertical band) and can handle polar regions with UPS mapping and special zone
%       width variations which ell2tm can't.
%       ell2tm instead is just doing a tm mapping with utm parameters and ignoring false northing on
%       southern hemisphere for unambiguousness while having no vertical zone identifier.
%       While for a point on southern hemisphere ell2utm shows e.g. 33H459741.966 6151265.479,
%       ell2tm will produce [33459741.9661022 -3848734.5208106]. This might be favourable for further 
%       calculation steps (with the mentioned limitations).

% Author:
% Peter Wasmeier, Technical University of Munich
% p.wasmeier@bv.tum.de
% Aug 25, 2011

%% Do some input checking

% Load input file if specified
if ischar(ELL)
    ELL=load(ELL);
end

% Check input size and defaults
if ~any(ismember(size(ELL),[2 3]))
    error('Coordinate list ELL must be a nx2- or nx3-matrix!')
elseif (ismember(size(ELL,1),[2 3]))&&(~ismember(size(ELL,2),[2 3]))
    ELL=ELL';
end
n=size(ELL,1);  % Number of coordinates to transform
if nargin<5
    FileOut=[];
end
if nargin<4 || isempty(UND)
    UND=zeros(n,1);
elseif (numel(UND)~=n)||(~isvector(UND))
    error('Parameter ''UND'' must be a vector with the length of ELL!')
else
    UND=UND(:)';
end
if nargin<3
    L0=[];
end
if nargin<2 || isempty(sys)
    sys='gk';
end
if (~isscalar(L0))&&(length(L0)~=n)&&~isempty(L0) 
    error('Parameter ''L0'' must be a scalar expression or length of ELL or empty [].')
end
L0=L0(:);

%% Load projection types
load Projections;
% Search for right projection type
if ~exist(sys,'var')
    error(['Projection type ''',sys,''' is not defined in Projections.mat - check your definitions!'])
end
eval(['TYPE=',sys,'.type;']);
if ~strcmp(TYPE,'tm')
    error(['Projection type ''',sys,''' is not a TM projection!']);
end
eval(['m0=',sys,'.m0;']);
eval(['ellips=',sys,'.ellips;']);
eval(['rule_L0=',sys,'.rule_L0;']);
eval(['rule_easting=',sys,'.rule_easting;']);
eval(['rule_northing=',sys,'.rule_northing;']);
eval(['ID_ell=',sys,'.ID_ell;']);
eval(['ID_pro=',sys,'.ID_pro;']);
eval(['standard_L0=',sys,'.standard_L0;']);

%% Load ellipsoids
load Ellipsoids;
if ~exist(ellips,'var')
    error(['Ellipsoid ',ellips,' is not defined in Ellipsoids.mat - check your definitions!.'])
end
eval(['ell=',ellips,';']);

%% Do calculations
PRO=zeros(size(ELL));
rho=180/pi;
if isempty(L0)
    L=ELL(:,1);
    eval(['L0=',standard_L0,';'])
end
eval(['ID=',ID_ell,';'])
B=ELL(:,2)/rho;
L=(ELL(:,1)-L0)/rho;

% 2. eccentricity
es2=(ell.a^2-ell.b^2)/ell.b^2;

V=sqrt(1+es2*cos(B).^2);
eta=sqrt(es2*cos(B).^2);

Bf=atan(tan(B)./cos(V.*L).*(1+eta.^2/6.*(1-3*sin(B).^2).*L.^4));
Vf=sqrt(1+es2*cos(Bf).^2);
etaf=sqrt(es2*cos(Bf).^2);
n=(ell.a-ell.b)/(ell.a+ell.b);

% numerical series for ordinate:
r1=(1+n^2/4+n^4/64)*Bf;
r2=3/2*n*(1-n^2/8)*sin(2*Bf);
r3=15/16*n^2*(1-n^2/4)*sin(4*Bf);
r4=35/48*n^3*sin(6*Bf);
r5=315/512*n^4*sin(8*Bf);

PRO(:,2)=ell.a/(1+n)*(r1-r2+r3-r4+r5)*m0;
eval(['PRO(:,2)=PRO(:,2)',rule_northing,';'])

% abscissa :
ys=asinh(tan(L).*cos(Bf)./Vf.*(1+etaf.^2.*L.^2.*cos(Bf).^2.*(etaf.^2/6+L.^2/10)));
y=m0*ell.a^2/ell.b*ys;
eval(['PRO(:,1)=y',rule_easting,';'])
% Height:
if (size(ELL,2)==3),
    PRO(:,3)=ELL(:,3)-UND(:);
end

%% Write output to file if specified

if ~isempty(FileOut)
    fid=fopen(FileOut,'w+');
    if (size(ELL,2)==3)
        fprintf(fid,'%12.6f  %12.6f  %12.6f\n',PRO');
    else
        fprintf(fid,'%12.6f  %12.6f\n',PRO');
    end
    fclose(fid);
end


% example:
% P5 = [47.66748333	-122.1070833   0]
% P6=ell2tm(P5,'gk',[], 0)
