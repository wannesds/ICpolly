<script lang="ts">
	import type { LayoutData } from './$types';

	import Nav from '$lib/components/nav/Nav.svelte';
	import Home from '$lib/assets/icons/home.svg?component';
	import User from '$lib/assets/icons/user.svg?component';

	//import { goto } from '$app/navigation';
	import DropdownNav from '$lib/components/nav/DropdownNav.svelte';
	import { user, caller } from '$lib/stores';
	import DarkMode from '$lib/components/nav/DarkMode.svelte';

	export let data: LayoutData;
</script>

<header class="flex w-full justify-between h-18 border-main border-bottom px-8">
	<div class="text-2xl h-fit my-auto w-fit">Polly</div>

	<DarkMode /> 
</header>

<!-- <header class="flex w-full justify-between h-18 bg-red-200/10">
	<div class="fixed left-0 h-18 md:hidden bg-teal-400/20">
	
		<Nav {data} path="" />
	</div>

	<div class="bg-teal-300/50 text-2xl">logo</div>

	<div class="stretch bg-slate-700/70" />
</header> -->

<main class="flex w-full">
	<span class="max-md:hidden w-40 bg-dark-700">
		<Nav {data} path="" />
	</span>

	<slot class="grow" />
</main>

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
