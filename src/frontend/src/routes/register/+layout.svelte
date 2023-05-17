<script lang="ts">
	import { goto } from '$app/navigation';
	import DarkMode from '$lib/components/nav/DarkMode.svelte';
	import { regiStore } from '$lib/stores/index';
	import { RegiState } from '$lib/stores/types';

	//initially set registration state
	regiStore.set(RegiState.Username);

	$: {
		//RegiState.Username is not used here since page is default
		if ($regiStore === RegiState.Profile) {
			goto('/register/profile');
		} else if ($regiStore === RegiState.Finished) {
			goto('/register/finished');
		}
	}
</script>

<header class="flex w-full justify-between h-fit px-4 md:px-8">

	<h2 class="text-2xl h-fit my-auto w-fit">Poll<span class="highlight">y</span></h2>
	<DarkMode />
</header>

<main class="flex flex-col justify-between items-center gap-10 px-4 md:px-8">
	<slot />
</main>
