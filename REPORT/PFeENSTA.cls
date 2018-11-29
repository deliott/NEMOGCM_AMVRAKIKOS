\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{PFeENSTA}
  [10/06/2015 - Raph]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        CLASS  LOADER        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[a4paper,12pt,twoside,openright]{report}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      REQUIRED PACKAGES      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{array}
\RequirePackage{babel}
\RequirePackage{datatool}
\RequirePackage{environ}
\RequirePackage[T1]{fontenc}
\RequirePackage{fancyhdr}
\RequirePackage[top=0cm, bottom=0cm, left=2cm, right=2cm]{geometry}
\RequirePackage{graphicx}
\RequirePackage[
    bookmarks         = true,%     % Signets
    bookmarksnumbered = true,%     % Signets numérotés%
    bookmarksopen     = true,%     % Signets ouverts
    colorlinks        = true,%     % Liens en couleur : true ou false
    urlcolor          = blue,%     % Couleur des liens externes
    linkcolor         = black,%    % Couleur des liens internes
    citecolor         = black,%    % Couleur des citations
    ]{hyperref}% 
\RequirePackage{ifthen}
\RequirePackage{indentfirst}
\RequirePackage[toc,nopostdot,nonumberlist]{glossaries}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}
\RequirePackage{makeidx}
\RequirePackage{stmaryrd}
\RequirePackage{tocbibind}
\RequirePackage{url}
\RequirePackage{color}
\RequirePackage{kpfonts}
\RequirePackage{cite}
\RequirePackage{titletoc}
\RequirePackage{titlesec}


%%%%%%%%%%%%%%%%%%%
% Option générale %
%%%%%%%%%%%%%%%%%%%
\DeclareOption{french}{\def\enstaLang{fr}}
\DeclareOption{english}{\def\enstaLang{en}}
\ProcessOptions

%%%%%%%%%%%%%%%%%%
% Page d'accueil %
%%%%%%%%%%%%%%%%%%

