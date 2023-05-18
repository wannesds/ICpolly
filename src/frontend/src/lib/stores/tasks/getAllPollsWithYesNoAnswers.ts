import { actor } from '$lib/stores';
import type { PollWithYesNoStats } from 'src/declarations/backend/backend.did';
import { get, writable } from 'svelte/store';

export const PollsWithYesNoStats = writable<Array<[PollWithYesNoStats, boolean]>>();
//bool indicates if caller has voted on it yet

export async function getAllPollsWithYesNoAnswers() {
	const localActor = get(actor);

	return await localActor.getAllPollsWithYesNoAnswers().then((res) => {
		console.log('found Polls:', res);
		if (res.hasOwnProperty('ok')) {
			PollsWithYesNoStats.set(res.ok);
			return res;
		} else if (res.hasOwnProperty('err')) {
			console.log(res.err);
			return res;
		} else {
			console.error(res);
		}
	});
}
