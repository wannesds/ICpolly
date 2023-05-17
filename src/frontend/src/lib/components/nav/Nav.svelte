<script lang="ts">
	import { caller, user } from '$lib/stores/index';
	import DarkMode from './DarkMode.svelte';
	import LoginBtn from './LoginBtn.svelte';
	import Heart from '$lib/assets/icons/heart.svg?component';
	import GithubLogo from '$lib/assets/icons/gh.svg?component';
	import { authStore } from '$lib/stores';
	import { AuthState } from '$lib/stores/types';

	export let data: any;
	export let path: any;
</script>

<div
	class="rounded-lg w-40 my-1 mx-auto p-0.5 bg-neutral-800
"
>
	<div class="flex flex-col rounded-lg p-2 text-lg items-start ">
		{#if $authStore === AuthState.Registered}
			<!-- bg-clip-text text-transparent bg-fancy  -->
			<span class="font-semibold">
				<a href="/">{$user.username}</a>
			</span>
			<div class="h-0.5 my-2 px-3 w-full" />
		{/if}

		{#if data}
			{#each data.sections as section}
				<a class="w-fit decoration-transparent rounded-md p-1 flex" href="{path}{section.slug}">
					<svelte:component this={section.icon} class="w-6 mr-1 -ml-1" />
					{section.title}
				</a>
			{/each}
			<div class="border-main h-0.5 my-2 px-3 w-full" />
		{/if}

		<LoginBtn />
		<DarkMode />
		<div class="border-main h-0.5 my-2 px-3 w-full" />
		<a href="https://github.com/" class="flex gap-1 text-sm p-1 hover:bg-sub rounded-md">
			<GithubLogo class="w-6 text-zinc-200 rounded-full" />
			<span class="m-auto">Add your link v0.0.0</span>
		</a>
	</div>
</div>
