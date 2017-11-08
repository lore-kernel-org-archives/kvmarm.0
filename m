From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v4 15/13] firmware: arm_sdei: be more robust against cpu-hotplug
Date: Wed,  8 Nov 2017 16:06:24 +0000
Message-ID: <20171108160624.10355-1-james.morse@arm.com>
References: <5A031E9E.2090809@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5A031E9E.2090809-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

dpm_suspend() calls the freeze/thaw callbacks for hibernate before
disable_non_bootcpus() takes down secondaries.

This leads to a fun race where the freeze/thaw callbacks reset the
SDEI interface (as we may be restoring a kernel with a different
layout due to KASLR), then the cpu-hotplug callbacks come in to
save the current state, which has already been reset.

I tried to solve this with a 'frozen' flag that stops the hotplug
callback from overwriting the saved values. Instead this just
moves the race around and makes it even harder to think about.

Instead, make it look like the secondaries have gone offline.
Call cpuhp_remove_state() in the freeze callback, this will call the
teardown hook on all online CPUs, then remove the state. This saves
all private events and makes future CPU up/down events invisible.

Change sdei_event_unregister_all()/sdei_reregister_events() to
only save/restore shared events, which are all that is left. With
this we can remove the frozen flag. We can remove the device
suspend/resume calls too as cpuhotplug's teardown call has masked
the CPUs.

All that is left is the reboot notifier, (which was abusing the
frozen flag). Call cpuhp_remove_state() to make it look like
secondary CPUs have gone offline.

Suggested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 drivers/firmware/arm_sdei.c | 60 +++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 65a8f122f545..d50634a25954 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -86,9 +86,6 @@ struct sdei_event {
 static LIST_HEAD(sdei_events);
 static DEFINE_SPINLOCK(sdei_events_lock);
 
-/* When frozen, cpu-hotplug notifiers shouldn't unregister/re-register events */
-static bool frozen;
-
 static DEFINE_PER_CPU(u64, sdei_running_event) = -1;
 
 /* Private events are registered/enabled via IPI passing one of these */
@@ -625,15 +622,18 @@ EXPORT_SYMBOL(sdei_event_unregister);
 
 /*
  * unregister events, but don't destroy them as they are re-registered by
- * sdei_reregister_events().
+ * sdei_reregister_shared().
  */
-static int sdei_event_unregister_all(void)
+static int sdei_unregister_shared(void)
 {
 	int err = 0;
 	struct sdei_event *event;
 
 	spin_lock(&sdei_events_lock);
 	list_for_each_entry(event, &sdei_events, list) {
+		if (event->type != SDEI_EVENT_TYPE_SHARED)
+			continue;
+
 		err = _sdei_event_unregister(event);
 		if (err)
 			break;
@@ -841,13 +841,16 @@ static int sdei_reregister_event(struct sdei_event *event)
 	return err;
 }
 
-static int sdei_reregister_events(void)
+static int sdei_reregister_shared(void)
 {
 	int err = 0;
 	struct sdei_event *event;
 
 	spin_lock(&sdei_events_lock);
 	list_for_each_entry(event, &sdei_events, list) {
+		if (event->type != SDEI_EVENT_TYPE_SHARED)
+			continue;
+
 		err = sdei_reregister_event(event);
 		if (err)
 			break;
@@ -862,11 +865,6 @@ static int sdei_cpuhp_down(unsigned int cpu)
 	struct sdei_event *event;
 	struct sdei_crosscall_args arg;
 
-	if (frozen) {
-		/* All events unregistered  */
-		return sdei_mask_local_cpu();
-	}
-
 	/* un-register private events */
 	spin_lock(&sdei_events_lock);
 	list_for_each_entry(event, &sdei_events, list) {
@@ -890,11 +888,6 @@ static int sdei_cpuhp_up(unsigned int cpu)
 	struct sdei_event *event;
 	struct sdei_crosscall_args arg;
 
-	if (frozen) {
-		/* Events will be re-registered when we thaw. */
-		return sdei_unmask_local_cpu();
-	}
-
 	/* re-register/enable private events */
 	spin_lock(&sdei_events_lock);
 	list_for_each_entry(event, &sdei_events, list) {
@@ -1004,22 +997,33 @@ static int sdei_device_freeze(struct device *dev)
 {
 	int err;
 
-	frozen = true;
-	err = sdei_event_unregister_all();
+	/* save and unregister private events */
+	cpuhp_remove_state(CPUHP_AP_ARM_SDEI_STARTING);
+
+	err = sdei_unregister_shared();
 	if (err)
 		return err;
 
-	return sdei_device_suspend(dev);
+	return 0;
 }
 
 static int sdei_device_thaw(struct device *dev)
 {
 	int err;
 
-	sdei_device_resume(dev);
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
 
-	err = sdei_reregister_events();
-	frozen = false;
 	return err;
 }
 
@@ -1048,15 +1052,13 @@ static const struct dev_pm_ops sdei_pm_ops = {
 static int sdei_reboot_notifier(struct notifier_block *nb, unsigned long action,
 				void *data)
 {
-	on_each_cpu(&_ipi_mask_cpu, NULL, true);
-
-	sdei_platform_reset();
-
 	/*
-	 * There is now no point trying to unregister private events if we go on
-	 * to take CPUs offline.
+	 * We are going to reset the interface, after this there is no point
+	 * doing work when we take CPUs offline.
 	 */
-	frozen = true;
+	cpuhp_remove_state(CPUHP_AP_ARM_SDEI_STARTING);
+
+	sdei_platform_reset();
 
 	return NOTIFY_OK;
 }
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