\ifthenelse{\equal{\enstaLang}{fr}}{
  \addto\captionsenglish{\renewcommand{\chaptername}{Partie}}
  \def\enstaLangPRE{Projet de Recherche}
  \def\enstaLangSpecialite{Spécialité :}
  \def\enstaLangAnneeScolaire{Année Scolaire :}
  \def\enstaLangMentionConfidentialite{Mention de confidentialité}
  \def\enstaLangAuteur{Auteur :}
  \def\enstaLangTuteurENSTA{Tuteur ENSTA ParisTech :}
  \def\enstaLangPromo{Promotion :}
  \def\enstaLangTuteurOrganisme{Tuteur}
  \def\enstaLangStageEffectueDu{Stage effectué du}
  \def\enstaLangStageEffectueAu{au}
  \def\enstaLangNomOrganisme{Nom de l'organisme d'accueil :}
  \def\enstaLangAdresse{Adresse :}
}{
  \addto\captionsenglish{\renewcommand{\chaptername}{Part}}
  \def\enstaLangPRE{Research Internship}
  \def\enstaLangSpecialite{Field of Study:}
  \def\enstaLangAnneeScolaire{Scholar Year:}
  \def\enstaLangMentionConfidentialite{Confidentiality Notice}
  \def\enstaLangAuteur{Author:}
  \def\enstaLangTuteurENSTA{ENSTA ParisTech Tutor:}
  \def\enstaLangPromo{Promotion:}
  \def\enstaLangTuteurOrganisme{Tutor}
  \def\enstaLangStageEffectueDu{Internship from}
  \def\enstaLangStageEffectueAu{to}
  \def\enstaLangNomOrganisme{Name of the host organism:}
  \def\enstaLangAdresse{Address:}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Définition de variables %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\nom}[1]{\def\enstaNom{#1}}
\newcommand{\logo}[1]{\def\enstaLogoCorp{#1}}
\newcommand{\specialite}[1]{\def\enstaSpecialite{#1}}
\newcommand{\annees}[1]{\def\enstaAnneeScol{#1}}
\newcommand{\titre}[1]{\def\enstaTitre{#1}}
\newcommand{\soustitre}[1]{\def\enstaSousTitre{#1}}
\newcommand{\confidentialite}[1]{\def\enstaConfidentialite{#1}}
\newcommand{\noteConfidentialite}[1]{\def\enstaNoteConfidentialite{#1}}
\newcommand{\auteur}[1]{\def\enstaAuteur{#1}}
\newcommand{\promotion}[1]{\def\enstaPromotion{#1}}
\newcommand{\tuteurENSTA}[1]{\def\enstaTuteurENSTA{#1}}
\newcommand{\tuteurOrganisme}[1]{\def\enstaTuteurOrganisme{#1}}
\newcommand{\dateDebut}[1]{\def\enstaDateDebut{#1}}
\newcommand{\dateFin}[1]{\def\enstaDateFin{#1}}
\newcommand{\organisme}[1]{\def\enstaOrganisme{#1}}
\newcommand{\adresseOrganisme}[1]{\def\enstaAdresseOrganisme{#1}}

%%%%%%%%%%%%%%%%%
% Bibliographie %
%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%
% Header et Footer %
%%%%%%%%%%%%%%%%%%%%

\pagestyle{fancy}
\fancyhead{}
\fancyfoot{}
\fancyhead[CO]{\leftmark}
\fancyhead[CE]{\enstaTitre}
\fancyfoot[C]{\enstaAuteur ~/ \enstaOrganisme \\ \textbf{\color{red}\enstaConfidentialite}}
\fancyfoot[RO, LE] {\thepage}
\fancypagestyle{plain}{
\fancyhead{}
\fancyfoot{}
\fancyhead[CO]{\enstaTitre}
\fancyfoot[C]{\enstaAuteur ~/ \enstaOrganisme \\ \textbf{\color{red}\enstaConfidentialite}}
\fancyfoot[RO, LE] {\thepage}}

%%%%%%%%%
% Style %
%%%%%%%%%

\newcommand{\largeRule}[1]{\textcolor{#1}{\rule{15.5cm}{0.07cm}}}
\newcommand{\littleRule}[1]{\textcolor{#1}{\rule{9.5cm}{0.07cm}}}
	

%%%%%%%%%%%%%%%%%
% Page de garde %
%%%%%%%%%%%%%%%%%

\newcommand{\couverture}{
  \begin{titlepage}
    \begin{center}
    \vspace*{\stretch{2}}
    \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} lr}
      \includegraphics[height=4cm]{img/logo_ensta.png} & \includegraphics[height=3cm]{\enstaLogoCorp}
    \end{tabular*} \\[0.3cm]
    \vspace{0.5cm}
	\rule[0.5ex]{\linewidth}{2pt}\vspace*{-\baselineskip}\vspace*{3.2pt}
	\rule[0.5ex]{\linewidth}{1pt}\\[\baselineskip]    
    \Huge{\textsc{\underline{\enstaLangPRE}}} \\
    \vspace*{\stretch{0.5}}
    \huge \enstaTitre \\
    \ifthenelse{\equal{\enstaSousTitre}{}}
    {}
    {\large \enstaSousTitre\\ }
    \vspace{0.3cm}
	\rule[0.5ex]{\linewidth}{1pt}\vspace*{-\baselineskip}\vspace*{2.2pt}
	\rule[0.4ex]{\linewidth}{2pt}\\%[\baselineskip]   
    
    \vspace{0.7cm}

	\fbox{\begin{minipage}{0.95\textwidth}
	    \vspace{0.1cm}
    	\color{red} \center{\large\textsc{\underline{\enstaLangMentionConfidentialite}}} \\
    	\vspace{0.2cm}
    	\large \enstaConfidentialite
		\vspace{0.1cm}		
		\end{minipage}
	}

	\vspace{1.8cm}	
	
	\textsc{\large
	\begin{tabular}{ll}
		\enstaLangAuteur & \enstaAuteur \\
		\enstaLangSpecialite & \enstaSpecialite \\
		\enstaLangAnneeScolaire & \enstaAnneeScol \\
		\enstaLangPromo & \enstaPromotion 
	\end{tabular}
	}		
	
	\vspace{1.9cm}	
	
    \begin{minipage}{0.49\textwidth}
      \begin{center}
  		\large \textsc{\enstaLangTuteurENSTA} \\
  		\enstaTuteurENSTA \\
      \end{center}
    \end{minipage}
    \begin{minipage}{0.49\textwidth}
      \begin{center}
  		\large \textsc{\enstaLangTuteurOrganisme \ \enstaNom \ :} \\
  		\enstaTuteurOrganisme \\
      \end{center}
    \end{minipage} \\

	\vspace{2.5cm}
	
    \large \enstaLangStageEffectueDu ~\enstaDateDebut ~\enstaLangStageEffectueAu ~\enstaDateFin \\
    \vspace*{\stretch{0.5}}
    \large

    \vspace{0.8cm}
    \textsc{\enstaOrganisme} \\
    \textsc{\enstaAdresseOrganisme}

    \vspace*{\stretch{2}}
    \end{center}
  \end{titlepage}
  \newgeometry{top=2cm, bottom=2.5cm, left=2.5cm, right=2.5cm}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Page de confidentialité %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\pageConfidentialite}[1]{
	\chapterb{\enstaLangMentionConfidentialite}
	\begin{center}
	\fbox{\begin{minipage}{0.95\textwidth}
	    \vspace{0.4cm}
    	\color{red}
    	\large \center{\enstaNoteConfidentialite}
		\vspace{0.5cm}		
		\end{minipage}
	}
	\end{center}
}

%%%%%%%%%%%%%%%%%%%%%
% Résumé - Abstract %
%%%%%%%%%%%%%%%%%%%%%
\newcommand{\resume}{
	\rule{\linewidth}{0.5pt}\break\Huge			 
	\vspace{-0.5\baselineskip}
	Abstract	
	\rule{\linewidth}{0.5pt}
	\vspace{0.6\baselineskip}
}


%%%%%%%%%
% Corps %
%%%%%%%%%


\def\cleardoublepage{\clearpage
 \if@twoside
  \ifodd\c@page\else
   \null\thispagestyle{chapterverso}\newpage
   \if@twocolumn\null\newpage\fi
   \fi
  \fi
 }%
\def\ps@chapterverso{\ps@empty}%


% Style Table des Matieres et Titres

%Modification du style de la table des matières
\titlecontents
	{chapter}
	[100pt]
	{\addvspace{1pc}}
	{\scshape\bfseries\large\contentslabel[\ifthenelse{\equal{\thecontentslabel}{Table des matières}}{}{\chaptertitlename~\thecontentslabel}]{100pt}}
	{\scshape\bfseries\large}
	{\hrule\vspace{2pt}\hrule}
	[]
\titlecontents
	{section}
	[50pt]
	{\addvspace{0.6pc}}
	{\scshape\bfseries\small\contentslabel[\thecontentslabel]{20pt}}
	{}
	{\normalsize\dotfill\thecontentspage}
	[]
\titlecontents
	{subsection}
	[75pt]
	{\addvspace{0.2pc}}
	{\scshape\small\contentslabel[\thecontentslabel]{30pt}}
	{}
	{\normalsize\dotfill\thecontentspage}
	[]
\titlecontents
	{subsubsection}
	[100pt]
	{\addvspace{0.2pc}}
	{\normalfont\small\contentslabel[\thecontentslabel]{37pt}}
	{}
	{\normalsize\dotfill\thecontentspage}
	[]
\titlecontents
	{paragraph}
	[125pt]
	{\addvspace{0.2pc}}
	{\normalfont\small\contentslabel[\itshape\thecontentslabel]{43pt}}
	{}
	{\normalsize\dotfill\thecontentspage}
	[]
\contentsfinish

			
\newcommand{\chapterb}[1]{\chapter*{#1\addcontentsline{toc}{chapter}{#1}\markboth{#1}{#1}}}
\newcommand{\sectionb}[1]{\section*{#1\addcontentsline{toc}{section}{#1}\markboth{#1}{#1}}}


%Modification du style des chapitres, sections, sous-sections
\titleformat{\paragraph}[block]{}{\thesubparagraph}{\baselineskip}{}[]
\titleformat{\subsubsection}[block]{\scshape}{\normalfont\bfseries\thesubsubsection}{\baselineskip}{}[]
\titleformat{\subsection}[block]{\scshape}{\normalfont\bfseries\thesubsection}{\baselineskip}{}[\hrule]
\titleformat{\section}[block]{\bfseries\scshape}{\normalfont\large\bfseries\thesection}{\baselineskip\large}{}[\hrule\vspace{2pt}\hrule]
\titleformat
	{\chapter}
	[display]
	{\centering\normalfont\bfseries\large\scshape}
	{\rule[3pt]{0.15\linewidth}{3pt}\quad\quad\chaptertitlename\ \thechapter\quad\quad \rule[3pt]{0.15\linewidth}{3pt}}
	{0.2\baselineskip}
	{\rule{\linewidth}{0.5pt}\break\Huge}			 
	[\vspace{-0.5\baselineskip}\rule{\linewidth}{0.5pt}\vspace{0.6\baselineskip}]

\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{3}


%%%%%%%%%%%%%%%%%%%%%
% Liste des figures %
%%%%%%%%%%%%%%%%%%%%%

\renewcommand\listfigurename{Liste des Figures}

%%%%%%%%%%%%%%%%%%%%%
% INDEX - GLOSSAIRE %
%%%%%%%%%%%%%%%%%%%%%
\makeglossaries
\makeindex
