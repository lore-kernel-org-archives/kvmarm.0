From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v2 10/11] firmware: arm_sdei: add support for CPU private events
Date: Tue,  8 Aug 2017 17:46:15 +0100
Message-ID: <20170808164616.25949-11-james.morse@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170808164616.25949-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Private SDE events are per-cpu, and need to be registered and enabled
on each CPU.

Hide this detail from the caller by adapting our {,un}register and
{en,dis}able calls to send an IPI to each CPU if the event is private.

CPU private events are unregistered when the CPU is powered-off, and
re-registered when the CPU is brought back online. This saves bringing
secondary cores back online to call private_reset() on shutdown, kexec
and resume from hibernate.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
Changes since v1:
 * Made unregister on cpu-down print an error and continue as returning an error
   from here is ignored.

 drivers/firmware/arm_sdei.c | 241 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 227 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index abe032560663..67f941246711 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -20,9 +20,11 @@
 
 #include <linux/acpi.h>
 #include <linux/arm-smccc.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <linux/cpuhotplug.h>
+#include <linux/cpu.h>
 #include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
@@ -65,12 +67,49 @@ struct sdei_event {
 	u64			priority;
 
 	/* This pointer is handed to firmware as the event argument. */
-	struct sdei_registered_event *registered;
+	union {
+		/* Shared events */
+		struct sdei_registered_event *registered;
+
+		/* CPU private events */
+		struct sdei_registered_event __percpu *private_registered;
+	};
 };
 
 static LIST_HEAD(sdei_events);
 static DEFINE_SPINLOCK(sdei_events_lock);
 
+/* When frozen, cpu-hotplug notifiers shouldn't unregister/re-register events */
+static bool frozen;
+
+/* Private events are registered/enabled via IPI passing one of these */
+struct sdei_crosscall_args {
+	struct sdei_event *event;
+	atomic_t errors;
+	int first_error;
+};
+
+#define CROSSCALL_INIT(arg, event)	(arg.event = event, \
+					 arg.first_error = 0, \
+					 atomic_set(&arg.errors, 0))
+
+static inline int sdei_do_cross_call(void *fn, struct sdei_event *event)
+{
+	struct sdei_crosscall_args arg;
+
+	CROSSCALL_INIT(arg, event);
+	on_each_cpu(fn, &arg, true);
+
+	return arg.first_error;
+}
+
+static inline void
+sdei_cross_call_return(struct sdei_crosscall_args *arg, int err)
+{
+	if (err && (atomic_inc_return(&arg->errors) == 1))
+		arg->first_error = err;
+}
+
 static int sdei_to_linux_errno(unsigned long sdei_err)
 {
 	switch (sdei_err) {
@@ -210,6 +249,25 @@ static struct sdei_event *sdei_event_create(u32 event_num,
 		reg->callback = cb;
 		reg->callback_arg = cb_arg;
 		event->registered = reg;
+	} else {
+		int cpu;
+		struct sdei_registered_event __percpu *regs;
+
+		regs = alloc_percpu(struct sdei_registered_event);
+		if (!regs) {
+			kfree(event);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		for_each_possible_cpu(cpu) {
+			reg = per_cpu_ptr(regs, cpu);
+
+			reg->event_num = event->event_num;
+			reg->callback = cb;
+			reg->callback_arg = cb_arg;
+		}
+
+		event->private_registered = regs;
 	}
 
 	if (sdei_event_find(event_num)) {
@@ -231,6 +289,8 @@ static void sdei_event_destroy(struct sdei_event *event)
 
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		kfree(event->registered);
+	else
+		free_percpu(event->private_registered);
 
 	kfree(event);
 }
@@ -261,11 +321,6 @@ static void _ipi_mask_cpu(void *ignored)
 	sdei_mask_local_cpu();
 }
 
-static int sdei_cpuhp_down(unsigned int ignored)
-{
-	return sdei_mask_local_cpu();
-}
-
 int sdei_unmask_local_cpu(void)
 {
 	int err;
@@ -287,11 +342,6 @@ static void _ipi_unmask_cpu(void *ignored)
 	sdei_unmask_local_cpu();
 }
 
-static int sdei_cpuhp_up(unsigned int ignored)
-{
-	return sdei_unmask_local_cpu();
-}
-
 static void _ipi_private_reset(void *ignored)
 {
 	int err;
@@ -342,6 +392,16 @@ static int sdei_api_event_enable(u32 event_num)
 			      0, NULL);
 }
 
+static void _ipi_event_enable(void *data)
+{
+	int err;
+	struct sdei_crosscall_args *arg = data;
+
+	err = sdei_api_event_enable(arg->event->event_num);
+
+	sdei_cross_call_return(arg, err);
+}
+
 int sdei_event_enable(u32 event_num)
 {
 	int err = -EINVAL;
@@ -353,6 +413,8 @@ int sdei_event_enable(u32 event_num)
 		err = -ENOENT;
 	else if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_enable(event->event_num);
+	else
+		err = sdei_do_cross_call(_ipi_event_enable, event);
 	spin_unlock(&sdei_events_lock);
 
 	return err;
@@ -365,6 +427,16 @@ static int sdei_api_event_disable(u32 event_num)
 			      0, 0, NULL);
 }
 
