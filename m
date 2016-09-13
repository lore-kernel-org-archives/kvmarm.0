From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH 3/7] KVM: arm/arm64: Register perf trace event notifier
Date: Tue, 13 Sep 2016 11:16:05 +0100
Message-ID: <1473761769-30572-4-git-send-email-punit.agrawal@arm.com>
References: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B11C49B6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:08:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EyPnYFKkhslQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 06:08:22 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B25149B9B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:08:21 -0400 (EDT)
In-Reply-To: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Register a notifier to track state changes of perf trace events.

The notifier will enable taking appropriate action for trace events
targeting VM.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |   3 +
 arch/arm/kvm/arm.c                |   2 +
 arch/arm64/include/asm/kvm_host.h |   8 +++
 arch/arm64/kvm/Kconfig            |   4 ++
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/perf_trace.c       | 122 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 140 insertions(+)
 create mode 100644 arch/arm64/kvm/perf_trace.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index de338d9..609998e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -280,6 +280,9 @@ static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+static inline int kvm_perf_trace_init(void) { return 0; }
+static inline int kvm_perf_trace_teardown(void) { return 0; }
+
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 75f130e..e1b99c4 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1220,6 +1220,7 @@ static int init_subsystems(void)
 		goto out;
 
 	kvm_perf_init();
+	kvm_perf_trace_init();
 	kvm_coproc_table_init();
 
 out:
@@ -1411,6 +1412,7 @@ out_err:
 void kvm_arch_exit(void)
 {
 	kvm_perf_teardown();
+	kvm_perf_trace_teardown();
 }
 
 static int arm_init(void)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3eda975..f6ff8e5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -345,6 +345,14 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+#if !defined(CONFIG_KVM_PERF_TRACE)
+static inline int kvm_perf_trace_init(void) { return 0; }
+static inline int kvm_perf_trace_teardown(void) { return 0; }
+#else
+int kvm_perf_trace_init(void);
+int kvm_perf_trace_teardown(void);
+#endif
+
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 9c9edc9..56e9537 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -19,6 +19,9 @@ if VIRTUALIZATION
 config KVM_ARM_VGIC_V3
 	bool
 
+config KVM_PERF_TRACE
+        bool
+
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
@@ -39,6 +42,7 @@ config KVM
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
+	select KVM_PERF_TRACE if EVENT_TRACING && PERF_EVENTS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 695eb3c..7d175e4 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -19,6 +19,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM_PERF_TRACE) += perf_trace.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
diff --git a/arch/arm64/kvm/perf_trace.c b/arch/arm64/kvm/perf_trace.c
new file mode 100644
index 0000000..1cafbc9
--- /dev/null
+++ b/arch/arm64/kvm/perf_trace.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2016 ARM Ltd.
+ * Author: Punit Agrawal <punit.agrawal@arm.com>
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
+#include <linux/kvm_host.h>
+#include <linux/trace_events.h>
+
+typedef int (*perf_trace_callback_fn)(struct kvm *kvm, bool enable);
+
+struct kvm_trace_hook {
+	char *key;		/* Name of the tracepoint to match */
+	perf_trace_callback_fn setup_fn;
+};
+
+static struct kvm_trace_hook trace_hook[] = {
+	{ },
+};
+
+static perf_trace_callback_fn find_trace_callback(const char *trace_key)
+{
+	int i;
+
+	for (i = 0; trace_hook[i].key; i++)
+		if (!strcmp(trace_key, trace_hook[i].key))
+			return trace_hook[i].setup_fn;
+
+	return NULL;
+}
+
+static int kvm_perf_trace_notifier(struct notifier_block *nb,
+				   unsigned long event, void *data)
+{
+	struct perf_event *p_event = data;
+	struct trace_event_call *tp_event = p_event->tp_event;
+	perf_trace_callback_fn setup_trace_fn;
+	struct kvm *kvm = NULL;
+	struct pid *pid;
+	bool found = false;
+
+	/*
+	 * Is this a trace point?
+	 */
+	if (!(tp_event->flags & TRACE_EVENT_FL_TRACEPOINT))
+		goto out;
+
+	/*
+	 * We'll get here for events we care to monitor for KVM. As we
+	 * only care about events attached to a VM, check that there
+	 * is a task associated with the perf event.
+	 */
+	if (p_event->attach_state != PERF_ATTACH_TASK)
+		goto out;
+
+	/*
+	 * This notifier gets called when perf trace event instance is
+	 * added or removed. Until we can restrict this to events of
+	 * interest in core, minimise the overhead below.
+	 *
+	 * Do we care about it? i.e., is there a callback for this
+	 * trace point?
+	 */
+	setup_trace_fn = find_trace_callback(tp_event->tp->name);
+	if (!setup_trace_fn)
+		goto out;
+
+	pid = get_task_pid(p_event->hw.target, PIDTYPE_PID);
+
+	/*
+	 * Does it match any of the VMs?
+	 */
+	spin_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		if (kvm->pid == pid) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&kvm_lock);
+
+	put_pid(pid);
+	if (!found)
+		goto out;
+
+	switch (event) {
+	case TRACE_REG_PERF_OPEN:
+		setup_trace_fn(kvm, true);
+		break;
+
+	case TRACE_REG_PERF_CLOSE:
+		setup_trace_fn(kvm, false);
+		break;
+	}
+
+out:
+	return 0;
+}
+
+static struct notifier_block kvm_perf_trace_notifier_block = {
+	.notifier_call = kvm_perf_trace_notifier,
+};
+
+int kvm_perf_trace_init(void)
+{
+	return perf_trace_notifier_register(&kvm_perf_trace_notifier_block);
+}
+
+int kvm_perf_trace_teardown(void)
+{
+	return perf_trace_notifier_unregister(&kvm_perf_trace_notifier_block);
+}
-- 
2.8.1
