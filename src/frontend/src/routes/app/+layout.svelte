<script lang="ts">
	import type { LayoutData } from './$types';
	import ICPBanner from '$lib/assets/icons/poweredByICP.svg?component';
	import NavBars from '$lib/assets/icons/navBars.svg?component';
	import NavX from '$lib/assets/icons/navX.svg?component';
	import Nav from '$lib/components/nav/Nav.svelte';
	import { caller } from '$lib/stores';

	export let data: LayoutData;

	let visible = false;

	function toggleNav() {
		visible = !visible;
	}
</script>

<!-- TODO make s$lotted component for header and others -->
<header
	class="flex w-full fixed justify-start h-12 bg-slate-100/95 dark:bg-dark-900/95 gap-2 py-2 px-2 md:px-6"
>
	<button class="md:hidden shrink-0 self-end cursor-pointer" on:click={toggleNav}>
		{#if !visible}
			<NavBars class="w-8" />
		{:else}
			<NavX class="w-8" />
		{/if}
	</button>
	<h2 class="text-2xl h-fit my-auto w-fit">Poll<span class="highlight">y</span></h2>
</header>

<main class="flex w-full min-h-screen justify-between mt-10">
	{#if visible}
		<div
			class="z-30 w-40 bg-slate-100/95 dark:bg-dark-900/95 fixed h-full"
			on:mouseleave={toggleNav}
		>
			<Nav {data} path="" />
		</div>
	{:else}
		<div class="max-md:hidden w-40 bg-slate-100/95 dark:bg-dark-900/70 fixed h-full">
			<Nav {data} path="" />
		</div>
	{/if}

	<span class="flex flex-col w-full justify-start pt-8 md:pl-40">
		<slot />
	</span>
</main>

<footer
	class="h-fit z-40 flex md:flex-row flex-col gap-2 justify-start bg-slate-100/95 dark:bg-dark-900/95 md:pl-40 w-full items-center py-4"
>
	<a href="https://internetcomputer.org" class="">
		<ICPBanner class="opacity-70 hover:opacity-90" />
	</a>
	<span class="flex flex-col  max-md:items-center">
		<a href="https://github.com/wannesds" class="h-fit hover-color">Made by Wannes</a>
		<a href="https://ooudp-kiaaa-aaaak-aagvq-cai.raw.ic0.app/" class="h-fit hover-color"
			>Motoko Bootcamp 2023 Q2</a
		>
		<a href="/">Your principal : {caller}</a>
	</span>
</footer>
