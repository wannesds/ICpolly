<script lang="ts">
	import { logout, login } from '$lib/stores/auth';
	import { authStore } from '$lib/stores';
	import { AuthState } from '$lib/stores/types';
	import Logout from '$lib/assets/icons/logout.svg?component';
</script>

<a
	class="w-fit nav-link decoration-transparent rounded-md cursor-pointer flex"
	href={null}
	on:click={$authStore === AuthState.LoggedIn || $authStore === AuthState.Registered
		? logout
		: login}
>
	<Logout class="w-6 m-1 ml-0" />
	{#if $authStore === AuthState.LoggedIn || $authStore === AuthState.Registered}
		Logout
	{:else}
		Login
	{/if}
</a>
