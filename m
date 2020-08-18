Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC37C433E1
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:14:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52886206DA
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C990IxV3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52886206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B42D4BD76;
	Mon, 17 Aug 2020 21:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4HzOsAFpLPkx; Mon, 17 Aug 2020 21:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4FB4C294;
	Mon, 17 Aug 2020 21:13:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7398B4C28B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kqjVvK0PtoSo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 21:13:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A654BD76
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597713234;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XzMYIizDVwTl95pVZ8zFV4nRu533OyDhFb/bW/8rJGQ=;
 b=C990IxV3hGi/hsUR5vh7IUzYM1zeUDH64wyDzTYzGVZp1+5OWCia58VkZjODIdbkK0NNJw
 /SOovr65sdv4CqqPKm50TSQVz+ElmBHDzSxVtNLYARfgKu0cLWIAMfipQtt56xIWCq7f8z
 FnW7KQ2aSWtf975WpcVBab8kdS9GR18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-dFYf1vOKMMStURGGFKkHBg-1; Mon, 17 Aug 2020 21:13:50 -0400
X-MC-Unique: dFYf1vOKMMStURGGFKkHBg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CE381084C90;
 Tue, 18 Aug 2020 01:13:49 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1F8D85D9D2;
 Tue, 18 Aug 2020 01:13:45 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 6/6] arm64/kernel: Support async page fault
Date: Tue, 18 Aug 2020 11:13:19 +1000
Message-Id: <20200818011319.91777-7-gshan@redhat.com>
In-Reply-To: <20200818011319.91777-1-gshan@redhat.com>
References: <20200818011319.91777-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This supports the asynchronous page fault, basing on the services
provided by host. The asynchronous page fault starts with private
SDEI event, whose number is specified by the guest. The guest marks
the current running process as suspended state by the newly added
flag (TIF_ASYNC_PF) and associating it with a wait queue. In the
mean while, the process is put into the pre-allocated table, whose
index is indeitified by the associated token. In the SDEI event
handler, a followup (reschedule) IPI is sent to current CPU to
force context switching on current running process. During the
context switching, the flag (TIF_ASYNC_PF) is checked and the
process waits on the associated wait queue.

The guest receives a PPI, whose number is specified by it, after
the page becomes ready on host side. The pre-allocated table is
searched using the received token to locate the associated process.
The process is waken up after it's found. The previously suspended
process resumes for execution and the asynchronous page fault is
completed so far.

The implementation is guarded by CONFIG_KVM_GUEST. Also, the boot
parameter "no-kvmapf" can be used to disable this feature. Besides,
this feature has to be enabled after SDEI service is settled down
because this depends on SDEI service.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/Kconfig                   |  11 +
 arch/arm64/include/asm/kvm_para.h    |  26 +-
 arch/arm64/include/asm/processor.h   |   1 +
 arch/arm64/include/asm/thread_info.h |   4 +-
 arch/arm64/kernel/Makefile           |   1 +
 arch/arm64/kernel/kvm.c              | 478 +++++++++++++++++++++++++++
 arch/arm64/kernel/signal.c           |  17 +
 7 files changed, 531 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/kernel/kvm.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e11b4ea06127..5543c0d8159e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1053,6 +1053,17 @@ config PARAVIRT
 	  under a hypervisor, potentially improving performance significantly
 	  over full virtualization.
 
+config KVM_GUEST
+	bool "KVM Guest Support"
+	depends on PARAVIRT
+	default y
+	help
+	  This option enables various optimizations for running under the KVM
+	  hypervisor. Overhead for the kernel when not running inside KVM should
+	  be minimal.
+
+	  In case of doubt, say Y
+
 config PARAVIRT_TIME_ACCOUNTING
 	bool "Paravirtual steal time accounting"
 	select PARAVIRT
diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
index 0ea481dd1c7a..1f038652cdcd 100644
--- a/arch/arm64/include/asm/kvm_para.h
+++ b/arch/arm64/include/asm/kvm_para.h
@@ -3,6 +3,20 @@
 #define _ASM_ARM_KVM_PARA_H
 
 #include <uapi/asm/kvm_para.h>