+static void _ipi_event_disable(void *data)
+{
+	int err;
+	struct sdei_crosscall_args *arg = data;
+
+	err = sdei_api_event_disable(arg->event->event_num);
+
+	sdei_cross_call_return(arg, err);
+}
+
 int sdei_event_disable(u32 event_num)
 {
 	int err = -EINVAL;
@@ -376,6 +448,9 @@ int sdei_event_disable(u32 event_num)
 		err = -ENOENT;
 	else if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_disable(event->event_num);
+	else
+		err = sdei_do_cross_call(_ipi_event_disable, event);
+
 	spin_unlock(&sdei_events_lock);
 
 	return err;
@@ -388,6 +463,27 @@ static int sdei_api_event_unregister(u32 event_num)
 			      0, 0, 0, NULL);
 }
 
+static void _local_event_unregister(void *data)
+{
+	int err;
+	u64 result;
+	struct sdei_registered_event *reg;
+	struct sdei_crosscall_args *arg = data;
+
+	WARN_ON_ONCE(preemptible());
+	lockdep_assert_held(&sdei_events_lock);
+
+	reg = per_cpu_ptr(arg->event->private_registered, smp_processor_id());
+	err = sdei_api_event_status(reg->event_num, &result);
+	if (!err) {
+		reg->was_enabled = !!(result & BIT(SDEI_EVENT_STATUS_ENABLED));
+
+		err = sdei_api_event_unregister(arg->event->event_num);
+	}
+
+	sdei_cross_call_return(arg, err);
+}
+
 static int _sdei_event_unregister(struct sdei_event *event)
 {
 	int err;
@@ -408,7 +504,7 @@ static int _sdei_event_unregister(struct sdei_event *event)
 		return sdei_api_event_unregister(event->event_num);
 	}
 
-	return -EINVAL;
+	return sdei_do_cross_call(_local_event_unregister, event);
 }
 
 int sdei_event_unregister(u32 event_num)
@@ -467,15 +563,41 @@ static int sdei_api_event_register(u32 event_num, unsigned long entry_point,
 			      flags, affinity, NULL);
 }
 
+static void _local_event_register(void *data)
+{
+	int err;
+	struct sdei_registered_event *reg;
+	struct sdei_crosscall_args *arg = data;
+
+	WARN_ON(preemptible());
+	lockdep_assert_held(&sdei_events_lock);
+
+	reg = per_cpu_ptr(arg->event->private_registered, smp_processor_id());
+	err = sdei_api_event_register(arg->event->event_num, sdei_entry_point,
+				      reg, 0, 0);
+
+	sdei_cross_call_return(arg, err);
+}
+
 static int _sdei_event_register(struct sdei_event *event)
 {
+	int err;
+
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		return sdei_api_event_register(event->event_num,
 					       sdei_entry_point,
 					       event->registered,
 					       SDEI_EVENT_REGISTER_RM_ANY, 0);
 
-	return -EINVAL;
+	get_online_cpus();
+
+	err = sdei_do_cross_call(_local_event_register, event);
+	if (err)
+		sdei_do_cross_call(_local_event_unregister, event);
+
+	put_online_cpus();
+
+	return err;
 }
 
 int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg,
@@ -515,6 +637,22 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg,
 }
 EXPORT_SYMBOL(sdei_event_register);
 
