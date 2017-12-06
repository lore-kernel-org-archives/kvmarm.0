From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5 11/16] firmware: arm_sdei: Add support for CPU and system power states
Date: Wed,  6 Dec 2017 19:01:37 +0000
Message-ID: <20171206190142.9246-12-james.morse@arm.com>
References: <20171206190142.9246-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206190142.9246-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Changes since v4:
 * Moved cpuhotplug callbacks later to prevent it pre-empting sdei_probe()
   before we are ready to unmask CPUs.
 * Changed cpuhotplug callbacks to make the in-memory state true, instead of
   save/restoring firmware state. This makes private events simpler.
 * Change unregister_all()/reregister_events() to only operate on shared
   events and remove the cpuhotplug state in the freeze/thaw callbacks.
 * Moved the was_enabled into the event:{reregister,reenable}
 * Dropped Catalin's ack.

Changes since v3:
 * Renamed CPUHP enum entry to have an ARM_ prefix.

 drivers/firmware/arm_sdei.c | 255 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/cpuhotplug.h  |   1 +
 2 files changed, 255 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 8da173cc7e43..0a4c75320840 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -7,6 +7,8 @@
 #include <linux/arm-smccc.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
+#include <linux/cpuhotplug.h>
+#include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
@@ -14,12 +16,15 @@
 #include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/percpu.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
+#include <linux/reboot.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
@@ -37,7 +42,11 @@ static asmlinkage void (*sdei_firmware_call)(unsigned long function_id,
 static unsigned long sdei_entry_point;
 
 struct sdei_event {
+	/* These three are protected by the sdei_list_lock */
 	struct list_head	list;
+	bool			reregister;
+	bool			reenable;
+
 	u32			event_num;
 	u8			type;
 	u8			priority;
@@ -253,6 +262,11 @@ static void _ipi_mask_cpu(void *ignored)
 	sdei_mask_local_cpu();
 }
 
+static int sdei_cpuhp_down(unsigned int ignored)
+{
+	return sdei_mask_local_cpu();
+}
+
 int sdei_unmask_local_cpu(void)
 {
 	int err;
@@ -274,6 +288,11 @@ static void _ipi_unmask_cpu(void *ignored)
 	sdei_unmask_local_cpu();
 }
 
+static int sdei_cpuhp_up(unsigned int ignored)
+{
+	return sdei_unmask_local_cpu();
+}
+
 static void _ipi_private_reset(void *ignored)
 {
 	int err;
@@ -330,6 +349,10 @@ int sdei_event_enable(u32 event_num)
 		return -ENOENT;
 	}
 
+	spin_lock(&sdei_list_lock);
+	event->reenable = true;
+	spin_unlock(&sdei_list_lock);
+
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_enable(event->event_num);
 	mutex_unlock(&sdei_events_lock);
@@ -356,6 +379,10 @@ int sdei_event_disable(u32 event_num)
 		return -ENOENT;
 	}
 
+	spin_lock(&sdei_list_lock);
+	event->reenable = false;
+	spin_unlock(&sdei_list_lock);
+
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_disable(event->event_num);
 	mutex_unlock(&sdei_events_lock);
@@ -374,6 +401,11 @@ static int _sdei_event_unregister(struct sdei_event *event)
 {
 	lockdep_assert_held(&sdei_events_lock);
 
+	spin_lock(&sdei_list_lock);
+	event->reregister = false;
+	event->reenable = false;
+	spin_unlock(&sdei_list_lock);
+
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		return sdei_api_event_unregister(event->event_num);
 
@@ -408,6 +440,31 @@ int sdei_event_unregister(u32 event_num)
 }
 EXPORT_SYMBOL(sdei_event_unregister);
 
+/*
+ * unregister events, but don't destroy them as they are re-registered by
+ * sdei_reregister_shared().
+ */
+static int sdei_unregister_shared(void)
+{
+	int err = 0;
+	struct sdei_event *event;
+
+	mutex_lock(&sdei_events_lock);
+	spin_lock(&sdei_list_lock);
+	list_for_each_entry(event, &sdei_list, list) {
+		if (event->type != SDEI_EVENT_TYPE_SHARED)
+			continue;
+
+		err = _sdei_event_unregister(event);
+		if (err)
+			break;
+	}
+	spin_unlock(&sdei_list_lock);
+	mutex_unlock(&sdei_events_lock);
+
+	return err;
+}
+
 static int sdei_api_event_register(u32 event_num, unsigned long entry_point,
 				   void *arg, u64 flags, u64 affinity)
 {
@@ -465,6 +522,174 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg)
 }
 EXPORT_SYMBOL(sdei_event_register);
 