+#include <linux/of.h>
+#include <asm/hypervisor.h>
+
+#ifdef CONFIG_KVM_GUEST
+static inline int kvm_para_available(void)
+{
+	return 1;
+}
+#else
+static inline int kvm_para_available(void)
+{
+	return 0;
+}
+#endif /* CONFIG_KVM_GUEST */
 
 static inline bool kvm_check_and_clear_guest_paused(void)
 {
@@ -11,7 +25,12 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 
 static inline unsigned int kvm_arch_para_features(void)
 {
-	return 0;
+	unsigned int features = 0;
+
+	if (kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_APF))
+		features |= (1 << KVM_FEATURE_ASYNC_PF);
+
+	return features;
 }
 
 static inline unsigned int kvm_arch_para_hints(void)
@@ -19,9 +38,4 @@ static inline unsigned int kvm_arch_para_hints(void)
 	return 0;
 }
 
-static inline bool kvm_para_available(void)
-{
-	return false;
-}
-
 #endif /* _ASM_ARM_KVM_PARA_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 240fe5e5b720..afd2e04cac3d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -151,6 +151,7 @@ struct thread_struct {
 	struct ptrauth_keys_user	keys_user;
 	struct ptrauth_keys_kernel	keys_kernel;
 #endif
+	void				*data;
 };
 
 static inline void arch_thread_struct_whitelist(unsigned long *offset,
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 5e784e16ee89..5605dc9d2bd3 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -67,6 +67,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_FSCHECK		5	/* Check FS is USER_DS on return */
+#define TIF_ASYNC_PF		6	/* Asynchronous page fault */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -86,6 +87,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_FOREIGN_FPSTATE	(1 << TIF_FOREIGN_FPSTATE)
+#define _TIF_ASYNC_PF		(1 << TIF_ASYNC_PF)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
@@ -99,7 +101,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
-				 _TIF_UPROBE | _TIF_FSCHECK)
+				 _TIF_UPROBE | _TIF_FSCHECK | _TIF_ASYNC_PF)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index a561cbb91d4d..76472934689b 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_ACPI)			+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)			+= acpi_numa.o
 obj-$(CONFIG_ARM64_ACPI_PARKING_PROTOCOL)	+= acpi_parking_protocol.o
 obj-$(CONFIG_PARAVIRT)			+= paravirt.o
+obj-$(CONFIG_KVM_GUEST)			+= kvm.o
 obj-$(CONFIG_RANDOMIZE_BASE)		+= kaslr.o
 obj-$(CONFIG_HIBERNATION)		+= hibernate.o hibernate-asm.o
 obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
