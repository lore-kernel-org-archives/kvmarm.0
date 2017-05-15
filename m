From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 09/11] firmware: arm_sdei: Add support for CPU and system power states
Date: Mon, 15 May 2017 18:43:57 +0100
Message-ID: <20170515174400.29735-10-james.morse@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515174400.29735-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

When a CPU enters an idle lower-power state or is powering off, we
need to mask SDE events so that no events can be delivered while we
are messing with the MMU as the registered entry points won't be valid.

If the system reboots, we want to unregister all events and mask the CPUs.
For kexec this allows us to hand a clean slate to the next kernel
instead of relying on it to call sdei_{private,system}_data_reset().

For hibernate we unregister all events and re-register them on restore,
in case we restored with the SDE code loaded at a different address.
(e.g. KASLR).

Add all the notifiers necessary to do this. We only support shared events
so all events are left registered and enabled over CPU hotplug.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 drivers/firmware/arm_sdei.c | 223 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/cpuhotplug.h  |   1 +
 include/linux/sdei.h        |   3 +
 3 files changed, 226 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index afd9499a0e2d..f9912d2ba2d3 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -22,17 +22,22 @@
 #include <linux/arm-smccc.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
+#include <linux/cpuhotplug.h>
+#include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/kvm_host.h>
 #include <linux/list.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/percpu.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
+#include <linux/reboot.h>
 #include <linux/sdei.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
@@ -332,6 +337,17 @@ static int sdei_platform_reset(void)
 	return err;
 }
 
+static int sdei_api_event_status(u32 event_num, u64 *result)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_STATUS, event_num, 0,
+				0, 0, 0);
+	*result = res.a0;
+	return err;
+}
+
 static int sdei_api_event_enable(u32 event_num)
 {
 	struct arm_smccc_res res;
@@ -395,8 +411,23 @@ static int sdei_api_event_unregister(u32 event_num)
 
 static int _sdei_event_unregister(struct sdei_event *event)
 {
-	if (event->type == SDEI_EVENT_TYPE_SHARED)
+	int err;
+	u64 result;
+	bool enabled;
+
+	if (event->type == SDEI_EVENT_TYPE_SHARED) {
+		/*
+		 * We re-register events after power-management, remember if
+		 * this event was previously enabled.
+		 */
+		err = sdei_api_event_status(event->event_num, &result);
+		if (err)
+			return err;
+		enabled = !!(result & BIT(SDEI_EVENT_STATUS_ENABLED));
+		event->registered->was_enabled = enabled;
+
 		return sdei_api_event_unregister(event->event_num);
+	}
 
 	return -EINVAL;
 }
@@ -429,6 +460,26 @@ int sdei_event_unregister(u32 event_num)
 }
 EXPORT_SYMBOL(sdei_event_unregister);
 
+/*
+ * unregister events, but don't destroy them as they are re-registered by
+ * sdei_reregister_events().
+ */
+static int sdei_event_unregister_all(void)
+{
+	int err = 0;
+	struct sdei_event *event;
+
+	spin_lock(&sdei_events_lock);
+	list_for_each_entry(event, &sdei_events, list) {
+		err = _sdei_event_unregister(event);
+		if (err)
+			break;
+	}
+	spin_unlock(&sdei_events_lock);
+
+	return err;
+}
+
 static int sdei_api_event_register(u32 event_num, void *entry_point, void *arg,
 			       u64 flags, u64 affinity)
 {
@@ -484,6 +535,148 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg)
 }
 EXPORT_SYMBOL(sdei_event_register);
 
