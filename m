From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5 12/16] firmware: arm_sdei: add support for CPU private events
Date: Wed,  6 Dec 2017 19:01:38 +0000
Message-ID: <20171206190142.9246-13-james.morse@arm.com>
References: <20171206190142.9246-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206190142.9246-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Changes since v4:
 * rip out the racy frozen flag.
 * hotplug hooks honour the event reregister/renable flags instead of
   save/restoring the firmware state, these flags are protected by the
   spinlock.
 * Repurposed the event-enable ipi-call instead of having a redundant
   re-enable call.
 * Dropped Catalin's ack

 drivers/firmware/arm_sdei.c | 206 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 193 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 0a4c75320840..10a8bfa7339a 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -5,9 +5,11 @@
 #include <linux/acpi.h>
 #include <linux/arm_sdei.h>
 #include <linux/arm-smccc.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <linux/cpuhotplug.h>
+#include <linux/cpu.h>
 #include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
@@ -52,7 +54,13 @@ struct sdei_event {
 	u8			priority;
 
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
 
 /* Take the mutex for any API call or modification. Take the mutex first. */
@@ -62,6 +70,34 @@ static DEFINE_MUTEX(sdei_events_lock);
 static DEFINE_SPINLOCK(sdei_list_lock);
 static LIST_HEAD(sdei_list);
 
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
+static inline int sdei_do_cross_call(void *fn, struct sdei_event * event)
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
@@ -207,6 +243,26 @@ static struct sdei_event *sdei_event_create(u32 event_num,
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
+			reg->priority = event->priority;
+			reg->callback = cb;
+			reg->callback_arg = cb_arg;
+		}
+
+		event->private_registered = regs;
 	}
 
 	if (sdei_event_find(event_num)) {
@@ -232,6 +288,8 @@ static void sdei_event_destroy(struct sdei_event *event)
 
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		kfree(event->registered);
+	else
+		free_percpu(event->private_registered);
 
 	kfree(event);
 }
@@ -262,11 +320,6 @@ static void _ipi_mask_cpu(void *ignored)
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
@@ -288,11 +341,6 @@ static void _ipi_unmask_cpu(void *ignored)
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
@@ -337,6 +385,19 @@ static int sdei_api_event_enable(u32 event_num)
 			      0, NULL);
 }
 
+/* Called directly by the hotplug callbacks */
+static void _local_event_enable(void *data)
+{
+	int err;
+	struct sdei_crosscall_args *arg = data;
+
+	WARN_ON_ONCE(preemptible());
+
+	err = sdei_api_event_enable(arg->event->event_num);
+
+	sdei_cross_call_return(arg, err);
+}
+
 int sdei_event_enable(u32 event_num)
 {
 	int err = -EINVAL;
@@ -355,6 +416,8 @@ int sdei_event_enable(u32 event_num)
 
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_enable(event->event_num);
+	else
+		err = sdei_do_cross_call(_local_event_enable, event);
 	mutex_unlock(&sdei_events_lock);
 
 	return err;
@@ -367,6 +430,16 @@ static int sdei_api_event_disable(u32 event_num)
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
@@ -385,6 +458,8 @@ int sdei_event_disable(u32 event_num)
 
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_disable(event->event_num);
+	else
+		err = sdei_do_cross_call(_ipi_event_disable, event);
 	mutex_unlock(&sdei_events_lock);
 
 	return err;
@@ -397,6 +472,19 @@ static int sdei_api_event_unregister(u32 event_num)
 			      0, 0, 0, NULL);
 }
 
+/* Called directly by the hotplug callbacks */
+static void _local_event_unregister(void *data)
+{
+	int err;
+	struct sdei_crosscall_args *arg = data;
+
+	WARN_ON_ONCE(preemptible());
+
+	err = sdei_api_event_unregister(arg->event->event_num);
+
+	sdei_cross_call_return(arg, err);
+}
+
 static int _sdei_event_unregister(struct sdei_event *event)
 {
 	lockdep_assert_held(&sdei_events_lock);
@@ -409,7 +497,7 @@ static int _sdei_event_unregister(struct sdei_event *event)
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		return sdei_api_event_unregister(event->event_num);
 
-	return -EINVAL;
+	return sdei_do_cross_call(_local_event_unregister, event);
 }
 
 int sdei_event_unregister(u32 event_num)
