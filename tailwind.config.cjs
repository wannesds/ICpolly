const config = {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	darkMode: 'class',
	theme: {
		extend: {
			backgroundImage: {
				'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))'
			},
			colors: {
				'dark-600': '#183a30',
				'dark-700': '#0f1e1d',
				'dark-800': '#081110',
				'dark-900': '#040d0c',

				'white-700': '#bed0ca',
				'white-800': '#e0f1ec'
			},
			fontFamily: {
				// 'noto-sans': ['Noto-sans', 'sans-serif'],
				// roboto: ['Roboto', 'sans-serif'],
				// montserrat: ['Montserrat', 'sans-serif'],
				// montserratAlt: ['Montserrat Alternates', 'sans-serif']
				// // some are unused
			}
		}
	},

	plugins: []
};

module.exports = config;
