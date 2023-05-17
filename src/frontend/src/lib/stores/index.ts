//groups all stores
import { actor, authStore, caller, user } from './auth';
import { appStore, regiStore, rootStore } from './routing';

// tasks folder is used for backend api actor functions

//====== STORES ======
//auth (auth hooks are not shown here, directly import from auth.ts)
export { authStore, actor, user, caller };
//routing
export { rootStore, regiStore, appStore };
