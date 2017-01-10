From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 6/9] kvm: arm/arm64: Add host pmu to support VM
 introspection
Date: Tue, 10 Jan 2017 11:38:53 +0000
Message-ID: <20170110113856.7183-7-punit.agrawal@arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7135E40780
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qNi-sPyyt6sB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 06:38:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21AE3405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:28 -0500 (EST)
In-Reply-To: <20170110113856.7183-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Both AArch32 and AArch64 mode of the ARMv8 architecture support trapping
certain VM operations, e.g, TLB and cache maintenance
operations. Selective trapping of these operations for specific VMs can
be used to track the frequency with which these occur during execution.

Add a software PMU on the host that can support tracking VM
operations (in the form of PMU events). Supporting new events requires
providing callbacks to configure the VM to enable/disable the trapping
and read a count of the frequency.

The host PMU events can be controlled by tools like perf that use
standard kernel perf interfaces.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |   8 ++
 arch/arm/kvm/arm.c                |   2 +
 arch/arm64/include/asm/kvm_host.h |   8 ++
 virt/kvm/arm/host_pmu.c           | 272 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 290 insertions(+)
 create mode 100644 virt/kvm/arm/host_pmu.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 26f0c8a0b790..b988f8801b86 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -289,6 +289,14 @@ static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+#if !defined(CONFIG_KVM_HOST_PMU)
+static inline int kvm_host_pmu_init(void) { return 0; }
+static inline void kvm_host_pmu_teardown(void) { }
+#else
+int kvm_host_pmu_init(void);
+void kvm_host_pmu_teardown(void);
+#endif
+
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 11676787ad49..058626b65b8d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1263,6 +1263,7 @@ static int init_subsystems(void)
 		goto out;
 
 	kvm_perf_init();
+	kvm_host_pmu_init();
 	kvm_coproc_table_init();
 
 out:
@@ -1453,6 +1454,7 @@ int kvm_arch_init(void *opaque)
 void kvm_arch_exit(void)
 {
 	kvm_perf_teardown();
+	kvm_host_pmu_teardown();
 }
 
 static int arm_init(void)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1e83b707f14c..018f887e8964 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -349,6 +349,14 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+#if !defined(CONFIG_KVM_HOST_PMU)
