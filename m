From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 11/13] firmware: arm_sdei: add support for CPU private
 events
Date: Tue, 17 Oct 2017 18:44:30 +0100
Message-ID: <20171017174432.1684-12-james.morse@arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC27406BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 13:45:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VeGl0WCY21oF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 13:45:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3261B49D34
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 13:45:52 -0400 (EDT)
In-Reply-To: <20171017174432.1684-1-james.morse@arm.com>
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
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Private SDE events are per-cpu, and need to be registered and enabled
on each CPU.

Hide this detail from the caller by adapting our {,un}register and
{en,dis}able calls to send an IPI to each CPU if the event is private.

CPU private events are unregistered when the CPU is powered-off, and
re-registered when the CPU is brought back online. This saves bringing
secondary cores back online to call private_reset() on shutdown, kexec
and resume from hibernate.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/firmware/arm_sdei.c | 242 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 228 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 28e4c4cbb16d..5598d9ba8b5d 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -21,9 +21,11 @@
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
@@ -64,12 +66,49 @@ struct sdei_event {
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
@@ -213,6 +252,26 @@ static struct sdei_event *sdei_event_create(u32 event_num,
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
@@ -234,6 +293,8 @@ static void sdei_event_destroy(struct sdei_event *event)
 
 	if (event->type == SDEI_EVENT_TYPE_SHARED)
 		kfree(event->registered);
+	else
+		free_percpu(event->private_registered);
 
 	kfree(event);
 }
@@ -264,11 +325,6 @@ static void _ipi_mask_cpu(void *ignored)
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
@@ -290,11 +346,6 @@ static void _ipi_unmask_cpu(void *ignored)
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
@@ -345,6 +396,16 @@ static int sdei_api_event_enable(u32 event_num)
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
@@ -356,6 +417,8 @@ int sdei_event_enable(u32 event_num)
 		err = -ENOENT;
 	else if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_enable(event->event_num);
+	else
+		err = sdei_do_cross_call(_ipi_event_enable, event);
 	spin_unlock(&sdei_events_lock);
 
 	return err;
@@ -368,6 +431,16 @@ static int sdei_api_event_disable(u32 event_num)
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
@@ -379,6 +452,9 @@ int sdei_event_disable(u32 event_num)
 		err = -ENOENT;
 	else if (event->type == SDEI_EVENT_TYPE_SHARED)
 		err = sdei_api_event_disable(event->event_num);
+	else
+		err = sdei_do_cross_call(_ipi_event_disable, event);
+
 	spin_unlock(&sdei_events_lock);
 
 	return err;
@@ -391,6 +467,27 @@ static int sdei_api_event_unregister(u32 event_num)
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
@@ -411,7 +508,7 @@ static int _sdei_event_unregister(struct sdei_event *event)
 		return sdei_api_event_unregister(event->event_num);
 	}
 
-	return -EINVAL;
+	return sdei_do_cross_call(_local_event_unregister, event);
 }
 
 int sdei_event_unregister(u32 event_num)
@@ -470,15 +567,41 @@ static int sdei_api_event_register(u32 event_num, unsigned long entry_point,
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
@@ -518,6 +641,22 @@ int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg,
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
@@ -534,6 +673,8 @@ static int sdei_reregister_event(struct sdei_event *event)
 	if (event->type == SDEI_EVENT_TYPE_SHARED) {
 		if (event->registered->was_enabled)
 			err = sdei_api_event_enable(event->event_num);
+	} else {
+		err = sdei_do_cross_call(_local_event_reenable, event);
 	}
 
 	if (err)
@@ -558,6 +699,68 @@ static int sdei_reregister_events(void)
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
@@ -610,6 +813,7 @@ static int sdei_device_freeze(struct device *dev)
 {
 	int err;
 
+	frozen = true;
 	err = sdei_event_unregister_all();
 	if (err)
 		return err;
@@ -619,9 +823,13 @@ static int sdei_device_freeze(struct device *dev)
 
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
@@ -653,6 +861,12 @@ static int sdei_reboot_notifier(struct notifier_block *nb, unsigned long action,
 
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
