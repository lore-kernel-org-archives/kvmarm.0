From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 09/11] firmware: arm_sdei: Add support for CPU and system
 power states
Date: Tue,  8 Aug 2017 17:46:14 +0100
Message-ID: <20170808164616.25949-10-james.morse@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B3840017
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 12:46:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zY4mgAt1WBL7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 12:46:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4742540CE0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 12:46:32 -0400 (EDT)
In-Reply-To: <20170808164616.25949-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu
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

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/firmware/arm_sdei.c | 228 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/cpuhotplug.h  |   1 +
 include/linux/sdei.h        |   3 +
 3 files changed, 231 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 74e84de5bf0b..abe032560663 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -22,6 +22,8 @@
 #include <linux/arm-smccc.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
+#include <linux/cpuhotplug.h>
+#include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
@@ -29,12 +31,15 @@
 #include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/percpu.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
+#include <linux/reboot.h>
 #include <linux/sdei.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
@@ -256,6 +261,11 @@ static void _ipi_mask_cpu(void *ignored)
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
@@ -277,6 +287,11 @@ static void _ipi_unmask_cpu(void *ignored)
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
@@ -315,6 +330,12 @@ static int sdei_platform_reset(void)
 	return err;
 }
 
+static int sdei_api_event_status(u32 event_num, u64 *result)
+{
+	return invoke_sdei_fn(SDEI_1_0_FN_SDEI_EVENT_STATUS, event_num, 0, 0, 0,
+			      0, result);
+}
+
 static int sdei_api_event_enable(u32 event_num)
 {
 	return invoke_sdei_fn(SDEI_1_0_FN_SDEI_EVENT_ENABLE, event_num, 0, 0, 0,
@@ -369,8 +390,23 @@ static int sdei_api_event_unregister(u32 event_num)
 
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
@@ -403,6 +439,26 @@ int sdei_event_unregister(u32 event_num)
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
 static int sdei_api_event_register(u32 event_num, unsigned long entry_point,
 				   void *arg, u64 flags, u64 affinity)
 {
@@ -459,6 +515,148 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg,
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
@@ -541,9 +739,36 @@ static int sdei_probe(struct platform_device *pdev)
 		return 0;
 	}
 
+	err = cpuhp_setup_state_nocalls(CPUHP_AP_SDEI_STARTING, "SDEI",
+				&sdei_cpuhp_up, &sdei_cpuhp_down);
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
@@ -554,6 +779,7 @@ static const struct of_device_id sdei_of_match[] = {
 static struct platform_driver sdei_driver = {
 	.driver		= {
 		.name			= "sdei",
+		.pm			= &sdei_pm_ops,
 		.of_match_table		= sdei_of_match,
 	},
 	.probe		= sdei_probe,
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index b56573bf440d..48420a6dfdaa 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -90,6 +90,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_XTENSA_STARTING,
 	CPUHP_AP_PERF_METAG_STARTING,
 	CPUHP_AP_MIPS_OP_LOONGSON3_STARTING,
+	CPUHP_AP_SDEI_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_DEBUG_MONITORS_STARTING,
 	CPUHP_AP_PERF_ARM_HW_BREAKPOINT_STARTING,
diff --git a/include/linux/sdei.h b/include/linux/sdei.h
index d19dbf2f29ca..431443536c11 100644
--- a/include/linux/sdei.h
+++ b/include/linux/sdei.h
@@ -89,6 +89,9 @@ struct sdei_registered_event {
 	sdei_event_callback	*callback;
 	void			*callback_arg;
 	u32			 event_num;
+
+	/* Only valid over power management events. */
+	bool			 was_enabled;
 };
 
 /* The arch code entry point should then call this when an event arrives. */
-- 
2.13.3
