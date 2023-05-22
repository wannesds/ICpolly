import Bug from '$lib/assets/icons/bug.svg';
import Home from '$lib/assets/icons/home.svg?component';
import Plus from '$lib/assets/icons/plus-circle.svg';
import Polls from '$lib/assets/icons/polls.svg?component';
import Sparkles from '$lib/assets/icons/sparkles.svg?component';
import User from '$lib/assets/icons/user.svg?component';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async () => {
	return {
		sections: [
			{ slug: 'home', title: 'Home', icon: Home },
			{ slug: 'polls', title: 'Polls', icon: Polls },
			{ slug: 'create', title: 'Create', icon: Plus },
			{ slug: 'token', title: 'Token', icon: Sparkles },
			{ slug: 'profile', title: 'Profile', icon: User },
			{ slug: 'report', title: 'Report', icon: Bug }
		]
	};
};