+static int sdei_reregister_event(struct sdei_event *event)
+{
+	int err;
+
+	WARN_ON(!spin_is_locked(&sdei_events_lock));
+
+	err = _sdei_event_register(event);
+	if (err) {
+		pr_err("Failed to re-register event %u\n", event->event_num);
+		sdei_event_destroy(event);
+		return err;
+	}
+
+	if (event->type == SDEI_EVENT_TYPE_SHARED) {
+		if (event->registered->was_enabled)
+			err = sdei_api_event_enable(event->event_num);
+	}
+
+	if (err)
+		pr_err("Failed to re-enable event %u\n", event->event_num);
+
+	return err;
+}
+
+static int sdei_reregister_events(void)
+{
+	int err = 0;
+	struct sdei_event *event;
+
+	spin_lock(&sdei_events_lock);
+	list_for_each_entry(event, &sdei_events, list) {
+		err = sdei_reregister_event(event);
+		if (err)
+			break;
+	}
+	spin_unlock(&sdei_events_lock);
+
+	return err;
+}
+
+/* When entering idle, mask/unmask events for this cpu */
+static int sdei_pm_notifier(struct notifier_block *nb, unsigned long action,
+			    void *data)
+{
+	int rv;
+
+	switch (action) {
+	case CPU_PM_ENTER:
+		rv = sdei_mask_local_cpu(smp_processor_id());
+		break;
+	case CPU_PM_EXIT:
+		rv = sdei_unmask_local_cpu(smp_processor_id());
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	if (rv)
+		return notifier_from_errno(rv);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block sdei_pm_nb = {
+	.notifier_call = sdei_pm_notifier,
+};
+
+static int sdei_device_suspend(struct device *dev)
+{
+	on_each_cpu(_ipi_mask_cpu, NULL, true);
+
+	return 0;
+}
+
+static int sdei_device_resume(struct device *dev)
+{
+	on_each_cpu(_ipi_unmask_cpu, NULL, true);
+
+	return 0;
+}
+
+/*
+ * We need all events to be reregistered when we resume from hibernate.
+ *
+ * The sequence is freeze->thaw. Reboot. freeze->restore. We unregister
+ * events during freeze and save the enabled state, then re-register and
+ * enable them during thaw and restore.
+ */
+static int sdei_device_freeze(struct device *dev)
+{
+	int err;
+
+	err = sdei_event_unregister_all();
+	if (err)
+		return err;
+
+	return sdei_device_suspend(dev);
+}
+
+static int sdei_device_thaw(struct device *dev)
+{
+	sdei_device_resume(dev);
+
+	return sdei_reregister_events();
+}
+
+static int sdei_device_restore(struct device *dev)
+{
+	int err;
+
+	err = sdei_platform_reset();
+	if (err)
+		return err;
+
+	return sdei_device_thaw(dev);
+}
+
+static const struct dev_pm_ops sdei_pm_ops = {
+	.suspend = sdei_device_suspend,
+	.resume = sdei_device_resume,
+	.freeze = sdei_device_freeze,
+	.thaw = sdei_device_thaw,
+	.restore = sdei_device_restore,
+};
+
+/*
+ * Mask all CPUs and unregister all events on panic, reboot or kexec.
+ */
+static int sdei_reboot_notifier(struct notifier_block *nb, unsigned long action,
+				void *data)
+{
+	on_each_cpu(&_ipi_mask_cpu, NULL, true);
+
+	sdei_platform_reset();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block sdei_reboot_nb = {
+	.notifier_call = sdei_reboot_notifier,
+};
+
 static void sdei_smccc_smc(unsigned long function_id,
 			   unsigned long arg0, unsigned long arg1,
 			   unsigned long arg2, unsigned long arg3,
@@ -566,9 +759,36 @@ static int sdei_probe(struct platform_device *pdev)
 		return 0;
 	}
 
+	err = cpuhp_setup_state_nocalls(CPUHP_AP_SDEI_STARTING, "SDEI",
+				&sdei_unmask_local_cpu, &sdei_mask_local_cpu);
+	if (err) {
+		pr_warn("Failed to register CPU hotplug notifier...\n");
+		return err;
+	}
+
+	err = cpu_pm_register_notifier(&sdei_pm_nb);
+	if (err) {
+		pr_warn("Failed to register CPU PM notifier...\n");
+		goto remove_cpuhp;
+	}
+
+	err = register_reboot_notifier(&sdei_reboot_nb);
+	if (err) {
+		pr_warn("Failed to register reboot notifier...\n");
+		goto remove_cpupm;
+	}
+
 	on_each_cpu(&_ipi_unmask_cpu, NULL, false);
 
 	return 0;
+
+remove_cpupm:
+	cpu_pm_unregister_notifier(&sdei_pm_nb);
+
+remove_cpuhp:
+	cpuhp_remove_state_nocalls(CPUHP_AP_SDEI_STARTING);
+
+	return err;
 }
 
 static const struct of_device_id sdei_of_match[] = {
@@ -579,6 +799,7 @@ static const struct of_device_id sdei_of_match[] = {
 static struct platform_driver sdei_driver = {
 	.driver		= {
 		.name			= "sdei",
+		.pm			= &sdei_pm_ops,
 		.of_match_table		= sdei_of_match,
 	},
 	.probe		= sdei_probe,
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 0f2a80377520..5c5012c211a8 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -91,6 +91,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_XTENSA_STARTING,
 	CPUHP_AP_PERF_METAG_STARTING,
 	CPUHP_AP_MIPS_OP_LOONGSON3_STARTING,
+	CPUHP_AP_SDEI_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_DEBUG_MONITORS_STARTING,
 	CPUHP_AP_PERF_ARM_HW_BREAKPOINT_STARTING,
diff --git a/include/linux/sdei.h b/include/linux/sdei.h
index 6138582faf4b..3b933d37a87d 100644
--- a/include/linux/sdei.h
+++ b/include/linux/sdei.h
@@ -87,6 +87,9 @@ struct sdei_registered_event {
 	sdei_event_callback	*callback;
 	void			*callback_arg;
 	u32			 event_num;
+
+	/* Only valid over power management events. */
+	bool			 was_enabled;
 };
 
 /* The arch code entry point should then call this when an event arrives. */
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
