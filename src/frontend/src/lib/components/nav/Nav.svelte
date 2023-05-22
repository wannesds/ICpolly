<script lang="ts">
	import DarkMode from './DarkMode.svelte';
	import LoginBtn from './LoginBtn.svelte';
	import { authStore, user } from '$lib/stores';
	import { AuthState } from '$lib/stores/types';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';
	// import Placeholder from '$lib/assets/icons/placeholder-pic.svg?component';
	import { get } from 'svelte/store';
	import { avatar } from '$lib/stores/auth';

	export let data: any;
	export let path: any;
</script>

<div class="flex flex-col w-40 h-full px-6 mt-4 text-lg items-start gap-3">
	<div class="h-[0.5px] w-full bg-slate-700" />

	{#if $authStore === AuthState.Registered}
		<!-- bg-clip-text text-transparent bg-fancy  -->
		<!-- {#if avatar == false}
			<Placeholder class="rounded-full w-10 h-10" />
		{:else} -->
		<img src={$avatar} alt="." class="rounded-full w-10 h-10" />
		<!-- {/if} -->

		<span class="font-semibol">
			<button on:click={() => goto('./profile')} class="dark:text-teal-100 mr-1"
				>{$user.username}</button
			>
		</span>
	{/if}
	<div class="h-[0.5px] w-full bg-slate-700" />

	<div class="-ml-2">
		{#if data}
			{#each data.sections as section}
				<a class="nav-link decoration-transparent rounded-md flex" href="{path}{section.slug}">
					<svelte:component this={section.icon} class="w-6 h-6 mr-1" />
					{section.title}
				</a>
			{/each}
		{/if}
	</div>
	<div class="h-[0.5px] w-full bg-slate-700" />
	<LoginBtn />
	<DarkMode />
</div>
