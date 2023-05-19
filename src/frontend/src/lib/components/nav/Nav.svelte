<script lang="ts">
	import DarkMode from './DarkMode.svelte';
	import LoginBtn from './LoginBtn.svelte';
	import { authStore, user } from '$lib/stores';
	import { AuthState } from '$lib/stores/types';

	export let data: any;
	export let path: any;
</script>

<div class="flex flex-col w-40 h-full px-6 mt-4 text-lg items-start gap-4">
	<div class="h-[0.5px] w-full bg-slate-700" />

	{#if $authStore === AuthState.Registered}
		<!-- bg-clip-text text-transparent bg-fancy  -->
		<span class="font-semibold">
			<a href="./profile" class="dark:text-teal-100  mr-1">{$user.username}</a>
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
