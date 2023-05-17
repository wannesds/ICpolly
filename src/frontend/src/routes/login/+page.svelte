<script lang="ts">
	import { login } from '$lib/stores/auth';

	//import Ic-badge from '$lib/assets/images/ic-badge.svg?component';

	//check login function + root layout on routing flow
	//(on loggedIn but not registered send to register route)
	//(on loggedIn and registered send to app route)
</script>

<h1 class="my-10">Decentralized Polling & Survey platform</h1>

<h2>Earn by <span class="highlight">Voting</span></h2>
<h2>Pay to create <span class="highlight">Polls</span></h2>


<button on:click={login} class="mt-10 main-btn mx-auto text-xl">Connect with Internet Identity</button>
