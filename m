From: Steven Price <steven.price@arm.com>
Subject: [PATCH 06/12] KVM: arm64: Support Live Physical Time reporting
Date: Wed, 28 Nov 2018 14:45:21 +0000
Message-ID: <20181128144527.44710-7-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A846A4A397
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ciPZqX6ORFae for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5164A38A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:39 -0500 (EST)
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

Provide a method for a guest to derive a paravirtualized counter/timer
which isn't dependent on the host's counter frequency. This allows a
guest to be migrated onto a new host which doesn't have the same
frequency without the virtual counter being disturbed.

The host provides a shared page which contains coefficients that can be
used to map the real counter from the host (the Arm "virtual counter")
to a paravirtualized view of time. On migration the new host updates the
coefficients to ensure that the guests view of time (after using the
coefficients) doesn't change and that the derived counter progresses at
the same real frequency.

The guest can probe the existence of this support using the PV_FEATURES
SMCCC interface provided in the previous patch.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   7 ++
 include/kvm/arm_arch_timer.h      |   2 +
 include/linux/kvm_types.h         |   2 +
 virt/kvm/arm/arm.c                |   5 +
 virt/kvm/arm/hypercalls.c         | 146 ++++++++++++++++++++++++++++++
 5 files changed, 162 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 52fbc823ff8c..827162b1fabf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -80,6 +80,13 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	struct kvm_arch_pvtime {
+		void *pv_page;
+
+		gpa_t lpt_page;
+		u32 lpt_fpv;
+	} pvtime;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6502feb9524b..c8cdd96052e0 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -92,6 +92,8 @@ void kvm_timer_init_vhe(void);
 
 bool kvm_arch_timer_get_input_level(int vintid);
 
+int kvm_arm_update_lpt_sequence(struct kvm *kvm);
+
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
 #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 8bf259dae9f6..fd3a2caabeb2 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -49,6 +49,8 @@ typedef unsigned long  gva_t;
 typedef u64            gpa_t;
 typedef u64            gfn_t;
 
+#define GPA_INVALID    -1
+
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef u64            hfn_t;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 23774970c9df..4c6355f21352 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -148,6 +148,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = vgic_present ?
 				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 
+	/* Set the PV Time addresses to invalid values */
+	kvm->arch.pvtime.lpt_page = GPA_INVALID;
+
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(kvm);
@@ -587,6 +590,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
 
+	kvm_arm_update_lpt_sequence(kvm);
+
 	return ret;
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index ba13b798f0f8..fdb1880ab4c6 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -2,6 +2,7 @@
 // Copyright (C) 2018 Arm Ltd.
 
 #include <linux/arm-smccc.h>
