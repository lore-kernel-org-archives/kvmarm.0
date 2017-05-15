From: James Morse <james.morse@arm.com>
Subject: [PATCH 07/11] firmware: arm_sdei: Add driver for Software Delegated
 Exceptions
Date: Mon, 15 May 2017 18:43:55 +0100
Message-ID: <20170515174400.29735-8-james.morse@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413D640948
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EC6-gq4glqpb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 13:42:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E5140C32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:48 -0400 (EDT)
In-Reply-To: <20170515174400.29735-1-james.morse@arm.com>
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
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The Software Delegated Exception Interface (SDEI) is an ARM standard
for registering callbacks from the platform firmware into the OS.
This is typically used to implement RAS notifications.

Add the code for detecting the SDEI version and the framework for
registering and unregistering events. Subsequent patches will add the
arch-specific backend code and the necessary power management hooks.

Currently only shared events are supported.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/firmware/Kconfig    |   7 +
 drivers/firmware/Makefile   |   1 +
 drivers/firmware/arm_sdei.c | 606 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sdei.h        |  98 +++++++
 include/uapi/linux/sdei.h   |  91 +++++++
 5 files changed, 803 insertions(+)
 create mode 100644 drivers/firmware/arm_sdei.c
 create mode 100644 include/linux/sdei.h
 create mode 100644 include/uapi/linux/sdei.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 6e4ed5a9c6fd..d8a9859f6102 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -48,6 +48,13 @@ config ARM_SCPI_POWER_DOMAIN
 	  This enables support for the SCPI power domains which can be
 	  enabled or disabled via the SCP firmware
 
+config ARM_SDE_INTERFACE
+	bool "ARM Software Delegated Exception Interface (SDEI)"
+	help
+	  The Software Delegated Exception Interface (SDEI) is an ARM
+	  standard for registering callbacks from the platform firmware
+	  into the OS. This is typically used to implement RAS notifications.
+
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
 	depends on X86
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index a37f12e8d137..229984feca4a 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_ARM_PSCI_FW)	+= psci.o
 obj-$(CONFIG_ARM_PSCI_CHECKER)	+= psci_checker.o
 obj-$(CONFIG_ARM_SCPI_PROTOCOL)	+= arm_scpi.o
 obj-$(CONFIG_ARM_SCPI_POWER_DOMAIN) += scpi_pm_domain.o
