<script lang="ts">
	import NavBars from '$lib/assets/icons/navBars.svg?component';
	import NavX from '$lib/assets/icons/navX.svg?component';
	import Nav from './Nav.svelte';
	import type { LayoutData } from '../../../routes/$types';

	let visible: boolean = false;
	export let data: LayoutData | undefined;

	function toggleVissible() {
		visible = !visible;
	}
</script>

<div class="flex flex-col">
	<button
		class="mt-2 shrink-0 self-end cursor-pointer"
		on:click={toggleVissible}
		on:keydown={toggleVissible}
	>
		{#if !visible}
			<NavBars class="w-8" />
		{:else}
			<NavX class="w-8" />
		{/if}
	</button>

	{#if visible}
		<div on:mouseleave={toggleVissible}>
			<Nav {data} path="" />
		</div>
	{/if}
</div>
