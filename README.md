# fpga-wrapper
Ce projet met en œuvre un système de vérification d'identifiants sur FPGA à l'aide d'un processeur MicroBlaze et d'une communication via le bus AXI4-Lite. Un identifiant fixe est envoyé par le MicroBlaze à un module wrapper, tandis qu’un identifiant dynamique est généré et transmis par une IP AXI master. Le wrapper compare les deux identifiants et indique si l’accès est accordé ou refusé. Une interruption est levée après plusieurs erreurs. Une application en C, développée avec Vitis, lit les registres en continu et affiche l’état du système via l’interface UART.

Dans ce projet vous retrouverez deux dossier : "IP_Generator" et "IP_wrapper" ce sont les deux IP créés afin de pourvoir les ajouter à notre bloc design principal

Le dossier TEST_app c'est le projet d'application dans Vitis où on retrouve le code c qui va tourner dans le MicroBlaze

Le fichier .xsa c'est l'export du hardware (incluant le bitstream)
