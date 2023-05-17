<script lang="ts">
	import { goto } from '$app/navigation';
	import { regiStore } from '$lib/stores/index';
	import { RegiState } from '$lib/stores/types';

	//initially set registration state
	regiStore.set(RegiState.Username);

	$: {
		//RegiState.Username is not used here since page is default
		if ($regiStore === RegiState.Profile) {
			goto('/register/profile');
		} else if ($regiStore === RegiState.Finished) {
			goto('/register/finished');
		}
	}
</script>

<div class="flex flex-col justify-center items-center w-11/12 h-fit border-main">
	<slot />
</div>
