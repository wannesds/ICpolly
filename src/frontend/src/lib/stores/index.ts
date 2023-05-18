//groups all stores
import { actor, authStore, caller, user, syncAuth } from './auth';
import { appStore, regiStore, rootStore } from './routing';

// tasks folder is used for backend api actor functions

//====== STORES ======
//auth 
export { authStore, actor, user, caller, syncAuth };
//routing
export { rootStore, regiStore, appStore };
