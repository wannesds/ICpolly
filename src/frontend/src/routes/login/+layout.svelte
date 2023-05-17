<script lang="ts">
	import DarkMode from "$lib/components/nav/DarkMode.svelte";

</script>

<header class="flex w-full justify-between h-18 border-main border-bottom px-4 md:px-8">
	<div class="text-2xl h-fit my-auto w-fit">Polly</div>

	<DarkMode/>
</header>

<main class="flex flex-col justify-center gap-8 m-auto px-4 md:px-8">
	<slot />
</main>

	