diff --git a/arch/arm64/kernel/kvm.c b/arch/arm64/kernel/kvm.c
new file mode 100644
index 000000000000..d47eed4cff1e
--- /dev/null
+++ b/arch/arm64/kernel/kvm.c
@@ -0,0 +1,478 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright Gavin Shan, Redhat Inc 2020.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/arm-smccc.h>
+#include <linux/kvm_para.h>
+#include <linux/arm_sdei.h>
+#include <linux/acpi.h>
+#include <linux/cpuhotplug.h>
+#include <linux/reboot.h>
+
+struct kvm_apf_task {
+	unsigned int		token;
+	struct task_struct	*task;
+	struct swait_queue_head	wq;
+};
+
+struct kvm_apf_table {
+	raw_spinlock_t		lock;
+	unsigned int		count;
+	struct kvm_apf_task	tasks[0];
+};
+
+static bool async_pf_available = true;
+static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_data) __aligned(64);
+static struct kvm_apf_table __percpu *apf_tables;
+static unsigned int apf_tasks;
+static unsigned int apf_sdei_num;
+static unsigned int apf_ppi_num;
+static unsigned int apf_ppi_mode;
+static unsigned int apf_ppi_polarity;
+static struct sdei_event *apf_sdei_event;
+static int apf_irq;
+
+static bool kvm_async_pf_add_task(struct task_struct *task,
+				  unsigned int token)
+{
+	struct kvm_apf_table *table = this_cpu_ptr(apf_tables);
+	unsigned int i, index = apf_tasks;
+	bool ret = false;
+
+	raw_spin_lock(&table->lock);
+
+	if (WARN_ON(table->count >= apf_tasks))
+		goto unlock;
+
+	for (i = 0; i < apf_tasks; i++) {
+		if (!table->tasks[i].task) {
+			if (index == apf_tasks) {
+				ret = true;
+				index = i;
+			}
+		} else if (table->tasks[i].task == task) {
+			WARN_ON(table->tasks[i].token != token);
+			ret = false;
+			break;
+		}
+	}
+
+	if (!ret)
+		goto unlock;
+
+	task->thread.data = &table->tasks[index].wq;
+	set_tsk_thread_flag(task, TIF_ASYNC_PF);
+
+	table->count++;
+	table->tasks[index].task = task;
+	table->tasks[index].token = token;
+
+unlock:
+	raw_spin_unlock(&table->lock);
+	return ret;
+}
+
+static inline void kvm_async_pf_remove_one_task(struct kvm_apf_table *table,
+						unsigned int index)
+{
+	clear_tsk_thread_flag(table->tasks[index].task, TIF_ASYNC_PF);
+	WRITE_ONCE(table->tasks[index].task->thread.data, NULL);
+
+	table->count--;
+	table->tasks[index].task = NULL;
+	table->tasks[index].token = 0;
+
+	swake_up_one(&table->tasks[index].wq);
+}
+
+static bool kvm_async_pf_remove_task(unsigned int token)
+{
+	struct kvm_apf_table *table = this_cpu_ptr(apf_tables);
+	unsigned int i;
+	bool ret = (token == UINT_MAX);
+
+	raw_spin_lock(&table->lock);
+
+	for (i = 0; i < apf_tasks; i++) {
+		if (!table->tasks[i].task)
+			continue;
+
+		/* Wakeup all */
+		if (token == UINT_MAX) {
+			kvm_async_pf_remove_one_task(table, i);
+			continue;
+		}
+
+		if (table->tasks[i].token == token) {
+			kvm_async_pf_remove_one_task(table, i);
+			ret = true;
+			break;
+		}
+	}
+
+	raw_spin_unlock(&table->lock);
+
+	return ret;
+}
+
+static int kvm_async_pf_sdei_handler(unsigned int event,
+				     struct pt_regs *regs,
+				     void *arg)
+{
+	unsigned int reason = __this_cpu_read(apf_data.reason);
+	unsigned int token = __this_cpu_read(apf_data.token);
+	bool ret;
+
+	if (reason != KVM_PV_REASON_PAGE_NOT_PRESENT) {
+		pr_warn("%s: Bogus notification (%d, 0x%08x)\n",
+			__func__, reason, token);
+		return -EINVAL;
+	}
+
+	ret = kvm_async_pf_add_task(current, token);
+	__this_cpu_write(apf_data.token, 0);
+	__this_cpu_write(apf_data.reason, 0);
+
+	if (!ret)
+		return -ENOSPC;
+
+	smp_send_reschedule(smp_processor_id());
+
+	return 0;
+}
+
+static irqreturn_t kvm_async_pf_irq_handler(int irq, void *dev_id)
+{
+	unsigned int reason = __this_cpu_read(apf_data.reason);
+	unsigned int token = __this_cpu_read(apf_data.token);
+	struct arm_smccc_res res;
+
+	if (reason != KVM_PV_REASON_PAGE_READY) {
+		pr_warn("%s: Bogus interrupt %d (%d, 0x%08x)\n",
+			__func__, irq, reason, token);
+		return IRQ_HANDLED;
+	}
+
+	kvm_async_pf_remove_task(token);
+
+	__this_cpu_write(apf_data.token, 0);
+	__this_cpu_write(apf_data.reason, 0);
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_IRQ_ACK, &res);
+
+	return IRQ_HANDLED;
+}
+
+static int __init kvm_async_pf_available(char *arg)
+{
+	async_pf_available = false;
+	return 0;
+}
+early_param("no-kvmapf", kvm_async_pf_available);
+
+static void kvm_async_pf_disable(void)
+{
+	struct arm_smccc_res res;
+	u32 enabled = __this_cpu_read(apf_data.enabled);
+
+	if (!enabled)
+		return;
+
+	/* Disable the functionality */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_ENABLE,
+			     0, 0, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld on CPU %d to disable APF\n",
+			__func__, res.a0, smp_processor_id());
+		return;
+	}
+
+	__this_cpu_write(apf_data.enabled, 0);
+
+	/* Clear SDEI event number */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_SDEI, 0, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld on CPU %d to clear SDEI event\n",
+			__func__, res.a0, smp_processor_id());
+	}
+
+	/* Clear PPI number */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_IRQ, 0, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld on CPU %d to clear PPI\n",
+			__func__, res.a0, smp_processor_id());
+	}
+
+	pr_info("Async PF disabled on CPU %d\n", smp_processor_id());
+}
+
+static void kvm_async_pf_enable(void)
+{
+	struct arm_smccc_res res;
+	u32 enabled = __this_cpu_read(apf_data.enabled);
+	u64 val = virt_to_phys(this_cpu_ptr(&apf_data));
+
+	if (enabled)
+		return;
+
+	/* Set SDEI event number */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_SDEI, apf_sdei_num,
+			     &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld on CPU %d to set SDEI event\n",
+			__func__, res.a0, smp_processor_id());
+		return;
+	}
+
+	/* Set PPI number */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_IRQ,
+			     apf_ppi_num, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld on CPU %d to set PPI\n",
+			__func__, res.a0, smp_processor_id());
+		return;
+	}
+
+	/* Enable the functionality */
+	val |= KVM_ASYNC_PF_ENABLED;
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_ENABLE,
+			     (u32)val, (u32)(val >> 32), &res);
+	if (res.a0 != SMCCC_RET_SUCCESS) {
+		pr_warn("%s: Error %ld on CPU %d to enable APF\n",
+			__func__, res.a0, smp_processor_id());
+	}
+
+	__this_cpu_write(apf_data.enabled, 1);
+
+	pr_info("Async PF enabled on CPU %d\n", smp_processor_id());
+}
+
+static void kvm_async_pf_cpu_disable(void *info)
+{
+	disable_percpu_irq(apf_irq);
+	kvm_async_pf_disable();
+}
+
+static void kvm_async_pf_cpu_enable(void *info)
+{
+	enable_percpu_irq(apf_irq, IRQ_TYPE_LEVEL_HIGH);
+	kvm_async_pf_enable();
+}
+
+static int kvm_async_pf_cpu_reboot_notify(struct notifier_block *nb,
+					  unsigned long code,
+					  void *unused)
+{
+	if (code == SYS_RESTART) {
+		sdei_event_disable(apf_sdei_event);
+		sdei_event_unregister(apf_sdei_event);
+
+		on_each_cpu(kvm_async_pf_cpu_disable, NULL, 1);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_async_pf_cpu_reboot_nb = {
+	.notifier_call = kvm_async_pf_cpu_reboot_notify,
+};
+
+static int kvm_async_pf_cpu_online(unsigned int cpu)
+{
+	kvm_async_pf_cpu_enable(NULL);
+
+	return 0;
+}
+
+static int kvm_async_pf_cpu_offline(unsigned int cpu)
+{
+	kvm_async_pf_cpu_disable(NULL);
+
+	return 0;
+}
+
+static int __init kvm_async_pf_info(void)
+{
+	struct acpi_table_apft *apft;
+	acpi_status status;
+
+	if (acpi_disabled)
+		return -EPERM;
+
+	status = acpi_get_table(ACPI_SIG_APFT, 0,
+				(struct acpi_table_header **)&apft);
+	if (ACPI_FAILURE(status)) {
+		pr_warn("%s: Failed to get ACPI:APFT <%s>\n",
+			__func__, acpi_format_exception(status));
+		return -ENODEV;
+	}
+
+	apf_sdei_num = apft->sdei_event;
+	apf_ppi_num = apft->interrupt;
+	apf_ppi_mode = (apft->interrupt_flags & ACPI_APFT_INTERRUPT_MODE) ?
+		       ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+	apf_ppi_polarity =
+		(apft->interrupt_flags & ACPI_APFT_INTERRUPT_POLARITY) ?
+		ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
+
+	return 0;
+}
+
+static int __init kvm_async_pf_init(void)
+{
+	struct kvm_apf_table *table;
+	struct arm_smccc_res res;
+	size_t size;
+	int cpu, i, ret;
+
+	if (!kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) ||
+	    !async_pf_available)
+		return -EPERM;
+
+	/* Retrieve information from ACPI:APFT */
+	ret = kvm_async_pf_info();
+	if (ret) {
+		pr_warn("%s: Error %d parsing ACPI:APFT\n",
+			__func__, ret);
+		return ret;
+	}
+
+	/*
+	 * Check the version and v1.0.0 or higher version is required
+	 * to support the functionality.
+	 */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_VERSION,
+			     &res);
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
+		pr_warn("%s: Error to retrieve version\n",
+			__func__);
+		return -EPERM;
+	}
+
+	if ((res.a0 & 0xFFFFFFFFFF000000) ||
+	    ((res.a0 & 0xFF0000) >> 16) < 0x1) {
+		pr_warn("%s: Invalid version (0x%016lx)\n",
+			__func__, res.a0);
+		return -EINVAL;
+	}
+
+	/* Retrieve number of tokens */
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
+			     ARM_SMCCC_KVM_FUNC_APF_TOKEN_NUM,
+			     &res);
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
+		pr_warn("%s: Error to retrieve token number\n",
+			__func__);
+		return -EPERM;
+	}
+
+	/* Allocate and initialize the sleeper table */
+	apf_tasks = res.a0 * 2;
+	size = sizeof(struct kvm_apf_table) +
+	       apf_tasks * sizeof(struct kvm_apf_task);
+	apf_tables = __alloc_percpu(size, 0);
+	if (!apf_tables) {
+		pr_warn("%s: Unable to alloc async PF table\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu) {
+		table = per_cpu_ptr(apf_tables, cpu);
+		raw_spin_lock_init(&table->lock);
+		for (i = 0; i < apf_tasks; i++)
+			init_swait_queue_head(&table->tasks[i].wq);
+	}
+
+	/*
+	 * Initialize SDEI event for page-not-present notification.
+	 * The SDEI event number should have been retrieved from
+	 * the ACPI:APFT table.
+	 */
+	apf_sdei_event = sdei_event_register(apf_sdei_num,
+					     kvm_async_pf_sdei_handler,
+					     NULL);
+	if (IS_ERR(apf_sdei_event)) {
+		pr_warn("%s: Error %ld to register SDEI event\n",
+			__func__, PTR_ERR(apf_sdei_event));
+		ret = -EIO;
+		goto release_tables;
+	}
+
+	ret = sdei_event_enable(apf_sdei_event);
+	if (ret) {
+		pr_warn("%s: Error %d to enable SDEI event\n",
+			__func__, ret);
+		goto unregister_event;
+	}
+
+	/*
+	 * Initialize interrupt for page-ready notification. The
+	 * interrupt number and its properties should have been
+	 * retrieved from the ACPI:APFT table.
+	 */
+	apf_irq = acpi_register_gsi(NULL, apf_ppi_num,
+				    apf_ppi_mode, apf_ppi_polarity);
+	if (apf_irq <= 0) {
+		ret = -EIO;
+		pr_warn("%s: Unable to register IRQ\n", __func__);
+		goto disable_event;
+	}
+
+	ret = request_percpu_irq(apf_irq, kvm_async_pf_irq_handler,
+				 "Asynchronous Page Fault", &apf_data);
+	if (ret) {
+		pr_warn("%s: Error %d to request IRQ\n", __func__, ret);
+		goto unregister_irq;
+	}
+
+	register_reboot_notifier(&kvm_async_pf_cpu_reboot_nb);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+			"arm/kvm:online", kvm_async_pf_cpu_online,
+			kvm_async_pf_cpu_offline);
+	if (ret < 0) {
+		pr_warn("%s: Error %d to install cpu hotplug callbacks\n",
+			__func__, ret);
+		goto release_irq;
+	}
+
+	/* Enable async PF on the online CPUs */
+	on_each_cpu(kvm_async_pf_cpu_enable, NULL, 1);
+
+	return 0;
+
+release_irq:
+	free_percpu_irq(apf_irq, &apf_data);
+unregister_irq:
+	acpi_unregister_gsi(apf_ppi_num);
+disable_event:
+	sdei_event_disable(apf_sdei_event);
+unregister_event:
+	sdei_event_unregister(apf_sdei_event);
+release_tables:
+	free_percpu(apf_tables);
+
+	return ret;
+}
+
+static int __init kvm_guest_init(void)
+{
+	return kvm_async_pf_init();
+}
+
+fs_initcall(kvm_guest_init);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 3b4f31f35e45..42328efbc946 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -921,6 +921,23 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 		/* Check valid user FS if needed */
 		addr_limit_user_check();
 
+		if (thread_flags & _TIF_ASYNC_PF) {
+			struct swait_queue_head *wq =
+				READ_ONCE(current->thread.data);
+			DECLARE_SWAITQUEUE(wait);
+
+			local_daif_restore(DAIF_PROCCTX_NOIRQ);
+
+			do {
+				prepare_to_swait_exclusive(wq,
+					&wait, TASK_UNINTERRUPTIBLE);
+				if (!test_thread_flag(TIF_ASYNC_PF))
+					break;
+
+				schedule();
+			} while (test_thread_flag(TIF_ASYNC_PF));
+		}
+
 		if (thread_flags & _TIF_NEED_RESCHED) {
 			/* Unmask Debug and SError for the next task */
 			local_daif_restore(DAIF_PROCCTX_NOIRQ);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