+static int sdei_reregister_event(struct sdei_event *event)
+{
+	int err;
+
+	lockdep_assert_held(&sdei_events_lock);
+
+	err = _sdei_event_register(event);
+	if (err) {
+		pr_err("Failed to re-register event %u\n", event->event_num);
+		sdei_event_destroy(event);
+		return err;
+	}
+
+	if (event->reenable) {
+		if (event->type == SDEI_EVENT_TYPE_SHARED)
+			err = sdei_api_event_enable(event->event_num);
+	}
+
+	if (err)
+		pr_err("Failed to re-enable event %u\n", event->event_num);
+
+	return err;
+}
+
+static int sdei_reregister_shared(void)
+{
+	int err = 0;
+	struct sdei_event *event;
+
+	mutex_lock(&sdei_events_lock);
+	spin_lock(&sdei_list_lock);
+	list_for_each_entry(event, &sdei_list, list) {
+		if (event->type != SDEI_EVENT_TYPE_SHARED)
+			continue;
+
+		if (event->reregister) {
+			err = sdei_reregister_event(event);
+			if (err)
+				break;
+		}
+	}
+	spin_unlock(&sdei_list_lock);
+	mutex_unlock(&sdei_events_lock);
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
+		rv = sdei_mask_local_cpu();
+		break;
+	case CPU_PM_EXIT:
+		rv = sdei_unmask_local_cpu();
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
+ * events during freeze, then re-register and re-enable them during thaw
+ * and restore.
+ */
+static int sdei_device_freeze(struct device *dev)
+{
+	int err;
+
+	cpuhp_remove_state(CPUHP_AP_ARM_SDEI_STARTING);
+
+	err = sdei_unregister_shared();
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int sdei_device_thaw(struct device *dev)
+{
+	int err;
+
+	/* re-register shared events */
+	err = sdei_reregister_shared();
+	if (err) {
+		pr_warn("Failed to re-register shared events...\n");
+		sdei_mark_interface_broken();
+		return err;
+	}
+
+	err = cpuhp_setup_state(CPUHP_AP_ARM_SDEI_STARTING, "SDEI",
+				&sdei_cpuhp_up, &sdei_cpuhp_down);
+	if (err)
+		pr_warn("Failed to re-register CPU hotplug notifier...\n");
+
+	return err;
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
+	/*
+	 * We are going to reset the interface, after this there is no point
+	 * doing work when we take CPUs offline.
+	 */
+	cpuhp_remove_state(CPUHP_AP_ARM_SDEI_STARTING);
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
@@ -547,9 +772,36 @@ static int sdei_probe(struct platform_device *pdev)
 		return 0;
 	}
 
-	on_each_cpu(&_ipi_unmask_cpu, NULL, false);
+	err = cpu_pm_register_notifier(&sdei_pm_nb);
+	if (err) {
+		pr_warn("Failed to register CPU PM notifier...\n");
+		goto error;
+	}
+
+	err = register_reboot_notifier(&sdei_reboot_nb);
+	if (err) {
+		pr_warn("Failed to register reboot notifier...\n");
+		goto remove_cpupm;
+	}
+
+	err = cpuhp_setup_state(CPUHP_AP_ARM_SDEI_STARTING, "SDEI",
+				&sdei_cpuhp_up, &sdei_cpuhp_down);
+	if (err) {
+		pr_warn("Failed to register CPU hotplug notifier...\n");
+		goto remove_reboot;
+	}
 
 	return 0;
+
+remove_reboot:
+	unregister_reboot_notifier(&sdei_reboot_nb);
+
+remove_cpupm:
+	cpu_pm_unregister_notifier(&sdei_pm_nb);
+
+error:
+	sdei_mark_interface_broken();
+	return err;
 }
 
 static const struct of_device_id sdei_of_match[] = {
@@ -560,6 +812,7 @@ static const struct of_device_id sdei_of_match[] = {
 static struct platform_driver sdei_driver = {
 	.driver		= {
 		.name			= "sdei",
+		.pm			= &sdei_pm_ops,
 		.of_match_table		= sdei_of_match,
 	},
 	.probe		= sdei_probe,
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 201ab7267986..87b505a48a94 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -109,6 +109,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_XTENSA_STARTING,
 	CPUHP_AP_PERF_METAG_STARTING,
 	CPUHP_AP_MIPS_OP_LOONGSON3_STARTING,
+	CPUHP_AP_ARM_SDEI_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_DEBUG_MONITORS_STARTING,
 	CPUHP_AP_PERF_ARM_HW_BREAKPOINT_STARTING,
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
