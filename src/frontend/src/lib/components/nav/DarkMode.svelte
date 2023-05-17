<script lang="ts">
	import { onMount } from 'svelte';
	import Sun from '$lib/assets/icons/sun.svg?component';
	import Moon from '$lib/assets/icons/moon.svg?component';

	let darkMode: any;
	let darkModeReady = false;

	onMount(() => {
		darkMode = document.documentElement.classList.contains('dark');
		darkModeReady = true;
	});
</script>

{#if darkModeReady}
	<span class="toggle mt-4">
		<input
			type="checkbox"
			id="toggle"
			bind:checked={darkMode}
			on:change={() => document.documentElement.classList.toggle('dark')}
		/>
		<label id="darkicon" title="Toggle dark mode" for="toggle" class="p-0.5 sub-btn">
			{#if darkMode}
				<Sun />
			{:else}
				<Moon class="ml-5 h-5 " />
			{/if}
		</label>
	</span>
{/if}

<style style lang="postcss">
	.toggle input[type='checkbox'] {
		display: none;
	}
	.toggle label {
		@apply inline-block cursor-pointer w-12 h-6 rounded-3xl ;
	}
	.toggle label::after {
		content: attr(data-dark);
		@apply flex items-center justify-center rounded-full cursor-pointer top-px left-px w-5 h-5 bg-transparent align-middle;
	}
</style>
