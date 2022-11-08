import { ElMessage } from "element-plus"

import { useToteeStore } from "@/stores/totee"

export const useAuth = (target) => {
    return async function (...args) {
        const { $t } = useNuxtApp()
        const toteeStore = useToteeStore()

        if (!toteeStore.isConnected) {
            ElMessage.warning($t("Connect wallet first."))
            return
        }

        return target.call(this, ...args)
    }
}
