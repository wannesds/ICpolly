<script lang="ts">
	import type { LayoutData } from './$types';
	import ICPBanner from '$lib/assets/icons/icpBanner.svg?component';
	import NavBars from '$lib/assets/icons/navBars.svg?component';
	import NavX from '$lib/assets/icons/navX.svg?component';
	import Nav from '$lib/components/nav/Nav.svelte';
	import { onMount } from 'svelte';
	import { syncAuth } from '$lib/stores/auth';

	export let data: LayoutData;

	let visible = false;

	function toggleNav() {
		visible = !visible;
	}
</script>

<header class="flex w-full justify-start h-fit gap-2 py-2 px-2 md:px-6">
	<button class="md:hidden shrink-0 self-end cursor-pointer" on:click={toggleNav}>
		{#if !visible}
			<NavBars class="w-8" />
		{:else}
			<NavX class="w-8" />
		{/if}
	</button>

	<h2 class="text-2xl h-fit my-auto w-fit">Poll<span class="highlight">y</span></h2>
</header>

<main class="flex w-full min-h-screen">
	{#if visible}
		<div class="fixed w-40 bg-teal-50/90 dark:bg-neutral-900/90 h-full" on:mouseleave={toggleNav}>
			<Nav {data} path="" />
		</div>
	{:else}
		<div class="max-md:hidden w-40">
			<Nav {data} path="" />
		</div>
	{/if}

	<slot />
</main>

<footer class="h-fit flex gap-2 justify-start w-full py-2 px-4 md:px-8">
	<a href="https://internetcomputer.org" class="">
		<ICPBanner class=" vi opacity-70 hover:opacity-90" />
	</a>
	<span class="flex flex-col my-auto">
		<a href="https://github.com/wannesds" class="h-fit hover-color">Made by Wannes</a>
		<a href="https://ooudp-kiaaa-aaaak-aagvq-cai.raw.ic0.app/" class="h-fit hover-color"
			>Motoko Bootcamp 2023 Q2</a
		>
	</span>
</footer>

<!-- 

<div class="flex flex-row justify-center mt-8 gap-4">
	<div class=" h-fit w-full mt-1 min-h-screen">
		<slot />
	</div>

	<div class=" sticky top-16 h-fit w-44 mx-auto max-lg:hidden rounded-lg">
		<Nav {data} path="" />
	</div>
</div>


<div class="flex w-full  py-1 fixed bottom-0 sm:hidden rounded-t-lg justify-evenly">
	<a href="/app/home"><Home class="w-10" /></a>
	<a href="/app/profile"><User class="w-10 " /></a>
</div> -->
