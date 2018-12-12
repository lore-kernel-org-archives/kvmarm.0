From: Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v2 06/12] KVM: arm64: Support stolen time reporting via
 shared structure
Date: Wed, 12 Dec 2018 15:02:20 +0000
Message-ID: <20181212150226.38051-7-steven.price@arm.com>
References: <20181212150226.38051-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F654A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V-Ahhuscwwmi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 10:03:14 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085954A371
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:10 -0500 (EST)
In-Reply-To: <20181212150226.38051-1-steven.price@arm.com>
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

Implement the service call for configuring a shared structre between a
VCPU and the hypervisor in which the hypervisor can write the time
stolen from the VCPU's execution time by other tasks on the host.

The hypervisor allocates memory which is placed at an IPA chosen by user
space. The hypervisor then uses WRITE_ONCE() to update the shared
structre ensuring single copy atomicity of the 64-bit unsigned value
that reports stolen time in nanoseconds.

Whenever stolen time is enabled by the guest, the stolen time counter is
reset.

The stolen time itself is retrieved from the sched_info structure
maintained by the Linux scheduler code. We enable SCHEDSTATS when
selecting KVM Kconfig to ensure this value is meaningful.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++
 arch/arm64/kvm/Kconfig            |  1 +
 include/kvm/arm_hypercalls.h      |  1 +
 include/linux/kvm_types.h         |  2 +
 virt/kvm/arm/arm.c                | 20 ++++++++-
 virt/kvm/arm/hypercalls.c         | 70 +++++++++++++++++++++++++++++++
 6 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 52fbc823ff8c..bab7bc720992 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -48,6 +48,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(2)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -80,6 +81,11 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	struct kvm_arch_pvtime {
+		void *st;
+		gpa_t st_base;
+	} pvtime;
 };
 
 #define KVM_NR_MEM_OBJS     40
@@ -300,6 +306,12 @@ struct kvm_vcpu_arch {
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
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 8bf259dae9f6..ff0e314c7dcd 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -49,6 +49,8 @@ typedef unsigned long  gva_t;
 typedef u64            gpa_t;
 typedef u64            gfn_t;
 
+#define GPA_INVALID	(~(gpa_t)0)
+
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef u64            hfn_t;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 23774970c9df..b347ba38cb11 100644
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
@@ -148,6 +150,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = vgic_present ?
 				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 
+	kvm->arch.pvtime.st_base = GPA_INVALID;
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(kvm);
@@ -383,6 +386,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -629,6 +633,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
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
@@ -645,6 +658,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * that a VCPU sees new virtual interrupts.
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
+			vcpu_req_record_steal(vcpu);
 	}
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index ba13b798f0f8..595d1cf3a871 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -10,6 +10,70 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
+
+static struct pvclock_vcpu_stolen_time_info *pvtime_get_st(
+		struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_stolen_time_info *st = vcpu->kvm->arch.pvtime.st;
+
+	if (!st)
+		return NULL;
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
@@ -49,8 +113,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_HV_PV_FEATURES:
 		feature = smccc_get_arg1(vcpu);
 		switch (feature) {
+		case ARM_SMCCC_HV_PV_FEATURES:
+		case ARM_SMCCC_HV_PV_TIME_ST:
+			val = SMCCC_RET_SUCCESS;
+			break;
 		}
 		break;
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_hypercall_stolen_time(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
-- 
2.19.2