@@ -473,17 +561,50 @@ static int sdei_api_event_register(u32 event_num, unsigned long entry_point,
 			      flags, affinity, NULL);
 }
 
+/* Called directly by the hotplug callbacks */
+static void _local_event_register(void *data)
+{
+	int err;
+	struct sdei_registered_event *reg;
+	struct sdei_crosscall_args *arg = data;
+
+	WARN_ON(preemptible());
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
 	lockdep_assert_held(&sdei_events_lock);
 
+	spin_lock(&sdei_list_lock);
+	event->reregister = true;
+	spin_unlock(&sdei_list_lock);
+
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		return sdei_api_event_register(event->event_num,
 					       sdei_entry_point,
 					       event->registered,
 					       SDEI_EVENT_REGISTER_RM_ANY, 0);
 
-	return -EINVAL;
+
+	err = sdei_do_cross_call(_local_event_register, event);
+	if (err) {
+		spin_lock(&sdei_list_lock);
+		event->reregister = false;
+		event->reenable = false;
+		spin_unlock(&sdei_list_lock);
+
+		sdei_do_cross_call(_local_event_unregister, event);
+	}
+
+	return err;
 }
 
 int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg)
@@ -538,6 +659,8 @@ static int sdei_reregister_event(struct sdei_event *event)
 	if (event->reenable) {
 		if (event->type == SDEI_EVENT_TYPE_SHARED)
 			err = sdei_api_event_enable(event->event_num);
+		else
+			err = sdei_do_cross_call(_local_event_enable, event);
 	}
 
 	if (err)
@@ -569,6 +692,62 @@ static int sdei_reregister_shared(void)
 	return err;
 }
 
+static int sdei_cpuhp_down(unsigned int cpu)
+{
+	struct sdei_event *event;
+	struct sdei_crosscall_args arg;
+
+	/* un-register private events */
+	spin_lock(&sdei_list_lock);
+	list_for_each_entry(event, &sdei_list, list) {
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
+	spin_unlock(&sdei_list_lock);
+
+	return sdei_mask_local_cpu();
+}
+
+static int sdei_cpuhp_up(unsigned int cpu)
+{
+	struct sdei_event *event;
+	struct sdei_crosscall_args arg;
+
+	/* re-register/enable private events */
+	spin_lock(&sdei_list_lock);
+	list_for_each_entry(event, &sdei_list, list) {
+		if (event->type == SDEI_EVENT_TYPE_SHARED)
+			continue;
+
+		if (event->reregister) {
+			CROSSCALL_INIT(arg, event);
+			/* call the cross-call function locally... */
+			_local_event_register(&arg);
+			if (arg.first_error)
+				pr_err("Failed to re-register event %u: %d\n",
+				       event->event_num, arg.first_error);
+		}
+
+		if (event->reenable) {
+			CROSSCALL_INIT(arg, event);
+			_local_event_enable(&arg);
+			if (arg.first_error)
+				pr_err("Failed to re-enable event %u: %d\n",
+				       event->event_num, arg.first_error);
+		}
+	}
+	spin_unlock(&sdei_list_lock);
+
+	return sdei_unmask_local_cpu();
+}
+
 /* When entering idle, mask/unmask events for this cpu */
 static int sdei_pm_notifier(struct notifier_block *nb, unsigned long action,
 			    void *data)
@@ -621,6 +800,7 @@ static int sdei_device_freeze(struct device *dev)
 {
 	int err;
 
+	/* unregister private events */
 	cpuhp_remove_state(CPUHP_AP_ARM_SDEI_STARTING);
 
 	err = sdei_unregister_shared();
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
