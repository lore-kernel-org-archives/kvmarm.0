From: Steven Price <steven.price@arm.com>
Subject: [PATCH 09/12] KVM: arm64: Support stolen time reporting via shared
 page
Date: Wed, 28 Nov 2018 14:45:24 +0000
Message-ID: <20181128144527.44710-10-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1304A363
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6rMFSvnHHtR4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:44 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C4274A384
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:44 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Implement the service call for configuring a shared page between a VCPU
and the hypervisor in which the hypervisor can write the time stolen
from the VCPU's execution time by other tasks on the host.

We translate the IPA provided by user space (in a later patch) to the
corresponding physical page on the host, which we pin in memory and
kmap to the kernel's linear mapping. We can then use WRITE_ONCE() to
ensure single copy atomicity of the 64-bit unsigned value that reports
stolen time in nanoseconds.

We make sure to update the page mapping if user space changes the
memslots during execution by using the existing gfn_to_hva_cache feature
and memslots generation counter. If the gfn to hva mapping changes, we
update the pinned and mapped page accordingly.

Whenever stolen time is enabled by the guest, the stolen time counter is
reset.

The stolen time itself is retrieved from the sched_info structure
maintained by the Linux scheduler code. We enable SCHEDSTATS when
selecting KVM Kconfig to ensure this value is meaningful.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  9 ++++
 arch/arm64/kvm/Kconfig            |  1 +
 include/kvm/arm_hypercalls.h      |  1 +
 virt/kvm/arm/arm.c                | 20 ++++++++-
 virt/kvm/arm/hypercalls.c         | 70 +++++++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 827162b1fabf..c6bc1fc8ee00 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -48,6 +48,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(2)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -86,6 +87,8 @@ struct kvm_arch {
 
 		gpa_t lpt_page;
 		u32 lpt_fpv;
+
+		gpa_t st_base;
 	} pvtime;
 };
 
@@ -307,6 +310,12 @@ struct kvm_vcpu_arch {
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
+
+	/* Guest PV state */
+	struct {
+		u64 steal;
+		u64 last_steal;
+	} steal;
 };
 
 /* vcpu_arch flags field values: */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 47b23bf617c7..92676920d671 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -40,6 +40,7 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
+	select SCHEDSTATS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index e5f7f81196b6..2e03e993ad64 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -7,6 +7,7 @@
 #include <asm/kvm_emulate.h>
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
 {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4c6355f21352..d4ba21d3e7a5 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -32,8 +32,6 @@
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
 #include <trace/events/kvm.h>
-#include <kvm/arm_pmu.h>
-#include <kvm/arm_psci.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -52,6 +50,10 @@
 #include <asm/kvm_coproc.h>
 #include <asm/sections.h>
 
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_pmu.h>
+#include <kvm/arm_psci.h>
+
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
 #endif
@@ -150,6 +152,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	/* Set the PV Time addresses to invalid values */
 	kvm->arch.pvtime.lpt_page = GPA_INVALID;
+	kvm->arch.pvtime.st_base = GPA_INVALID;
 
 	return ret;
 out_free_stage2_pgd:
@@ -386,6 +389,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -634,6 +638,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vcpu_req_record_steal(struct kvm_vcpu *vcpu)
+{
+	int idx;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_update_stolen_time(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+}
+
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.target >= 0;
@@ -650,6 +663,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * that a VCPU sees new virtual interrupts.
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
+			vcpu_req_record_steal(vcpu);
 	}
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index fdb1880ab4c6..513f2285b29a 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -150,6 +150,73 @@ static int kvm_hypercall_time_lpt(struct kvm_vcpu *vcpu)
 	smccc_set_retval(vcpu, ret, 0, 0, 0);
 	return 1;
 }
+
+static struct pvclock_vcpu_stolen_time_info *pvtime_get_st(
+		struct kvm_vcpu *vcpu)
+{
+	void *pv_page = vcpu->kvm->arch.pvtime.pv_page;
+	struct pvclock_vcpu_stolen_time_info *st;
+
+	if (!pv_page)
+		return NULL;
+
+	st = pv_page + PAGE_SIZE;
+
+	return &st[kvm_vcpu_get_idx(vcpu)];
+}
+
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+	u64 steal;
+	struct pvclock_vcpu_stolen_time_info *kaddr;
+
+	if (vcpu->kvm->arch.pvtime.st_base == GPA_INVALID)
+		return -ENOTSUPP;
+
+	kaddr = pvtime_get_st(vcpu);
+
+	if (!kaddr)
+		return -ENOTSUPP;
+
+	kaddr->revision = 0;
+	kaddr->attributes = 0;
+
+	/* Let's do the local bookkeeping */
+	steal = vcpu->arch.steal.steal;
+	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.steal = steal;
+
+	/* Now write out the value to the shared page */
+	WRITE_ONCE(kaddr->stolen_time, cpu_to_le64(steal));
+
+	return 0;
+}
+
+static int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
+{
+	u64 ret;
+	int err;
+
+	/*
+	 * Start counting stolen time from the time the guest requests
+	 * the feature enabled.
+	 */
+	vcpu->arch.steal.steal = 0;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+
+	err = kvm_update_stolen_time(vcpu);
+
+	if (err)
+		ret = SMCCC_RET_NOT_SUPPORTED;
+	else
+		ret = vcpu->kvm->arch.pvtime.st_base +
+			(sizeof(struct pvclock_vcpu_stolen_time_info) *
+			 kvm_vcpu_get_idx(vcpu));
+
+	smccc_set_retval(vcpu, ret, 0, 0, 0);
+	return 1;
+}
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -191,12 +258,15 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		switch (feature) {
 		case ARM_SMCCC_HV_PV_FEATURES:
 		case ARM_SMCCC_HV_PV_TIME_LPT:
+		case ARM_SMCCC_HV_PV_TIME_ST:
 			val = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
 	case ARM_SMCCC_HV_PV_TIME_LPT:
 		return kvm_hypercall_time_lpt(vcpu);
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_hypercall_stolen_time(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
-- 
2.19.2
