import Home from '$lib/assets/icons/home.svg?component';
import User from '$lib/assets/icons/user.svg?component';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async () => {
	return {
		sections: [
			{ slug: 'home', title: 'Home', icon: Home },
			{ slug: 'profile', title: 'Me', icon: User }
		]
	};
};