+#include <linux/highmem.h>
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
@@ -10,6 +11,145 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
+#include <clocksource/arm_arch_timer.h>
+
+/*
+ * Returns ((u128)dividend << 64) / divisor
+ * Precondition: dividend < divisor
+ */
+static u64 shift64_div(u32 dividend, u32 divisor)
+{
+	u64 high = (u64)dividend << 32;
+	u64 low;
+	u64 rem;
+
+	WARN_ON(dividend >= divisor);
+
+	rem = do_div(high, divisor);
+	low = rem << 32;
+	do_div(low, divisor);
+
+	return (high << 32) | low;
+}
+
+/*
+ * Calculate the relative offset of each vCPU's timer and convert that to the
+ * new timer rate.
+ */
+static void update_vtimer_cval(struct kvm *kvm, u32 previous_rate)
+{
+	u32 current_rate = arch_timer_get_rate();
+	u64 current_time = kvm_phys_timer_read();
+	int i;
+	struct kvm_vcpu *vcpu;
+	u64 rel_cval;
+
+	/* Early out if there's nothing to do */
+	if (likely(previous_rate == current_rate))
+		return;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+		u64 cntvct;
+		u64 new_cntvct;
+
+		/*
+		 * The vtimer should not be already loaded as this function is
+		 * only called on the first run of the first VCPU before any
+		 * timers are loaded.
+		 */
+		if (WARN_ON(vtimer->loaded))
+			continue;
+
+		cntvct = current_time - vtimer->cntvoff;
+		new_cntvct = mul_u64_u32_div(cntvct, current_rate,
+					     previous_rate);
+		vtimer->cntvoff = current_time - new_cntvct;
+
+		rel_cval = vtimer->cnt_cval - cntvct;
+
+		rel_cval = mul_u64_u32_div(rel_cval, current_rate,
+					   previous_rate);
+
+		vtimer->cnt_cval = new_cntvct + rel_cval;
+	}
+}
+
+int kvm_arm_update_lpt_sequence(struct kvm *kvm)
+{
+	struct pvclock_vm_time_info *pvclock;
+	u64 lpt_ipa = kvm->arch.pvtime.lpt_page;
+	u64 native_freq, pv_freq, scale_mult, div_by_pv_freq_mult;
+	u64 shift = 0;
+	u64 sequence_number = 0;
+
+	if (lpt_ipa == GPA_INVALID)
+		return -EINVAL;
+
+	/* Page address must be 64 byte aligned */
+	if (lpt_ipa & 63)
+		return -EINVAL;
+
+	pvclock = kvm->arch.pvtime.pv_page;
+
+
+	if (!pvclock)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	sequence_number = le64_to_cpu(pvclock->sequence_number);
+	native_freq = le64_to_cpu(pvclock->native_freq);
+
+	if (native_freq) {
+		/*
+		 * The VM has been migrated, so update the sequence number
+		 * and correct the compare for the timer if the frequency has
+		 * changed
+		 */
+		sequence_number = sequence_number + 2;
+		update_vtimer_cval(kvm, native_freq);
+	}
+
+	native_freq = arch_timer_get_rate();
+	pv_freq = kvm->arch.pvtime.lpt_fpv;
+
+	if (pv_freq >= native_freq)
+		shift = ilog2(pv_freq / native_freq) + 1;
+
+	WARN_ON(native_freq > U32_MAX);
+	/* scale_mult = (pv_freq << 64) / (native_freq << shift) */
+	scale_mult = shift64_div(pv_freq, native_freq << shift);
+	/* div_by_pv_freq_mult = (1 << 64) / pv_freq */
+	div_by_pv_freq_mult = shift64_div(1, pv_freq);
+
+	pvclock->sequence_number = cpu_to_le64(sequence_number);
+	pvclock->native_freq = cpu_to_le64(native_freq);
+	pvclock->pv_freq = cpu_to_le64(pv_freq);
+	pvclock->shift = cpu_to_le32(shift);
+	pvclock->scale_mult = cpu_to_le64(scale_mult);
+	pvclock->div_by_pv_freq_mult = cpu_to_le64(div_by_pv_freq_mult);
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+}
+
+static int kvm_hypercall_time_lpt(struct kvm_vcpu *vcpu)
+{
+	u32 flags;
+	u64 ret = vcpu->kvm->arch.pvtime.lpt_page;
+
+	flags = smccc_get_arg1(vcpu);
+
+	if (flags) {
+		/* Currently no support for any flags */
+		ret = PV_VM_TIME_INVALID_PARAMETERS;
+	}
+
+	smccc_set_retval(vcpu, ret, 0, 0, 0);
+	return 1;
+}
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -49,8 +189,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_HV_PV_FEATURES:
 		feature = smccc_get_arg1(vcpu);
 		switch (feature) {
+		case ARM_SMCCC_HV_PV_FEATURES:
+		case ARM_SMCCC_HV_PV_TIME_LPT:
+			val = SMCCC_RET_SUCCESS;
+			break;
 		}
 		break;
+	case ARM_SMCCC_HV_PV_TIME_LPT:
+		return kvm_hypercall_time_lpt(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
-- 
2.19.2