+obj-$(CONFIG_ARM_SDE_INTERFACE)	+= arm_sdei.o
 obj-$(CONFIG_DMI)		+= dmi_scan.o
 obj-$(CONFIG_DMI_SYSFS)		+= dmi-sysfs.o
 obj-$(CONFIG_EDD)		+= edd.o
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
new file mode 100644
index 000000000000..d22dda5e0fed
--- /dev/null
+++ b/drivers/firmware/arm_sdei.c
@@ -0,0 +1,606 @@
+/*
+ * Software Delegated Exception Interface (SDEI) driver code.
+ *
+ * Copyright (C) 2017 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "sdei: " fmt
+
+#include <linux/acpi.h>
+#include <linux/arm-smccc.h>
+#include <linux/bitops.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/hardirq.h>
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/percpu.h>
+#include <linux/platform_device.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <linux/sdei.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <uapi/linux/sdei.h>
+
+/*
+ * The call to use to reach the firmware.
+ */
+static asmlinkage void (*sdei_firmware_call)(unsigned long function_id,
+		      unsigned long arg0, unsigned long arg1,
+		      unsigned long arg2, unsigned long arg3,
+		      unsigned long arg4, struct arm_smccc_res *res);
+
+/* entry point from firmware to arch asm code */
+static void (*sdei_entry_point)(unsigned long, unsigned long);
+
+struct sdei_event {
+	struct list_head	list;
+	u32			event_num;
+	u64			type;
+	u64			priority;
+
+	/* This pointer is handed to firmware as the event argument. */
+	struct sdei_registered_event *registered;
+};
+
+static LIST_HEAD(sdei_events);
+static DEFINE_SPINLOCK(sdei_events_lock);
+
+static int sdei_to_linux_errno(unsigned long sdei_err)
+{
+	switch (sdei_err) {
+	case SDEI_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case SDEI_INVALID_PARAMETERS:
+		return -EINVAL;
+	case SDEI_DENIED:
+		return -EPERM;
+	case SDEI_PENDING:
+		return -EINPROGRESS;
+	case SDEI_OUT_OF_RESOURCE:
+		return -ENOMEM;
+	}
+
+	/* Not an error value ... */
+	return sdei_err;
+}
+
+/*
+ * If x0 is any of these values, then the call failed, use sdei_to_linux_errno()
+ * to translate.
+ */
+static int sdei_is_err(struct arm_smccc_res *res)
+{
+	switch (res->a0) {
+	case SDEI_NOT_SUPPORTED:
+	case SDEI_INVALID_PARAMETERS:
+	case SDEI_DENIED:
+	case SDEI_PENDING:
+	case SDEI_OUT_OF_RESOURCE:
+		return true;
+	}
+
+	return false;
+}
+
+static int invoke_sdei_fn(struct arm_smccc_res *res, unsigned long function_id,
+			  unsigned long arg0, unsigned long arg1,
+			  unsigned long arg2, unsigned long arg3,
+			  unsigned long arg4)
+{
+	int err = 0;
+
+	if (sdei_firmware_call) {
+		sdei_firmware_call(function_id, arg0, arg1, arg2, arg3, arg4, res);
+		if (sdei_is_err(res))
+			err = sdei_to_linux_errno(res->a0);
+	} else {
+		/*
+		 * !sdei_firmware_call means we failed to probe or called
+		 * sdei_mark_interface_broken(). -EIO is not an error returned
+		 * by sdei_to_linux_errno() and is used to suppress messages
+		 * from this driver.
+		 */
+		err = -EIO;
+		res->a0 = SDEI_NOT_SUPPORTED;
+	}
+
+	return err;
+}
+
+static struct sdei_event *sdei_event_find(u32 event_num)
+{
+	struct sdei_event *e, *found = NULL;
+
+	WARN_ON(!spin_is_locked(&sdei_events_lock));
+
+	list_for_each_entry(e, &sdei_events, list) {
+		if (e->event_num == event_num) {
+			found = e;
+			break;
+		}
+	}
+
+	return found;
+}
+
+int sdei_api_event_context(u32 query, u64 *result)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_CONTEXT, query, 0, 0,
+			     0, 0);
+	*result = res.a0;
+	return err;
+}
+
+static int sdei_api_event_get_info(u32 event, u32 info, u64 *result)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_GET_INFO, event, info,
+			     0, 0, 0);
+	*result = res.a0;
+	return err;
+}
+
+static struct sdei_event *sdei_event_create(u32 event_num,
+					    sdei_event_callback *cb,
+					    void *cb_arg)
+{
+	int err;
+	struct sdei_event *event;
+	struct sdei_registered_event *reg;
+
+	WARN_ON(!spin_is_locked(&sdei_events_lock));
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&event->list);
+	event->event_num = event_num;
+
+	err = sdei_api_event_get_info(event_num, SDEI_EVENT_INFO_EV_PRIORITY,
+					&event->priority);
+	if (err) {
+		kfree(event);
+		return ERR_PTR(err);
+	}
+
+	err = sdei_api_event_get_info(event_num, SDEI_EVENT_INFO_EV_TYPE,
+					&event->type);
+	if (err) {
+		kfree(event);
+		return ERR_PTR(err);
+	}
+
+	if (event->type == SDEI_EVENT_TYPE_SHARED) {
+		reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+		if (!reg) {
+			kfree(event);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		reg->event_num = event_num;
+
+		reg->callback = cb;
+		reg->callback_arg = cb_arg;
+		event->registered = reg;
+	}
+
+	if (sdei_event_find(event_num)) {
+		kfree(event->registered);
+		kfree(event);
+		event = ERR_PTR(-EBUSY);
+	} else {
+		list_add(&event->list, &sdei_events);
+	}
+
+	return event;
+}
+
+static void sdei_event_destroy(struct sdei_event *event)
+{
+	WARN_ON(!spin_is_locked(&sdei_events_lock));
+
+	list_del(&event->list);
+
+	if (event->type == SDEI_EVENT_TYPE_SHARED)
+		kfree(event->registered);
+
+	kfree(event);
+}
+
+static int sdei_api_get_version(u64 *version)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_VERSION, 0, 0, 0, 0, 0);
+	if (err)
+		return err;
+
+	*version = res.a0;
+	return 0;
+}
+
+int sdei_mask_local_cpu(unsigned int cpu)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	WARN_ON(preemptible());
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_PE_MASK, 0, 0, 0, 0, 0);
+
+	if (err && err != -EIO) {
+		pr_warn_once("failed to mask CPU[%u]: %d\n",
+			      smp_processor_id(), err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void _ipi_mask_cpu(void *ignored)
+{
+	sdei_mask_local_cpu(smp_processor_id());
+}
+
+int sdei_unmask_local_cpu(unsigned int ignored)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	WARN_ON(preemptible());
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_PE_UNMASK, 0, 0, 0, 0, 0);
+
+	if (err && err != -EIO) {
+		pr_warn_once("failed to unmask CPU[%u]: %d\n",
+			     smp_processor_id(), err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void _ipi_unmask_cpu(void *ignored)
+{
+	sdei_unmask_local_cpu(smp_processor_id());
+}
+
+static void _ipi_private_reset(void *ignored)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_PRIVATE_RESET, 0, 0, 0, 0,
+			     0);
+
+	if (err && err != -EIO)
+		pr_warn_once("failed to reset CPU[%u]: %d\n",
+			     smp_processor_id(), err);
+}
+
+static int sdei_api_shared_reset(void)
+{
+	struct arm_smccc_res res;
+
+	return invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_SHARED_RESET, 0, 0, 0, 0,
+			      0);
+}
+
+static void sdei_mark_interface_broken(void)
+{
+	pr_err("disabling SDEI firmware interface\n");
+	on_each_cpu(&_ipi_mask_cpu, NULL, true);
+	sdei_firmware_call = NULL;
+}
+
+static int sdei_platform_reset(void)
+{
+	int err;
+
+	on_each_cpu(&_ipi_private_reset, NULL, true);
+	err = sdei_api_shared_reset();
+	if (err) {
+		pr_err("Failed to reset platform: %d\n", err);
+		sdei_mark_interface_broken();
+	}
+
+	return err;
+}
+
+static int sdei_api_event_enable(u32 event_num)
+{
+	struct arm_smccc_res res;
+
+	return invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_ENABLE, event_num, 0,
+			      0, 0, 0);
+}
+
+int sdei_event_enable(u32 event_num)
+{
+	int err = -EINVAL;
+	struct sdei_event *event;
+
+	spin_lock(&sdei_events_lock);
+	event = sdei_event_find(event_num);
+	if (!event)
+		err = -ENOENT;
+	else if (event->type == SDEI_EVENT_TYPE_SHARED)
+		err = sdei_api_event_enable(event->event_num);
+	spin_unlock(&sdei_events_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(sdei_event_enable);
+
+static int sdei_api_event_disable(u32 event_num)
+{
+	int err;
+	struct arm_smccc_res res;
+
+	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_DISABLE, event_num, 0,
+				0, 0, 0);
+
+	return err;
+}
+
+int sdei_event_disable(u32 event_num)
+{
+	int err = -EINVAL;
+	struct sdei_event *event;
+
+	spin_lock(&sdei_events_lock);
+	event = sdei_event_find(event_num);
+	if (!event)
+		err = -ENOENT;
+	else if (event->type == SDEI_EVENT_TYPE_SHARED)
+		err = sdei_api_event_disable(event->event_num);
+	spin_unlock(&sdei_events_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(sdei_event_disable);
+
+static int sdei_api_event_unregister(u32 event_num)
+{
+	struct arm_smccc_res res;
+
+	return invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_UNREGISTER,
+			      event_num, 0, 0, 0, 0);
+}
+
+static int _sdei_event_unregister(struct sdei_event *event)
+{
+	if (event->type == SDEI_EVENT_TYPE_SHARED)
+		return sdei_api_event_unregister(event->event_num);
+
+	return -EINVAL;
+}
+
+int sdei_event_unregister(u32 event_num)
+{
+	int err;
+	struct sdei_event *event;
+
+	WARN_ON(in_nmi());
+
+	spin_lock(&sdei_events_lock);
+	event = sdei_event_find(event_num);
+	do {
+		if (!event) {
+			pr_err("Event %u not registered\n", event_num);
+			err = -ENOENT;
+			break;
+		}
+
+		err = _sdei_event_unregister(event);
+		if (err)
+			break;
+
+		sdei_event_destroy(event);
+	} while (0);
+	spin_unlock(&sdei_events_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(sdei_event_unregister);
+
+static int sdei_api_event_register(u32 event_num, void *entry_point, void *arg,
+			       u64 flags, u64 affinity)
+{
+	struct arm_smccc_res res;
+
+	return invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_EVENT_REGISTER, event_num,
+			      (unsigned long)entry_point, (unsigned long)arg,
+			      flags, affinity);
+}
+
+static int _sdei_event_register(struct sdei_event *event)
+{
+	if (event->type == SDEI_EVENT_TYPE_SHARED)
+		return sdei_api_event_register(event->event_num,
+					       sdei_entry_point,
+					       event->registered,
+					       SDEI_EVENT_REGISTER_RM_ANY, 0);
+
+	return -EINVAL;
+}
+
+int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg)
+{
+	int err;
+	struct sdei_event *event;
+
+	WARN_ON(in_nmi());
+
+	spin_lock(&sdei_events_lock);
+	do {
+		if (sdei_event_find(event_num)) {
+			pr_err("Event %u already registered\n", event_num);
+			err = -EBUSY;
+			break;
+		}
+
+		event = sdei_event_create(event_num, cb, arg);
+		if (IS_ERR(event)) {
+			err = PTR_ERR(event);
+			pr_err("Failed to create event %u: %d\n", event_num, err);
+			break;
+		}
+
+		err = _sdei_event_register(event);
+		if (err) {
+			sdei_event_destroy(event);
+			pr_err("Failed to register event %u: %d\n", event_num, err);
+		}
+	} while (0);
+	spin_unlock(&sdei_events_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(sdei_event_register);
+
+static void sdei_smccc_smc(unsigned long function_id,
+			   unsigned long arg0, unsigned long arg1,
+			   unsigned long arg2, unsigned long arg3,
+			   unsigned long arg4, struct arm_smccc_res *res)
+{
+	arm_smccc_smc(function_id, arg0, arg1, arg2, arg3, arg4, 0, 0, res);
+}
+
+static void sdei_smccc_hvc(unsigned long function_id,
+			   unsigned long arg0, unsigned long arg1,
+			   unsigned long arg2, unsigned long arg3,
+			   unsigned long arg4, struct arm_smccc_res *res)
+{
+	arm_smccc_hvc(function_id, arg0, arg1, arg2, arg3, arg4, 0, 0, res);
+}
+
+static int sdei_get_conduit(struct platform_device *pdev)
+{
+	const char *method;
+	struct device_node *np = pdev->dev.of_node;
+
+	sdei_firmware_call = NULL;
+	if (np) {
+		if (of_property_read_string(np, "method", &method)) {
+			pr_warn("missing \"method\" property\n");
+			return CONDUIT_INVALID;
+		}
+
+		if (!strcmp("hvc", method)) {
+			sdei_firmware_call = &sdei_smccc_hvc;
+			return CONDUIT_HVC;
+		} else if (!strcmp("smc", method)) {
+			sdei_firmware_call = &sdei_smccc_smc;
+			return CONDUIT_SMC;
+		}
+
+		pr_warn("invalid \"method\" property: %s\n", method);
+	}
+
+	return CONDUIT_INVALID;
+}
+
+static int sdei_probe(struct platform_device *pdev)
+{
+	int err;
+	u64 ver = 0;
+	int conduit;
+
+	conduit = sdei_get_conduit(pdev);
+	if (!sdei_firmware_call)
+		return 0;
+
+	err = sdei_api_get_version(&ver);
+	if (err == -EOPNOTSUPP)
+		pr_err("No SDEI implementation in platform firmware\n");
+	if (err) {
+		pr_err("Failed to get SDEI version: %d\n", err);
+		sdei_mark_interface_broken();
+		return err;
+	}
+
+	pr_info("SDEIv%d.%d (0x%x) detected in firmware.\n",
+		(int)SDEI_VERSION_MAJOR(ver), (int)SDEI_VERSION_MINOR(ver),
+		(int)SDEI_VERSION_VENDOR(ver));
+
+	if (SDEI_VERSION_MAJOR(ver) != 1) {
+		pr_err("Conflicting SDEI version detected.\n");
+		sdei_mark_interface_broken();
+		return -EINVAL;
+	}
+
+	err = sdei_platform_reset();
+	if (err)
+		return err;
+
+	sdei_entry_point = sdei_arch_get_entry_point(conduit);
+	if (!sdei_entry_point) {
+		/* Not supported due to hardware or boot configuration */
+		sdei_mark_interface_broken();
+		return 0;
+	}
+
+	on_each_cpu(&_ipi_unmask_cpu, NULL, false);
+
+	return 0;
+}
+
+static const struct of_device_id sdei_of_match[] = {
+	{ .compatible = "arm,sdei-1.0" },
+	{}
+};
+
+static struct platform_driver sdei_driver = {
+	.driver		= {
+		.name			= "sdei",
+		.of_match_table		= sdei_of_match,
+	},
+	.probe		= sdei_probe,
+};
+builtin_platform_driver(sdei_driver);
+
+int sdei_event_handler(struct pt_regs *regs,
+			       struct sdei_registered_event *arg)
+{
+	int err;
+	mm_segment_t orig_addr_limit;
+	u32 event_num = arg->event_num;
+
+	orig_addr_limit = get_fs();
+	set_fs(USER_DS);
+
+	err = arg->callback(event_num, regs, arg->callback_arg);
+	if (err)
+		pr_err("event %u on CPU %u failed with error: %d\n", event_num,
+		       smp_processor_id(), err);
+
+	set_fs(orig_addr_limit);
+
+	return err;
+}
+NOKPROBE_SYMBOL(sdei_event_handler);
diff --git a/include/linux/sdei.h b/include/linux/sdei.h
new file mode 100644
index 000000000000..504e8bf8bc07
--- /dev/null
+++ b/include/linux/sdei.h
@@ -0,0 +1,98 @@
+/*
+ * Software Delegated Exception Interface (SDEI) API
+ *
+ * Copyright (C) 2017 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LINUX_SDEI_H
+#define __LINUX_SDEI_H
+
+enum sdei_conduit_types {
+	CONDUIT_INVALID = 0,
+	CONDUIT_SMC,
+	CONDUIT_HVC,
+};
+
+#include <uapi/linux/sdei.h>
+
+/* Arch code should override this to set the entry point from firmware... */
+#ifndef sdei_arch_get_entry_point
+#define sdei_arch_get_entry_point(conduit)	(NULL)
+#endif
+
+/*
+ * When an event occurs sdei_event_handler() will call a user-provided callback
+ * like this in NMI context on the CPU that received the event.
+ */
+typedef int (sdei_event_callback)(u32 event, struct pt_regs *regs, void *arg);
+
+/*
+ * Register your callback to claim an event. The event must be described
+ * by firmware.
+ */
+int sdei_event_register(u32 event_num, sdei_event_callback *cb, void *arg);
+
+/*
+ * Calls to sdei_event_unregister() may return EINPROGRESS. Keep calling
+ * it until it succeeds.
+ */
+int sdei_event_unregister(u32 event_num);
+
+int sdei_event_enable(u32 event_num);
+int sdei_event_disable(u32 event_num);
+
+#ifdef CONFIG_ARM_SDE_INTERFACE
+/* For use by arch code when CPU hotplug notifiers are not appropriate. */
+int sdei_mask_local_cpu(unsigned int cpu);
+int sdei_unmask_local_cpu(unsigned int cpu);
+
+/* kvm needs to know if hvcs are for SDEI or PSCI */
+#define IS_SDEI_CALL(x)		((x & SDEI_1_0_MASK) == SDEI_1_0_FN_BASE)
+
+#else
+static inline int sdei_mask_local_cpu(unsigned int ignored) { return 0; }
+static inline int sdei_unmask_local_cpu(unsigned int ignored) { return 0; }
+
+#define IS_SDEI_CALL(x)		0
+#endif /* CONFIG_ARM_SDE_INTERFACE */
+
+
+
+/*
+ * This struct represents an event that has been registered. The driver
+ * maintains a list of all events, and which ones are registered. A pointer to
+ * this struct is passed to firmware, and back to the event handler. The event
+ * handler can then use this to invoke the registered callback, without having
+ * to walk the list.
+ *
+ * For CPU private events, this structure is per-cpu.
+ */
+struct sdei_registered_event {
+	/* For use by arch code: */
+	struct pt_regs          interrupted_regs;
+
+	sdei_event_callback	*callback;
+	void			*callback_arg;
+	u32			 event_num;
+};
+
+/* The arch code entry point should then call this when an event arrives. */
+int notrace sdei_event_handler(struct pt_regs *regs,
+			       struct sdei_registered_event *arg);
+
+/* arch code may use this to retrieve the extra registers. */
+int sdei_api_event_context(u32 query, u64 *result);
+
+#endif /* __LINUX_SDEI_H */
diff --git a/include/uapi/linux/sdei.h b/include/uapi/linux/sdei.h
new file mode 100644
index 000000000000..535c9d8d14cc
--- /dev/null
+++ b/include/uapi/linux/sdei.h
@@ -0,0 +1,91 @@
+/*
+ *Software Delegated Exception Interface (SDEI) Firmware API
+ *
+ * This header holds common SDEI defines and macros shared
+ * by: ARM64 kernel, KVM and user space.
+ *
+ * Copyright (C) 2017 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef _UAPI_LINUX_SDEI_H
+#define _UAPI_LINUX_SDEI_H
+
+#define SDEI_1_0_FN_BASE			0xC4000020
+#define SDEI_1_0_MASK				0xFFFFFFE0
+#define SDEI_1_0_FN(n)				(SDEI_1_0_FN_BASE + (n))
+
+#define SDEI_1_0_FN_SDEI_VERSION			SDEI_1_0_FN(0x00)
+#define SDEI_1_0_FN_SDEI_EVENT_REGISTER			SDEI_1_0_FN(0x01)
+#define SDEI_1_0_FN_SDEI_EVENT_ENABLE			SDEI_1_0_FN(0x02)
+#define SDEI_1_0_FN_SDEI_EVENT_DISABLE			SDEI_1_0_FN(0x03)
+#define SDEI_1_0_FN_SDEI_EVENT_CONTEXT			SDEI_1_0_FN(0x04)
+#define SDEI_1_0_FN_SDEI_EVENT_COMPLETE			SDEI_1_0_FN(0x05)
+#define SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME	SDEI_1_0_FN(0x06)
+#define SDEI_1_0_FN_SDEI_EVENT_UNREGISTER		SDEI_1_0_FN(0x07)
+#define SDEI_1_0_FN_SDEI_EVENT_STATUS			SDEI_1_0_FN(0x08)
+#define SDEI_1_0_FN_SDEI_EVENT_GET_INFO			SDEI_1_0_FN(0x09)
+#define SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET		SDEI_1_0_FN(0x0A)
+#define SDEI_1_0_FN_SDEI_PE_MASK			SDEI_1_0_FN(0x0B)
+#define SDEI_1_0_FN_SDEI_PE_UNMASK			SDEI_1_0_FN(0x0C)
+#define SDEI_1_0_FN_SDEI_INTERRUPT_BIND			SDEI_1_0_FN(0x0D)
+#define SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE		SDEI_1_0_FN(0x0E)
+#define SDEI_1_0_FN_SDEI_PRIVATE_RESET			SDEI_1_0_FN(0x11)
+#define SDEI_1_0_FN_SDEI_SHARED_RESET			SDEI_1_0_FN(0x12)
+
+#define SDEI_VERSION_MAJOR_SHIFT			48
+#define SDEI_VERSION_MAJOR_MASK				0x7fff
+#define SDEI_VERSION_MINOR_SHIFT			32
+#define SDEI_VERSION_MINOR_MASK				0xffff
+#define SDEI_VERSION_VENDOR_SHIFT			0
+#define SDEI_VERSION_VENDOR_MASK			0xffffffff
+
+#define SDEI_VERSION_MAJOR(x)	(x>>SDEI_VERSION_MAJOR_SHIFT & SDEI_VERSION_MAJOR_MASK)
+#define SDEI_VERSION_MINOR(x)	(x>>SDEI_VERSION_MINOR_SHIFT & SDEI_VERSION_MINOR_MASK)
+#define SDEI_VERSION_VENDOR(x)	(x>>SDEI_VERSION_VENDOR_SHIFT & SDEI_VERSION_VENDOR_MASK)
+
+/* SDEI return values */
+#define SDEI_SUCCESS		0
+#define SDEI_NOT_SUPPORTED	-1
+#define SDEI_INVALID_PARAMETERS	-2
+#define SDEI_DENIED		-3
+#define SDEI_PENDING		-5
+#define SDEI_OUT_OF_RESOURCE	-10
+
+/* EVENT_REGISTER flags */
+#define SDEI_EVENT_REGISTER_RM_ANY	0
+#define SDEI_EVENT_REGISTER_RM_PE	1
+
+/* EVENT_STATUS return value bits */
+#define SDEI_EVENT_STATUS_RUNNING	2
+#define SDEI_EVENT_STATUS_ENABLED	1
+#define SDEI_EVENT_STATUS_REGISTERED	0
+
+/* EVENT_COMPLETE status values */
+#define SDEI_EV_HANDLED	0
+#define SDEI_EV_FAILED	1
+
+/* GET_INFO values */
+#define SDEI_EVENT_INFO_EV_TYPE			0
+#define SDEI_EVENT_INFO_EV_SIGNALED		1
+#define SDEI_EVENT_INFO_EV_PRIORITY		2
+#define SDEI_EVENT_INFO_EV_ROUTING_MODE		3
+#define SDEI_EVENT_INFO_EV_ROUTING_AFF		4
+
+/* and their results */
+#define SDEI_EVENT_TYPE_PRIVATE			0
+#define SDEI_EVENT_TYPE_SHARED			1
+#define SDEI_EVENT_PRIORITY_NORMAL		0
+#define SDEI_EVENT_PRIORITY_CRITICAL		1
+
+#endif /* _UAPI_LINUX_SDEI_H */
-- 
2.10.1
