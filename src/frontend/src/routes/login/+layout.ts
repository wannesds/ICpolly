import type { LayoutLoad } from './../$types';

export const load: LayoutLoad = () => {
	return {
		sections: [
			//refs to jump to element ids on login route (could be used a welcome/landing page)
			{ slug: '#home', title: 'Home' }
		]
	};
};
