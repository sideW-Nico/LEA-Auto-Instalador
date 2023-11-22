/#\[multilib\]/ {
	s/#\[multilib\]/\[multilib\]/g;
	n;
	/#Include = \/etc\/pacman.d\/mirrorlist/ {
		s/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g;
	}
	p;
	d;
}