+static inline int kvm_host_pmu_init(void) { return 0; }
+static inline void kvm_host_pmu_teardown(void) { }
+#else
+int kvm_host_pmu_init(void);
+void kvm_host_pmu_teardown(void);
+#endif
+
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
diff --git a/virt/kvm/arm/host_pmu.c b/virt/kvm/arm/host_pmu.c
new file mode 100644
index 000000000000..fc610ccc169a
--- /dev/null
+++ b/virt/kvm/arm/host_pmu.c
@@ -0,0 +1,272 @@
+#include <linux/cpumask.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/perf_event.h>
+#include <linux/pid.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock_types.h>
+#include <linux/sysfs.h>
+
+#include <asm/kvm_emulate.h>
+
+enum host_pmu_events {
+	KVM_HOST_MAX_EVENTS,
+};
+
+struct host_pmu {
+	struct pmu pmu;
+	spinlock_t event_list_lock;
+	struct list_head event_list_head;
+} host_pmu;
+#define to_host_pmu(p) (container_of(p, struct host_pmu, pmu))
+
+typedef void (*configure_event_fn)(struct kvm *kvm, bool enable);
+typedef u64 (*get_event_count_fn)(struct kvm *kvm);
+
+struct kvm_event_cb {
+	enum host_pmu_events event;
+	get_event_count_fn get_event_count;
+	configure_event_fn configure_event;
+};
+
+struct event_data {
+	bool enable;
+	struct kvm *kvm;
+	struct kvm_event_cb *cb;
+	struct work_struct work;
+	struct list_head event_list;
+};
+
+static struct kvm_event_cb event_callbacks[] = {
+};
+
+static struct attribute *event_attrs[] = {
+	NULL,
+};
+
+static struct attribute_group events_attr_group = {
+	.name	= "events",
+	.attrs	= event_attrs,
+};
+
+
+#define VM_MASK	GENMASK_ULL(31, 0)
+#define EVENT_MASK	GENMASK_ULL(32, 39)
+#define EVENT_SHIFT	(32)
+
+#define to_pid(cfg)	((cfg) & VM_MASK)
+#define to_event(cfg)	(((cfg) & EVENT_MASK) >> EVENT_SHIFT)
+
+PMU_FORMAT_ATTR(vm, "config:0-31");
+PMU_FORMAT_ATTR(event, "config:32-39");
+
+static struct attribute *format_attrs[] = {
+	&format_attr_vm.attr,
+	&format_attr_event.attr,
+	NULL,
+};
+
+static struct attribute_group format_attr_group = {
+	.name	= "format",
+	.attrs	= format_attrs,
+};
+
+static const struct attribute_group *attr_groups[] = {
+	&events_attr_group,
+	&format_attr_group,
+	NULL,
+};
+
+static void host_event_destroy(struct perf_event *event)
+{
+	struct host_pmu *host_pmu = to_host_pmu(event->pmu);
+	struct event_data *e_data = event->pmu_private;
+
+	/*
+	 * Ensure outstanding work items related to this event are
+	 * completed before freeing resources.
+	 */
+	flush_work(&e_data->work);
+
+	kvm_put_kvm(e_data->kvm);
+
+	spin_lock(&host_pmu->event_list_lock);
+	list_del(&e_data->event_list);
+	spin_unlock(&host_pmu->event_list_lock);
+	kfree(e_data);
+}
+
+void host_event_work(struct work_struct *work)
+{
+	struct event_data *e_data = container_of(work, struct event_data, work);
+	struct kvm *kvm = e_data->kvm;
+
+	e_data->cb->configure_event(kvm, e_data->enable);
+}
+
+static int host_event_init(struct perf_event *event)
+{
+	struct host_pmu *host_pmu = to_host_pmu(event->pmu);
+	int event_id = to_event(event->attr.config);
+	pid_t task_pid = to_pid(event->attr.config);
+	struct event_data *e_data, *pos;
+	bool found = false;
+	struct pid *pid;
+	struct kvm *kvm;
+	int ret = 0;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	if (has_branch_stack(event)	||
+	    is_sampling_event(event)	||
+	    event->attr.exclude_user	||
+	    event->attr.exclude_kernel	||
+	    event->attr.exclude_hv	||
+	    event->attr.exclude_idle	||
+	    event->attr.exclude_guest) {
+		return -EINVAL;
+	}
+
+	if (event->attach_state == PERF_ATTACH_TASK)
+		return -EOPNOTSUPP;
+
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	if (event_id >= KVM_HOST_MAX_EVENTS)
+		return -EINVAL;
+
+	pid = find_get_pid(task_pid);
+	spin_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		if (kvm->pid == pid) {
+			kvm_get_kvm(kvm);
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&kvm_lock);
+	put_pid(pid);
+
+	if (!found)
+		return -EINVAL;
+
+	spin_lock(&host_pmu->event_list_lock);
+	/* Make sure we don't already have the (event_id, kvm) pair */
+	list_for_each_entry(pos, &host_pmu->event_list_head, event_list) {
+		if (pos->cb->event == event_id &&
+		    pos->kvm->pid == pid) {
+			kvm_put_kvm(kvm);
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+	}
+
+	e_data = kzalloc(sizeof(*e_data), GFP_KERNEL);
+	e_data->kvm = kvm;
+	e_data->cb = &event_callbacks[event_id];
+	INIT_WORK(&e_data->work, host_event_work);
+	event->pmu_private = e_data;
+	event->cpu = cpumask_first(cpu_online_mask);
+	event->destroy = host_event_destroy;
+
+	list_add_tail(&e_data->event_list, &host_pmu->event_list_head);
+
+unlock:
+	spin_unlock(&host_pmu->event_list_lock);
+
+	return ret;
+}
+
+static void host_event_update(struct perf_event *event)
+{
+	struct event_data *e_data = event->pmu_private;
+	struct kvm_event_cb *cb = e_data->cb;
+	struct kvm *kvm = e_data->kvm;
+	struct hw_perf_event *hw = &event->hw;
+	u64 prev_count, new_count;
+
+	do {
+		prev_count = local64_read(&hw->prev_count);
+		new_count = cb->get_event_count(kvm);
+	} while (local64_xchg(&hw->prev_count, new_count) != prev_count);
+
+	local64_add(new_count - prev_count, &event->count);
+}
+
+static void host_event_start(struct perf_event *event, int flags)
+{
+	struct event_data *e_data = event->pmu_private;
+	struct kvm_event_cb *cb = e_data->cb;
+	struct kvm *kvm = e_data->kvm;
+	u64 val;
+
+	val = cb->get_event_count(kvm);
+	local64_set(&event->hw.prev_count, val);
+
+	e_data->enable = true;
+	schedule_work(&e_data->work);
+}
+
+static void host_event_stop(struct perf_event *event, int flags)
+{
+	struct event_data *e_data = event->pmu_private;
+
+	e_data->enable = false;
+	schedule_work(&e_data->work);
+
+	if (flags & PERF_EF_UPDATE)
+		host_event_update(event);
+}
+
+static int host_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		host_event_start(event, flags);
+
+	return 0;
+}
+
+static void host_event_del(struct perf_event *event, int flags)
+{
+	host_event_stop(event, PERF_EF_UPDATE);
+}
+
+static void host_event_read(struct perf_event *event)
+{
+	host_event_update(event);
+}
+
+static void init_host_pmu(struct host_pmu *host_pmu)
+{
+	host_pmu->pmu = (struct pmu) {
+		.task_ctx_nr	= perf_sw_context,
+		.attr_groups	= attr_groups,
+		.event_init	= host_event_init,
+		.add		= host_event_add,
+		.del		= host_event_del,
+		.start		= host_event_start,
+		.stop		= host_event_stop,
+		.read		= host_event_read,
+		.capabilities	= PERF_PMU_CAP_NO_INTERRUPT,
+	};
+
+	INIT_LIST_HEAD(&host_pmu->event_list_head);
+	spin_lock_init(&host_pmu->event_list_lock);
+}
+
+int kvm_host_pmu_init(void)
+{
+	init_host_pmu(&host_pmu);
+
+	return perf_pmu_register(&host_pmu.pmu, "kvm", -1);
+}
+
+void kvm_host_pmu_teardown(void)
+{
+	perf_pmu_unregister(&host_pmu.pmu);
+}
-- 
2.11.0
