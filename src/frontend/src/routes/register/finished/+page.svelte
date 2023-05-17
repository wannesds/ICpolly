<script lang="ts">
	import { rootStore } from '$lib/stores/';
	import { RootState } from '$lib/stores/types';

	const finish = () => {
		rootStore.set(RootState.App);
	};
</script>

<h2>Well done!</h2>
<span>Profile finished</span>
<button on:click={finish} class="hover:bg-slate-500">Continue</button>
