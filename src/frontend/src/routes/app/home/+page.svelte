<script lang="ts">
	import Add from '$lib/assets/icons/plus-circle.svg?component';
	import ChevronUp from '$lib/assets/icons/chevronUp.svg?component';
	import Heart from '$lib/assets/icons/heart.svg?component';
	import { onMount } from 'svelte';

	import Spinner from '$lib/components/utils/Spinner.svelte';

	let expandWindow: boolean = false;
	let newQ: string;
	let pending: boolean = false;

	// onMount(async () => {
	// 	await SOMEFUNCGETS
	// });

	const submit = async () => {
		pending = true;

		// await SOMEFUNCSENDS().catch((error) => {
		// 	console.log('errorcatch', error);
		// });
		pending = false;
		newQ = '';
	};
</script>

<div class="flex flex-col gap-4">
	Home app
</div>
