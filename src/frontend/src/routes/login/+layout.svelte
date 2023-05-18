<script lang="ts">
	import DarkMode from '$lib/components/nav/DarkMode.svelte';
</script>

<header class="flex w-full justify-between h-fit px-4 md:px-8">
	<h2 class="text-2xl h-fit my-auto w-fit">Poll<span class="highlight">y</span></h2>
	<DarkMode />
</header>

<main class="flex flex-col justify-between items-center gap-10 px-4 md:px-8">
	<slot />
</main>