+static void _local_event_reenable(void *data)
+{
+	int err = 0;
+	struct sdei_registered_event *reg;
+	struct sdei_crosscall_args *arg = data;
+
+	WARN_ON_ONCE(preemptible());
+	lockdep_assert_held(&sdei_events_lock);
+
+	reg = per_cpu_ptr(arg->event->private_registered, smp_processor_id());
+	if (reg->was_enabled)
+		err = sdei_api_event_enable(arg->event->event_num);
+
+	sdei_cross_call_return(arg, err);
+}
+
 static int sdei_reregister_event(struct sdei_event *event)
 {
 	int err;
@@ -531,6 +669,8 @@ static int sdei_reregister_event(struct sdei_event *event)
 	if (event->type == SDEI_EVENT_TYPE_SHARED) {
 		if (event->registered->was_enabled)
 			err = sdei_api_event_enable(event->event_num);
+	} else {
+		err = sdei_do_cross_call(_local_event_reenable, event);
 	}
 
 	if (err)
@@ -555,6 +695,68 @@ static int sdei_reregister_events(void)
 	return err;
 }
 
+static int sdei_cpuhp_down(unsigned int cpu)
+{
+	struct sdei_event *event;
+	struct sdei_crosscall_args arg;
+
+	if (frozen) {
+		/* All events unregistered  */
+		return sdei_mask_local_cpu();
+	}
+
+	/* un-register private events */
+	spin_lock(&sdei_events_lock);
+	list_for_each_entry(event, &sdei_events, list) {
+		if (event->type == SDEI_EVENT_TYPE_SHARED)
+			continue;
+
+		CROSSCALL_INIT(arg, event);
+		/* call the cross-call function locally... */
+		_local_event_unregister(&arg);
+		if (arg.first_error)
+			pr_err("Failed to unregister event %u: %d\n",
+			       event->event_num, arg.first_error);
+	}
+	spin_unlock(&sdei_events_lock);
+
+	return sdei_mask_local_cpu();
+}
+
+static int sdei_cpuhp_up(unsigned int cpu)
+{
+	struct sdei_event *event;
+	struct sdei_crosscall_args arg;
+
+	if (frozen) {
+		/* Events will be re-registered when we thaw. */
+		return sdei_unmask_local_cpu();
+	}
+
+	/* re-register/enable private events */
+	spin_lock(&sdei_events_lock);
+	list_for_each_entry(event, &sdei_events, list) {
+		if (event->type == SDEI_EVENT_TYPE_SHARED)
+			continue;
+
+		CROSSCALL_INIT(arg, event);
+		/* call the cross-call function locally... */
+		_local_event_register(&arg);
+		if (arg.first_error)
+			pr_err("Failed to re-register event %u: %d\n",
+			       event->event_num, arg.first_error);
+
+		CROSSCALL_INIT(arg, event);
+		_local_event_reenable(&arg);
+		if (arg.first_error)
+			pr_err("Failed to re-enable event %u: %d\n",
+			       event->event_num, arg.first_error);
+	}
+	spin_unlock(&sdei_events_lock);
+
+	return sdei_unmask_local_cpu();
+}
+
 /* When entering idle, mask/unmask events for this cpu */
 static int sdei_pm_notifier(struct notifier_block *nb, unsigned long action,
 			    void *data)
@@ -607,6 +809,7 @@ static int sdei_device_freeze(struct device *dev)
 {
 	int err;
 
+	frozen = true;
 	err = sdei_event_unregister_all();
 	if (err)
 		return err;
@@ -616,9 +819,13 @@ static int sdei_device_freeze(struct device *dev)
 
 static int sdei_device_thaw(struct device *dev)
 {
+	int err;
+
 	sdei_device_resume(dev);
 
-	return sdei_reregister_events();
+	err = sdei_reregister_events();
+	frozen = false;
+	return err;
 }
 
 static int sdei_device_restore(struct device *dev)
@@ -650,6 +857,12 @@ static int sdei_reboot_notifier(struct notifier_block *nb, unsigned long action,
 
 	sdei_platform_reset();
 
+	/*
+	 * There is now no point trying to unregister private events if we go on
+	 * to take CPUs offline.
+	 */
+	frozen = true;
+
 	return NOTIFY_OK;
 }
 
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
