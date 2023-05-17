<script lang="ts">
	import { login } from '$lib/stores/auth';

	//check login function + root layout on routing flow
	//(on loggedIn but not registered send to register route)
	//(on loggedIn and registered send to app route)
</script>

<h1 class="my-20 px-4">
	Decentralized <span class="highlight">Polling</span> & <span class="highlight">Survey</span> platform
</h1>

<h2>Earn by <span class="highlight">Voting</span></h2>
<h2>Pay to fund <span class="highlight">Polls</span></h2>

<button on:click={login} class="main-btn mx-auto text-xl my-20"
	>Connect with Internet Identity</button
>
