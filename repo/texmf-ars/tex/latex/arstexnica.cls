%%% Razionale per la classe.
%
% 1. L'autore compila con l'opzione 'paper' (default). Le testatine riportano indicazioni fittizie, 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{arstexnica}[2014/10/02 v1.0.0-alpha Document class for Ars TeXnica]
\RequirePackage{guit}
\RequirePackage{currfile}
\RequirePackage{etoolbox}
%%% Mi servirà per gestire file di configurazione con chiave=valore
\RequirePackage{pgfkeys}
%%% Qui a seguire dovranno andare le definizioni delle chiavi
\pgfkeys{
  /AT/.cd,
  year/.code={\def\AT@year{#1}},
  year/.default={},
  month/.code={\def\AT@month{#1}},
  month/.default={},
  number/.code={\def\AT@number{#1}},
  number/.default={},
  mode/.is choice,
  mode/print/.code={\def\AT@mode{print}},
  mode/online/.code={\def\AT@mode{online}},
  mode/.default=online,
  year,month,number,mode,
}
\newcommand\ATsetup[1]{%
  \pgfkeys{/AT/.cd,#1}
}
%
\def\AT@cfgfound{\ClassInfo{arstexnica}{Info loaded from \jobname.cfg.}}
\def\AT@cfgnotfound{\ClassWarning{arstexnica}{Config file not found.}}
%%%
\newif\if@fvrbex
\newif\if@hyperref
\newif\ifAT@paper
\newif\ifAT@journal
\newif\ifAT@injournal
\newif\ifAT@prima
\newif\ifAT@seconda
\newif\ifAT@terza
\newif\ifAT@quarta
\DeclareOption{draft}{%
  \PassOptionsToClass{\CurrentOption}{article}
}
\DeclareOption{final}{%
  \PassOptionsToClass{\CurrentOption}{article}
}
\DeclareOption{paper}{%
  \AT@papertrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{journal}{%
  \AT@journaltrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{injournal}{%
  \AT@injournaltrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{prima}{%
  \AT@primatrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{seconda}{%
  \AT@secondatrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{terza}{%
  \AT@terzatrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{quarta}{%
  \AT@quartatrue
  \typeout{option: \MakeUppercase{\CurrentOption}}
}
\DeclareOption{online}{%
  \def\AT@mode{online}
}
\DeclareOption{print}{%
  \def\AT@mode{print}
}
%%% Codice comune a tutte le modalità
\ExecuteOptions{draft,paper,online}
\ProcessOptions
\LoadClass[a4paper,twocolumn,twoside,10pt]{article}
\RequirePackage{dblfloatfix}%% oppure fixltx2e?
\RequirePackage{balance}
\RequirePackage{textcomp}
%%% Geometria della pagina
\RequirePackage{geometry}
\geometry{%
   hmargin=2.65cm,
   vmargin={2cm,2.5cm},
%   bindingoffset=3mm,
   columnsep=15pt
}
\frenchspacing
%
%%% Registri per file da aprire in scrittura
%
\newwrite\AT@lst % Per i titoli degli articoli nei sommari
%
%%% Autore, titolo, indirizzo
%
\renewcommand{\title}[2][\@empty]{%
  \gdef\@title{#2}%
  \begingroup
  \renewcommand{\thanks}[1]{}
  \renewcommand{\thanksmark}[1]{}
  \renewcommand{\thanksgap}[1]{}
  \ifx#1\@empty%
    \protected@xdef\thetitle{#2}%
  \else
    \protected@xdef\thetitle{#1}%
  \fi
  \endgroup
}
\newcounter{author}
\setcounter{author}{0}
%%% La versione paper e journal non ha bisogno di alcun codice
%%% relativo alla scrittura della voce bibliografica, che compete solo
%%% a injournal.
\def\addto@theauthorlist#1{
  \begingroup
  \renewcommand{\thanks}[1]{}
  \renewcommand{\thanksmark}[1]{}
  \renewcommand{\thanksgap}[1]{}
  \protected@xdef\theauthorlist{%
    \theauthorlist\ifnum\c@author=\@ne\else,\ \fi#1}
  \endgroup
}
\renewcommand{\author}[1]{%
  \stepcounter{author}
  \expandafter\gdef\csname author@\romannumeral\c@author\endcsname{#1}
  \addto@theauthorlist{#1}
  \AT@authors@hook{#1}
}
\def\AT@authors@hook{}
\def\@authorlist{%
  \@tempcntb\@ne
  \@whilenum\c@author>\@tempcntb\do{%
    {\@nameuse{author@\romannumeral\@tempcntb}, }%
    \advance\@tempcntb\@ne
  }%
  \@nameuse{author@\romannumeral\@tempcntb}
}
\edef\theauthorlist{}

\newcommand{\address}[1]{%
  \expandafter\gdef\csname address@\romannumeral\c@author\endcsname{#1}
}
\newcommand{\netaddress}[1]{%
  \expandafter\gdef\csname netaddress@\romannumeral\c@author\endcsname{#1}
}
\newcounter{title}
\setcounter{title}{0}
\newcommand{\theHtitle}{\arabic{title}}
\def\title@toc@entry#1{%
  \if@hyperref
  \xdef\@currentHref{title.\theHtitle}%
  \Hy@raisedlink{\hyper@anchorstart{\@currentHref}\hyper@anchorend}%
  \else\fi
  \csname toc@entry@#1\endcsname}
%
% \maketitle Tutta questa parte è più o meno ripresa di peso da
% 'titling'. Vale la pena?
%
\newcommand{\pretitle}[1]{\def\@atpretitle{#1}}
\newcommand{\posttitle}[1]{\def\@atposttitle{#1}}
\newcommand{\preauthor}[1]{\def\@atpreauthor{#1}}
\newcommand{\postauthor}[1]{\def\@atpostauthor{#1}}
\newcommand{\predate}[1]{\def\@atpredate{#1}}
\newcommand{\postdate}[1]{\def\@atpostdate{#1}}

\pretitle{%
  \begin{center}\LARGE\bfseries
}
\posttitle{%
  \par\end{center}%
  \vskip 0.5em
}
\preauthor{\begin{center}
  \large\itshape \lineskip .5em%
  \begin{tabular}[t]{c}}
\postauthor{\end{tabular}\par\end{center}}
\predate{\begin{center}\large}
\postdate{\par\end{center}}

\newcommand{\maketitlehooka}{}
\newcommand{\maketitlehookb}{}
\newcommand{\maketitlehookc}{}
\newcommand{\maketitlehookd}{}

\newcommand{\thanksmarkseries}[1]{%
  \def\@atmarkseries{\renewcommand{\thefootnote}{\@nameuse{#1}{footnote}}}}
\newcommand{\symbolthanksmark}{\thanksmarkseries{fnsymbol}}
\newcommand{\@atcontmark}{\setcounter{footnote}{0}}
\newcommand{\continuousmarks}{\def\@atcontmark{}}
\newcommand{\thanksheadextra}[2]{%
  \def\@atthanksheadpre{#1}%
  \def\@atthanksheadpost{#2}}
\newcommand{\thanksfootextra}[2]{%
  \def\thanksfootpre{#1}%
  \def\thanksfootpost{#2}}

\DeclareRobustCommand{\thanksmark}[1]{\footnotemark[#1]}
\newcommand{\thanksgap}[1]{\hspace{#1}}
\newcommand{\tamark}{\@thefnmark}

\newlength{\thanksmarkwidth}
\newlength{\thanksmargin}
\newcommand{\thanksscript}[1]{\textsuperscript{#1}}
\newcommand{\makethanksmarkhook}{}

\newcommand{\thanksfootmark}{%
  \hb@xt@\thanksmarkwidth{\hfil\normalfont\thanksscript{%
    \thanksfootpre \tamark \thanksfootpost}}}

\newcommand{\makethanksmark}{%
  \leavevmode%
  \makethanksmarkhook\relax
  \parindent 1em\noindent
  \leftskip\thanksmargin\relax
  \advance\leftskip \thanksmarkwidth \null\nobreak\hskip -\leftskip
  \thanksfootmark
}

\newcommand{\usethanksrule}{\let\footnoterule\thanksrule}
\newcommand{\cancelthanksrule}{\let\footnoterule\@atfootnoterule}

\symbolthanksmark

\thanksheadextra{}{}
\thanksfootextra{}{}
\setlength{\thanksmarkwidth}{1.8em}
\setlength{\thanksmargin}{-\thanksmarkwidth}

\let\thanksrule\footnoterule

\renewcommand{\maketitle}{\par
  \begingroup
    \@atmarkseries
    \def\@makefnmark{\rlap{\@textsuperscript{%
       \normalfont\@atthanksheadpre \tamark \@atthanksheadpost}}}%
    \long\def\@makefntext##1{\makethanksmark ##1}
        \twocolumn[\@maketitle]%
    \thispagestyle{plain}\@thanks
  \endgroup
  \@atcontmark  %  \setcounter{footnote}{0}%
}

\def\@atdate#1{\csname date@#1\endcsname}

\newlength\@articlesep
\setlength\@articlesep\z@
\def\@maketitle{%
  \stepcounter{title}
  \title@toc@entry{\@pjp}
  \vspace{\@articlesep}
  \maketitlehooka
  {\@atpretitle \@title \@atposttitle}
  \maketitlehookb
  {\@atpreauthor \@authorlist \@atpostauthor}
  \maketitlehookc
  {\@atdate{\@pjp}}
  \maketitlehookd
  \par
  \vskip 1.5em
}
%
%%% Firma finale
%
\newcommand*\SigSymbol{\ensuremath{\triangleright}}
\newlength\DropSig
\setlength\DropSig{2\baselineskip}
\newlength\sigindent
\setlength\sigindent{.25\columnwidth}
\def\@usenempty#1{%
  \csname #1\endcsname
  \global\expandafter\let\csname #1\endcsname\@empty
}
\def\@makesig{%
  \if@fvrbex\long\def\@gobble##1{}\else\fi
  \renewcommand{\thanks}[1]{}
  \renewcommand{\thanksmark}[1]{}
  \renewcommand{\thanksgap}[1]{}
  \vspace{\DropSig}
  \list{}{\topsep\z@ \parsep\z@ \leftmargin=\sigindent \partopsep\z@}
  \@tempcntb\z@
  \@whilenum\c@author>\@tempcntb\do{%
    \advance\@tempcntb\@ne
    \item[\SigSymbol]
    \@usenempty{author@\romannumeral\@tempcntb}\par\nobreak
    \@usenempty{address@\romannumeral\@tempcntb}\par\nobreak
    \texttt{\@usenempty{netaddress@\romannumeral\@tempcntb}}
    }
  \endlist
  \gdef\@thanks{}
  \if@fvrbex\def\@gobble##1{}\else\fi
}
%
%%% Ambiente articolo
%
\def\openarticlehook{}
\newcounter{article}
\newenvironment{article}{%
  \@openarticle}{\@closearticle\clearpage}
\newcommand{\theHarticle}{\arabic{article}}
%
%%% Titoli di sezione
%
\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
  \refstepcounter{part}%
  \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
  \else
  \addcontentsline{toc}{part}{#1}%
  \fi
  {\parindent \z@ \raggedright
    \interlinepenalty \@M
    \normalfont
    \ifnum \c@secnumdepth >\m@ne
    \Large\bfseries \partname\nobreakspace\thepart:
    \par\nobreak
    \fi
    % \huge \bfseries #2%
    #2%
    \markboth{}{}\par}%
  \nobreak
  \vskip 3ex
  \@afterheading}

\def\@spart#1{%
  {\parindent \z@ \raggedright
    \interlinepenalty \@M
    \normalfont
    % \huge \bfseries #1\par}%
    \Large \bfseries #1\par}%
  \nobreak
  \vskip 3ex
  \@afterheading}

\renewcommand{\section}{\@startsection{section}{1}{\z@}%
  {-1\baselineskip \@plus -.2ex \@minus -.1ex}{.5\baselineskip \@plus .2ex}{\raggedright\normalfont\large\bfseries}}
\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
  {-0.5\baselineskip \@plus -.2ex \@minus -.1ex}{1ex \@plus .2ex}{\raggedright\normalfont\normalsize\bfseries}}
\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
  {-0.5\baselineskip \@plus -.2ex \@minus -.1ex}{1ex \@plus .2ex}{\raggedright\normalfont\normalsize\itshape}}
\renewcommand{\paragraph}{\@startsection{paragraph}{4}{\z@}%
  {-0.5\baselineskip \@plus -.2ex \@minus -.1ex}{1ex \@plus .2ex}{\raggedright\normalfont\normalsize\itshape}}
\renewcommand{\subparagraph}{\@startsection{subparagraph}{5}{\z@}%
  {-0.5\baselineskip \@plus -.2ex \@minus -.1ex}{1ex \@plus .2ex}{\raggedright\normalfont\normalsize\itshape}}

\renewcommand\thesection{\arabic{section}}
%
%%% Testatine
%
% Le testatine sono in realtà demandate alle singole modalità.
% 
%%% Didascalie
%
\def\AT@tablecaptions{%
  \setlength{\belowcaptionskip}{\abovecaptionskip}%
  \setlength{\abovecaptionskip}{0pt}%
}

\def\AT@figurecaptions{}

% Il codice che segue era dentro \AtBeginDocument, che non mi sembra
% serva.
\long\def\@makecaption#1#2{%
  \@nameuse{AT@\@captype captions}
  \footnotesize
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\textsc{#1}: #2}%
  \ifdim \wd\@tempboxa >\hsize
    \textsc{#1}: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
%
%%% Markup per classi, pacchetti, comandi, ecc.
%
\newcommand*\pkgname[1]{\textsf{#1}}
\newcommand*\clsname[1]{\textsf{#1}}
\newcommand*\optname[1]{\textsf{#1}}
\newcommand*\envname[1]{\textsf{#1}}
\DeclareRobustCommand\cmdname[1]{\texttt{\char`\\#1}}
\DeclareRobustCommand\meta[1]{%
  \ensuremath{\langle}\emph{#1}\ensuremath{\rangle}}
%
%%% Acronimi. Da rivedere interamente?
\RequirePackage{texnames}
\RequirePackage{mflogo}
\RequirePackage{graphicx}
\newcommand\ConTeXt{C\kern-.0333emon\-\kern-.0667em\TeX\kern-.0333emt}
\DeclareRobustCommand\ConTeXtmkiv{\hbox{\ConTeXt-\texttt{mkiv}}}
\DeclareRobustCommand\eTeX{\ensuremath{\varepsilon}-\kern-.125em\TeX}
\DeclareRobustCommand\NTS{\ensuremath{\mathcal{N}\mkern-4mu
  \raisebox{-0.5ex}{$\mathcal{T}$}\mkern-2mu \mathcal{S}}}
\def\PCTeX{PC\thinspace\TeX}
\DeclareTextSymbol{\textohm}{OT1}{'012}
\DeclareTextSymbolDefault{\textohm}{OT1}
\newcommand\OMEGA{\textohm}
\DeclareRobustCommand{\OCP}{\OMEGA\textsc{CP}}
\DeclareRobustCommand{\OTP}{\OMEGA\textsc{TP}}
\def\pcTeX{\leavevmode\raise.5ex\hbox{p\kern-.3\p@ c}\TeX}
\def\pdfTeX{\textsc{pdf}\TeX}
\def\pdfLaTeX{\textsc{pdf}\LaTeX}
\def\PiC{P\kern-.12em\lower.5ex\hbox{I}\kern-.075emC\@}
\def\PiCTeX{\PiC\kern-.11em\TeX}
\def\plain{\texttt{plain}}
\def\SliTeX{\textrm{S\kern-.06em\textsc{l\kern-.035emi}%
                     \kern-.06em\TeX}}
\def\TANGLE{\texttt{TANGLE}\@}
\def\TeXXeT{\TeX-{}-\XeT}
\def\XeT{X\kern-.125em\lower.424ex\hbox{E}\kern-.1667emT\@}
\DeclareRobustCommand\XeTeX{%
  \leavevmode\hbox{X%
  \lower.5ex \hbox{\kern-.125em\reflectbox{E}}%
  \kern-.1667em \TeX}}
\DeclareRobustCommand\XeLaTeX{%
  \leavevmode$\smash{\hbox{X%
  \lower.5ex \hbox{\kern-.125em\reflectbox{E}}%
  \kern-.1667em \LaTeX}}$}
\newcommand{\LuaTeX}{\hbox{Lua\TeX}}
%
%%% Note a piè di pagina.
%
\renewcommand\@makefntext[1]{%
    \parindent 1em%
    \@thefnmark.\kern1.5mm#1}
\let\@atfootnoterule\footnoterule
\def\footnoterule{}
%
%%% Personalizzazione bibliografia (ma serve?)
%
\def\@atbibliopatch{%
  \@atbibfont
  \@atbibjustification
}
\def\@atbibfont{}
\def\@atbibjustification{}%{\raggedright}
%
%%% Bilanciamento manuale delle colonne.
%
% thanks to C. Beccari
\def\manualbalance{%
 \ifvmode
   \vfill
   \penalty -\@M%
 \else
   \@bsphack
   \vadjust{\vspace{\z@\@plus1fill}\penalty -\@M}%
   \@esphack
 \fi}
%
%%% Ripristino delle impostazioni di default per listings (da attivare
%%% solo se listings è caricato?). In realtà adesso è obsoleto...
%
\newcommand{\lstrestoredefault}{
  \lstset{abovecaptionskip=\smallskipamount,
    aboveskip=\medskipamount,
    backgroundcolor={},
    basicstyle={},
    belowcaptionskip=\smallskipamount,
    belowskip=\medskipamount,
    breakautoindent=true,
    breaklines=false,
    captionpos=t,
    columns=[c]fixed,
    commentstyle=\itshape,
    % emph=,
    emphstyle=\bfseries,
    % emph={[2]},
    emphstyle={[2]\bfseries},
    emptylines=2,
    escapeinside={},
    extendedchars=true,
    firstline=1,
    float=tbp,
    frame=none,
    frameround=ffff,
    gobble=0,
    identifierstyle={},
    keepspaces=false,
    keywordstyle=\bfseries,
    language={},
    lineskip=0pt,
    literate={},
    mathescape=false,
    morekeywords={},
    numbers=none,
    numbersep=10pt,
    numberstyle={},
    prebreak={},
    showspaces=false,
    showstringspaces=true,
    stepnumber=1,
    stringstyle={},
    texcsstyle=*{},
    xleftmargin=0pt,
    xrightmargin=0pt}}
%
%%% Salvataggio e disattivazione di \textlatin (?) Chiedere a CB.
%
\let\originaltextlatin\textlatin
\let\textlatin\relax
%
%%% Gestione dei bookmarks
%
\def\toclevel@ATtitle{-1}
%
%%% Modalità online/print
%
\colorlet{ATLinkColoronline}{blue!30!black}
\colorlet{ATLinkColorprint}{black}
% Color for links
\AtBeginDocument{
  \colorlet{ATLinkColor}{ATLinkColor\AT@mode}
  \hypersetup{% Attenzione: hyperref è sempre caricato! Dal pacchetto `guit', chiamato da `arstestata', chiamato da `arstexnica'. Non è più vero almeno dal 2012 (v0.9.1 di guit.sty).
    colorlinks  = true,  
    citecolor   = ATLinkColor,
    linkcolor   = ATLinkColor, 
    urlcolor    = ATLinkColor, 
    bookmarksdepth = 3,
  }
}
%
%%% Impostazioni dell'ultimo momento.
%
\AtBeginDocument{%
  \pagestyle{\@pjp}
  \let\AT@thebibliography\thebibliography
  \def\thebibliography{%
    \let\sloppy\@atbibliopatch
    \AT@thebibliography
  }
  \@ifpackageloaded{fvrb-ex}{\@fvrbextrue}{\@fvrbexfalse}
  \@ifpackageloaded{hyperref}{\@hyperreftrue}{\@hyperreffalse}
}
%
%%% Codice per le singole modalità
%
%%% Modalità paper
%
\ifAT@paper
% Suffisso
\def\@pjp{paper}
% Nessun sommario.
\let\toc@entry@paper\relax
% Nessuna data
\let\date@paper\relax
% Testatine
\def\AT@paper@header{\Ars\ N\textordmasculine\ 0, Dicembre 2099}
\def\ps@paper{%
  \def\@oddfoot{\hfil\thepage\hfil}
  \def\@evenfoot{\hfil\thepage\hfil}
  \def\@oddhead{\AT@paper@header\hfil\thetitle}
  \def\@evenhead{\theauthorlist\hfil\AT@paper@header}
}
\let\AT@oldtoc\tableofcontents
\let\tableofcontents\relax %% ?? Tanto per essere sicuri?
\def\@openarticle{\openarticlehook}
\def\@closearticle{\@makesig}
% Codice da caricare solo per [in]journal
% Fonte: http://tex.stackexchange.com/questions/11796/how-can-i-open-a-file-in-append-mode
\fi
\RequirePackage{catchfile}
\RequirePackage{environ}
\begingroup
  \catcode`\[ = 1\relax
  \catcode`\] = 2\relax
  \catcode`\{ = 12\relax
  \catcode`\} = 12 \relax
  \gdef\AT@open@group[{]
  \gdef\AT@close@group[}]
\endgroup
\def\AT@metadata@file{arstexnica.data}
\newwrite\AT@metadata
% \long\def\AT@immediate@protected@write#1#2#3{%
%   \begingroup
%   #2%
%   \let\protect\@unexpandable@protect
%   \edef\reserved@a{\immediate\write#1{#3}}%
%   \reserved@a
%   \endgroup
%   \if@nobreak\ifvmode\nobreak\fi\fi
% }
% \newcommand*\AT@appendtofile[2]{%
%   \begingroup
%   \IfFileExists{#1}%
%     {\CatchFileDef{\filecontent}{#1}{\catcode123=12\catcode125=12\endlinechar=`^^J\catcode\endlinechar=12\relax}}% keep existing end-of-lines
%     {\let\filecontent\empty}%
%   \immediate\openout\AT@metadata=#1\relax 
%   \AT@immediate@protected@write\AT@metadata{}{\filecontent #2}
%   \immediate\closeout\AT@metadata  
%   \endgroup
% }
%
%%% Modalità injournal
%
\newif\ifAT@first@abstract \AT@first@abstracttrue
\ifAT@injournal
% Suffisso
\def\@pjp{injournal}%
% Nessuna data
\let\date@injournal\relax
% Testatine
\let\ps@plain\ps@empty
\let\ps@injournal\ps@empty
\typeout{OPTION INJOURNAL}
\let\tableofcontents\relax %% ?? Tanto per essere sicuri?
\def\@openarticle{\openarticlehook}
\def\@closearticle{%
  \@makesig
  \AT@close@abstracts
}
\InputIfFileExists{../../arstexnica.cfg}{%
  \AT@cfgfound}{\AT@cfgnotfound}
%%%
\immediate\write18{rm \AT@metadata@file}
\def\AT@authors@hook#1{%
  \ifnum\c@author=\@ne
    \immediate\write\AT@metadata{["authors"]=\AT@open@group}
  \fi
  \immediate\write\AT@metadata{[[\unexpanded{#1}]],}
}
%%% Voci dei sommari iniziale e finale.
% Nel sommario voglio solo i titoli.
\setcounter{tocdepth}{0}
\def\toc@entry@injournal{%
  \openout\AT@lst=\jobname.lst
  \typeout{ESEGUISCO!!!}
  \typeout{AUTHOR LIST: \theauthorlist}
  \def\emptystring{}
  \ifx\theauthorlist\emptystring
    {\let\thanks\@gobble\addcontentsline{toc}{title}{{\@title}}}
  \else
    {\let\thanks\@gobble\addcontentsline{toc}{title}{{\@title}\newline \emph{\theauthorlist}}}
  \fi
  \protected@write\AT@lst{\let\thanks\@gobble \let\label\@gobble \let\index\@gobble \let\glossary\@gobble}{%
    \string\@titledata{\theauthorlist}{\@title}{\thetitle}{\thepage}}
 \closeout\AT@lst
  %%% mmm, magari non qui...
 \immediate\write\AT@metadata{\AT@close@group,}
 \immediate\write\AT@metadata{["title"]=[[\expandonce\@title]],}
}
\let\AT@old@abstract\abstract
\let\AT@old@endabstract\endabstract
\let\abstract\undefined
\let\endabstract\undefined
\def\AT@close@abstracts{}
\NewEnviron{abstract}{%
  \AT@old@abstract\BODY\AT@old@endabstract%
  \ifAT@first@abstract
    \immediate\write\AT@metadata{["abstracts"]=\AT@open@group}
    \global\def\AT@close@abstracts{\immediate\write\AT@metadata{\AT@close@group,}}
    \global\AT@first@abstractfalse
  \fi%  
  \immediate\write\AT@metadata{["\languagename"]=[[\expandonce\BODY]],}%
}
\AtEndOfClass{\immediate\openout\AT@metadata=\AT@metadata@file}
\AtEndDocument{\immediate\closeout\AT@metadata}
\fi
%
%%% journal + prima + quarta
%
\ifboolexpr{bool {AT@journal} or bool {AT@prima} or bool {AT@quarta}}{
  \RequirePackage{arstestata}
}{}
%
%%% journal quarta
%
\ifboolexpr{bool {AT@journal} or bool {AT@quarta}}{
  %%% Sommario
  \newcommand\IssueLine{{\IssueLineFont Numero \AT@number, \AT@month\ \AT@year}}
  \newcommand\IssueLineFont{\Large\itshape}
  \newlength{\arswidth}
}{}
%
%%% Modalità journal
%
\ifAT@journal
% Carica i pacchetti necessari
\RequirePackage{pdfpages}
\AtBeginDocument{
  \openout\AT@lst=suppl/copertina/artlist.lst
}
\newcommand\ATbackmatter{%
  \pagestyle{empty}
  \immediate\closeout\AT@lst
}
% Suffisso
\def\@pjp{journal}
% Nessuna data
\let\date@journal\relax
% Testatine
\def\AT@headfont{\itshape}
\def\AT@journalhead{\Ars\ N\textordmasculine\ \AT@number, \AT@month\ \AT@year}
\def\ps@journal{%
  \def\@oddfoot{\hfil\thepage\hfil}
  \def\@evenfoot{\hfil\thepage\hfil}
  \def\@oddhead{\AT@headfont\AT@journalhead\hfil\rightmark}
  \def\@evenhead{\AT@headfont\leftmark\hfil\AT@journalhead}
}
\let\ps@toc\ps@empty
% In modalità assemblaggio non stiamo processando nessun articolo,
% quindi non è necessario creare voci per un sommario.
\let\toc@entry@journal\relax
%
% Spostarsi su una pagina pari (da memoir)
%
\def\ATcleartoverso{\clearpage\if@twoside
  \ifodd\c@page\hbox{}\thispagestyle{empty}%
  \newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi}
%
%%% Sommario iniziale.
\def\ATtableofcontents{%
  \renewcommand{\contentsname}{}
  \onecolumn
  \settowidth{\arswidth}{\scalebox{7}{\Ars}}
  \vspace*{4cm}
  \begin{center}
    \parbox{\arswidth}{%
      \pdfbookmark[-1]{Sommario}{toc}
      \raggedleft
      \scalebox{7}{\Ars}\par
      \vspace{10pt}
      \ArsSubtitle}\par
    \vskip\baselineskip
    \IssueLine
  \end{center}
  \vskip4\baselineskip
  {\centering
    \begin{minipage}{\arswidth}
      \AT@oldtoc
    \end{minipage}\par
  }
  \vfill
  {\centering\LARGE \guittext\par}
  \thispagestyle{empty}
  \clearpage
  {\thispagestyle{empty}\cleardoublepage}
}
\def\ATquarta{
 \renewcommand{\contentsname}{}
  \onecolumn
  \settowidth{\arswidth}{\scalebox{7}{\Ars}}
  \vspace*{4cm}
  \begin{center}
    \parbox{\arswidth}{%
      \pdfbookmark[-1]{Sommario}{toc}
      \raggedleft
      \scalebox{7}{\Ars}\par
      \vspace{10pt}
      \ArsSubtitle}\par
    \vskip\baselineskip
    \IssueLine
  \end{center}
  \vskip4\baselineskip
  {\centering
    \begin{minipage}{\arswidth}
      \AT@oldtoc
    \end{minipage}\par
  }  
}
\renewcommand\numberline[1]{}
\newcommand*\l@ATtitle{\let\,\space\let\\\relax\@dottedtocline{0}{0pt}{0pt}}
%
% Composizione e inclusione degli articoli
%
\newcounter{AT@end@page}
\def\AT@subdirectory{}
\def\AT@divide@path#1/#2|{\def\AT@article@path{#1}\def\AT@article@name{#2}}
\newcommand\@titledata[4]{
  \markboth{#1}{#3}
  \gdef\AT@toc@header{#1\newline #2}
  \immediate\write\AT@lst{\string\@titledata{#1}{\unexpanded{#2}}{\unexpanded{#3}}{\thepage}}
}
\def\ATtitlemark#1{}
\newcounter{ATtitle}
\newcommand\AT@build@pdf[2][]{%
  \AT@divide@path#2|
  \AT@build@hook
  \immediate\write18{cd \AT@subdirectory/\AT@article@path && 
                     latexmk -pdf -pdflatex='pdflatex -shell-escape 
                         '\%O' \string\\PassOptionsToClass{#1}{arstexnica}\string\\input{'\%S'}' \AT@article@name && 
                     pdfannotextractor \AT@article@name.pdf}%
}
\newcommand\IncludeSuppl[2][]{%
  \def\AT@build@hook{}
  \def\AT@subdirectory{suppl}
  \AT@build@pdf[#1]{#2}
  \IfFileExists{\AT@subdirectory/#2.pdf}{%
    \includepdf[pages=-,
                pagecommand={},
                ]
                {\AT@subdirectory/#2.pdf}
  }{\typeout{Articolo #2: Qualcosa \'e andato storto...}}
}
\newcommand\IncludeArticle[1]{%
  \def\AT@build@hook{
    \immediate\write\AT@metadata{["\AT@article@name"]=\AT@open@group}
    \immediate\write\AT@metadata{["startpage"]=\thepage,}
  }
  \def\AT@subdirectory{articoli}
  \AT@build@pdf[injournal]{#1}
  \xdef\@currentHref{title.\theHtitle}%
  \makeatletter
  \InputIfFileExists{\AT@subdirectory/#1.lst}{%
    \typeout{Carico articolo #1}%
  }{\typeout{Articolo #1: Qualcosa \'e andato storto...}}
  \makeatother
  \thispagestyle{plain}
  \IfFileExists{\AT@subdirectory/#1.pdf}{%
    \includepdf[pages=-,
                pagecommand={},
                addtotoc={1,ATtitle,-1,\AT@toc@header,ATtitle-\theATtitle}
                ]
                {\AT@subdirectory/#1.pdf}
  }{\typeout{Articolo #1: Qualcosa \'e andato storto...}}
  \setcounter{AT@end@page}{\value{page}}
  \addtocounter{AT@end@page}{-1}
  \IfFileExists{\AT@subdirectory/\AT@article@path/\AT@metadata@file}%
    {\CatchFileDef{\tmpfilecontent}{\AT@subdirectory/\AT@article@path/\AT@metadata@file}{\catcode123=12\catcode125=12\endlinechar=`^^J\catcode\endlinechar=12\relax}}% keep existing end-of-lines
    {\let\filecontent\empty}%
  \immediate\write\AT@metadata{\expandonce\tmpfilecontent}
  \immediate\write\AT@metadata{["endpage"]=\theAT@end@page,}
  \immediate\write\AT@metadata{["path"]="\AT@subdirectory/\AT@article@path/",}
  \immediate\write\AT@metadata{\AT@close@group,}
}
\InputIfFileExists{\jobname.cfg}{%
  \AT@cfgfound}{\AT@cfgnotfound}
\AtBeginDocument{%
  \immediate\write18{rm arstexnica.data}
  \immediate\openout\AT@metadata=\AT@metadata@file
  \immediate\write\AT@metadata{do}
  \immediate\write\AT@metadata{metadata = \AT@open@group}
  \immediate\write\AT@metadata{articles = \AT@open@group}
}
\AtEndDocument{
  \setcounter{AT@end@page}{\value{page}}
  \addtocounter{AT@end@page}{-1}
  \immediate\write\AT@metadata{\AT@close@group,}
  \immediate\write\AT@metadata{["lastpage"] = \theAT@end@page,}
  \immediate\write\AT@metadata{["month"] = "\AT@month",}
  \immediate\write\AT@metadata{["year"] = "\AT@year",}
  \immediate\write\AT@metadata{["number"] = "\AT@number",}
  \immediate\write\AT@metadata{["issn-print"] = "1828-2350",}
  \immediate\write\AT@metadata{["issn-online"] = "1828-2369",}
  \immediate\write\AT@metadata{["mode"] = "\AT@mode",}
  \immediate\write\AT@metadata{\AT@close@group}
  \immediate\write\AT@metadata{return metadata}
  \immediate\write\AT@metadata{end}
  \immediate\closeout\AT@metadata
}
\fi
%
%%% Modalità prima di copertina
%
\ifAT@prima
\geometry{margin=2cm, noheadfoot, onecolumn}
\InputIfFileExists{../../arstexnica.cfg}{%
  \AT@cfgfound}{\AT@cfgnotfound}
\DeclareRobustCommand*{\copertina}[5]{%
  \@opencoverpage%
  \ATcoverleft{#1}{#2}{#3}\hfill%
  \ATcoversep\hfill%
  \ATcoverright{#4}{#5}%
  \@closecoverpage%
}%
\newcommand*\ATcoverleft[3]{%
  \parbox{\ATcoverleftlength}{%
    \vbox to\textheight{%
      \raggedleft%
      \vspace*{.1\textheight}%
      \vspace{\DropIssue}%
      \ArsIssue{#1}{#2}{#3}%
      \vfill
      \GuITlogo%
      \vspace{\RaiseIssue}%
      \vspace{.1\textheight}%
    }% fine \vbox
  }% fine \parbox
}
\newcommand*\ATcoversep{%
  \parbox{5pt}{%
    \color{lightgray}%
    \vfill%
    \rule{5pt}{.8\textheight}%
    \vfill
  }
}
\newcommand*\ATcoverright[2]{%
  \parbox{\ATcoverrightlength}{%
    \vbox to\textheight{%
      \vspace*{.1\textheight}%
      \vspace{\DropHeader}%
      \raggedright%
      \Arstestata%
      \vspace{\ImageDrop}%
      \PreImage\scalebox{#1}{#2}\PostImage
      \vfill
      \ArsFooterJust \ArsFooter%
      \vspace{\RaiseHeader}%
      \vspace{.1\textheight}%
    }% fine \vbox
  }% fine \parbox
}
\DeclareRobustCommand*{\ArsIssue}[3]{%
  \IssueFont%
  Numero #1\\
  #2 #3%
}
\DeclareRobustCommand*{\GuITlogo}{%
  \Huge\GuIT%
}
\DeclareRobustCommand*{\ArsFooter}{%
  \url{http://www.guitex.org/arstexnica}%
}
\newcommand*\IssueFont{\Large}
\newcommand*\@opencoverpage{%
  \thispagestyle{empty}%
  \let\save@parindent\parindent%
  \parindent\z@%
}
\newcommand*\@closecoverpage{%
  \let\parindent\save@parindent\newpage
  \RestoreDefaultSettings
}
\newlength\ATcoverleftlength
\settowidth\ATcoverleftlength{\IssueFont Aprile 2006}
\newlength\ATcoverrightlength
\setlength\ATcoverrightlength{\dimexpr\textwidth-\ATcoverleftlength-5pt-1cm\relax}% 1cm è lo spazio da distribuire
\newlength\PostHeaderSkip
\setlength\PostHeaderSkip{20mm}
\newlength\DropHeader
\setlength\DropHeader{0mm}
\newlength\DropIssue
\setlength\DropIssue{0mm}
\newlength\RaiseHeader
\setlength\RaiseHeader{0mm}
\newlength\RaiseIssue
\setlength\RaiseIssue{0mm}
\newlength\ImageDrop
\setlength\ImageDrop{20mm}
\newcommand*\PreImage{\hfill}
\newcommand*\PostImage{}
\newcommand*\ArsFooterJust{}
\newcommand*\RestoreDefaultSettings{%
  \setlength\DropHeader{0mm}%
  \setlength\DropIssue{0mm}%
  \setlength\RaiseHeader{0mm}%
  \setlength\RaiseIssue{0mm}%
  \renewcommand*\ArsFooterJust{}
}
\fi
%b
%%% Modalità seconda di copertina
%
\ifAT@seconda
\InputIfFileExists{../../arstexnica.cfg}{%
  \AT@cfgfound}{\AT@cfgnotfound}
\RequirePackage{eurosym}
\RequirePackage{ccicons}
\DeclareTextCommandDefault{\text@ccnc}{%
  \let\origfontencoding\f@encoding
  \let\origfontfamily\f@family
  \let\origfontseries\f@series
  \chardim\fontdimen6\font
  \divide\chardim by 2
  {
    \fontencoding{OT1}%
    \fontfamily{phv}\fontseries{b}\selectfont%
    \textcircled{%
      \raisebox{.15ex}{\fontsize{\chardim}{\baselineskip}\selectfont%
      \makebox[0cm][c]{\$}}%
      \setlength{\chardim}{1.98\chardim}%
      \fontsize{\chardim}{\baselineskip}\selectfont%
      \raisebox{-.20ex}{\begin{rotate}{45}\textbackslash\end{rotate}}%
    }
  }
  \fontencoding{\origfontencoding}%
  \fontfamily{\origfontfamily}\fontseries{\origfontseries}\selectfont
}

\DeclareRobustCommand*{\logoseccop}{\scalebox{10}{\arsto}}  % Logo
\DeclareRobustCommand*{\gguitext}{\noindent \guit\ -- \guittext}
\DeclareRobustCommand*{\pres}{\Ars{} \`e la pubblicazione ufficiale
del \guit}
\DeclareRobustCommand*{\redazione}{%
  \emph{Comitato di Redazione}
  \begin{list}{}{\itemsep\z@\parsep\z@\leftmargin\z@\topsep=3pt\partopsep\z@}
  \item Claudio Beccari -- \emph{Direttore}
  \item Roberto Giacomelli -- \emph{Comitato scientifico}
  \item Enrico Gregorio -- \emph{Comitato scientifico}
  \item Ivan Valbusa -- \emph{Comitato scientifico}
  \item Lorena Rachele Badile, Renato Battistin,
  \item Riccardo Campana, Massimo Caschili, 
  \item Gustavo Cevolani, Massimiliano Dominici,
  \item Tommaso Gordini, Carlo Marmo, 
  \item Gianluca Pignalberi, Ottavio Rizzo,
  \item Gianpaolo Ruocco, Enrico Spinielli,
  \item Emiliano Vavassori
  \end{list}\par\vskip6pt
}
\DeclareRobustCommand*{\guitind}{%
  \emph{\GuITtext}\\
  c/o Universit\`a degli Studi di Napoli Federico II\\
  Dipartimento di Ingegneria Industriale\\
  Via Claudio 21\\
  80125 Napoli -- Italia\\
  \guitweb\\
  \guitmail 
}

\DeclareRobustCommand*{\arsmail}{\texttt{arstexnica@guitex.org}} % Indirizzo posta elettronica redazione

\DeclareRobustCommand*{\guitmail}{\texttt{guit@sssup.it}} % Indirizzo posta elettronica GuiT

\DeclareRobustCommand*{\arsweb}{\texttt{http://www.guitex.org/arstexnica/}}% Indirizzo web ArsTeXnica
\DeclareRobustCommand*{\guitweb}{\texttt{http://www.guitex.org}}
% 
\DeclareRobustCommand*{\arsind}{%
  \emph{Redazione \Ars{}}:\\
  \arsweb\\
  \arsmail } %
\DeclareRobustCommand*{\contributi}{%
  \textbf{\large Associarsi a \guit}\par\medskip\noindent Fornire il tuo
  contributo a quest'iniziativa come membro, e non solo come
  semplice utente, \`e un presupposto fondamentale per aiutare la
  diffusione di \TeX\ e \LaTeX\ anche nel nostro paese.  L'adesione
  al Gruppo prevede una quota di iscrizione annuale diversificata:
  30,00 \euro\ soci ordinari, 20,00 (12,00) \euro\ studenti (junior),
  75,00 \euro\ Enti e Istituzioni.  }%Associati a GuIT
\DeclareRobustCommand*{\guitcopyright}{Copyright \copyright\ 2006
  \par \gguitext}% Copyright
\DeclareRobustCommand*{\issnprint}{Codice ISSN 1828-2350}% Codice ISSN
\DeclareRobustCommand*{\issnonline}{Codice ISSN 1828-2369}% Codice ISSN
\def\issn{\csname issn\AT@mode\endcsname}
\DeclareRobustCommand*{\finecolonna}{\par \vfill \columnbreak}
\DeclareRobustCommand*{\arsdatastampa}[1]{%
    \begin{list}{}{\itemsep\z@}
    \item
    Stampata in Italia\\
    Napoli: #1\ \AT@month\ \AT@year
    \end{list}
}
\DeclareRobustCommand*{\notacopy}{%
  \textbf{Nota sul Copyright}\par\medskip\noindent 
  Il presente documento e il suo contenuto \`e distribuito con licenza
  \ccLogo{} Creative Commons 2.0 di tipo ``Non commerciale, non opere
  derivate''. \`E possibile, riprodurre, distribuire, comunicare al
  pubblico, esporre al pubblico, rappresentare, eseguire o
  recitare il presente documento alle seguenti condizioni:
  
  \begin{description}
  \item[\ccAttribution] \textbf{Attribuzione:} devi riconoscere il contributo
    dell'autore originario.
  \item[\ccNonCommercialEU] \textbf{Non commerciale:} non puoi usare quest'opera per scopi
    commerciali.
  \item[\ccNoDerivatives] \textbf{Non opere derivate:} non puoi alterare,
    trasformare o sviluppare quest'opera.
  \end{description}
  
  In occasione di ogni atto di riutilizzazione o distribuzione,
  devi chiarire agli altri i termini della licenza di quest'opera;
  se ottieni il permesso dal titolare del diritto d'autore, \`e 
  possibile rinunciare ad ognuna di queste condizioni.
  
  Per maggiori informazioni:
  
  \begin{center}
    \texttt{http://www.creativecommons.org}
  \end{center}
}
\fi
%
%%% Modalità quarta di copertina
%
\ifAT@quarta
% Composizione del sommario finale.
\InputIfFileExists{../../arstexnica.cfg}{%
  \AT@cfgfound}{\AT@cfgnotfound}
\newcommand\ATindexlabel[1]{%
  \makebox[2.5em][r]{#1}}
\newcommand\@titledata[4]{%
  \newdimen\tmp%
  \advance\tmp by \textwidth%
  \advance\tmp by -4.5em%  
% The \phantom{q}s are to correct the depth of those lines with no descenders
  \item[#4] \begin{minipage}[t]{\tmp}\let\,\space\let\\\relax#2\phantom{q}\par%
  \textit{#1}\phantom{q}%
  \end{minipage}
}

\newcommand\ATarticlelist{%
  \begin{center}
  \large
  \list{}{\parsep=0pt \let\makelabel\ATindexlabel \labelsep=1em \listparindent=2.5em}
  \makeatletter
  \InputIfFileExists{artlist.lst}{}{}%
  \makeatother
  \endlist
  \end{center}
}

\newcommand\issnimg{../../issn_\AT@mode}
\fi
%
\AtEndDocument{\typeout{TOC level: \the\c@tocdepth}}
\endinput
