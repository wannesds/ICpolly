<script lang="ts">
	import '../../../app.postcss';
	import { browser } from '$app/environment';
	import { goto } from '$app/navigation';
	import { rootStore, authStore, user, actor } from '$lib/stores/';
	import { RootState, AuthState } from '$lib/stores/types';
	import { onDestroy, onMount } from 'svelte';
	import { logout, syncAuth } from '$lib/stores/auth';

	//check lib/stores/auth for authentication and user login flow

	$: {
		//main root router handler, subscribed on stores for control
		if ($rootStore === RootState.Login || $authStore === AuthState.LoggedOut) {
			goto('/login');
		} else if ($rootStore === RootState.Register || $authStore === AuthState.LoggedIn) {
			goto('/register/username');
		} else if ($rootStore === RootState.App || $authStore === AuthState.Registered) {
			goto('/app/home');
		}
	}
	// make user logout onDestroy component,
	// onDestroy(() => {
	// 	logout();
	// });
	// onMount(async () => {
	// 	await syncAuth();
	// })
</script>

{#if browser}
	<div class="flex flex-col min-h-screen w-full">
		<slot />
	</div>
{:else}
	{console.error('Not in a browser!')}
{/if}
