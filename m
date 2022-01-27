Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A214C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:18:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D25004A534;
	Thu, 27 Jan 2022 11:18:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pNS4xmUT5Uhk; Thu, 27 Jan 2022 11:18:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22C4E4B104;
	Thu, 27 Jan 2022 11:18:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F1D24B0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZn0FPvA5VL5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:18:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD40249ED3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:13 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D249F113E;
 Thu, 27 Jan 2022 08:18:12 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85C893F766;
 Thu, 27 Jan 2022 08:18:10 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 6/6] KVM: arm64: Refuse to run VCPU if the PMU doesn't
 match the physical CPU
Date: Thu, 27 Jan 2022 16:17:59 +0000
Message-Id: <20220127161759.53553-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127161759.53553-1-alexandru.elisei@arm.com>
References: <20220127161759.53553-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: tglx@linutronix.de, mingo@redhat.com
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

Userspace can assign a PMU to a VCPU with the KVM_ARM_VCPU_PMU_V3_SET_PMU
device ioctl. If the VCPU is scheduled on a physical CPU which has a
different PMU, the perf events needed to emulate a guest PMU won't be
scheduled in and the guest performance counters will stop counting. Treat
it as an userspace error and refuse to run the VCPU in this situation.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  6 +++++-
 arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  3 +++
 arch/arm64/kvm/arm.c                    | 17 +++++++++++++++++
 arch/arm64/kvm/pmu-emul.c               |  1 +
 5 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index e8c5770590a2..260db203a1e2 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -131,7 +131,11 @@ if a PMU event filter is already present.
 
 Note that KVM will not make any attempts to run the VCPU on the physical CPUs
 associated with the PMU specified by this attribute. This is entirely left to
-userspace.
+userspace. However, attempting to run the VCPU on a physical CPU not supported
+by the PMU will fail and KVM_RUN will return with
+exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct by setting
+hardare_entry_failure_reason field to KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and
+the cpu field to the processor id.
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 57141a3a3740..0bed0e33e1ae 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -131,6 +131,8 @@ struct kvm_arch {
 	unsigned long *pmu_filter;
 	struct arm_pmu *arm_pmu;
 
+	cpumask_var_t supported_cpus;
+
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
 
@@ -436,6 +438,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
 #define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
+#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
@@ -454,6 +457,15 @@ struct kvm_vcpu_arch {
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
 
+#define vcpu_on_unsupported_cpu(vcpu)					\
+	((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
+
+#define vcpu_set_on_unsupported_cpu(vcpu)				\
+	((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
+
+#define vcpu_clear_on_unsupported_cpu(vcpu)				\
+	((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
+
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
 /*
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1d0a0a2a9711..d49f714f48e6 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -414,6 +414,9 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
 #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
 
+/* run->fail_entry.hardware_entry_failure_reason codes. */
+#define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f4e7e38a19e9..7b7658a9186f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -150,6 +150,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
+	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
+		goto out_free_stage2_pgd;
+	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
+
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
@@ -176,6 +180,7 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	bitmap_free(kvm->arch.pmu_filter);
+	free_cpumask_var(kvm->arch.supported_cpus);
 
 	kvm_vgic_destroy(kvm);
 
@@ -411,6 +416,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+
+	if (!cpumask_test_cpu(smp_processor_id(), vcpu->kvm->arch.supported_cpus))
+		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -423,6 +431,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
 
+	vcpu_clear_on_unsupported_cpu(vcpu);
 	vcpu->cpu = -1;
 }
 
@@ -796,6 +805,14 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 		}
 	}
 
+	if (unlikely(vcpu_on_unsupported_cpu(vcpu))) {
+		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		run->fail_entry.hardware_entry_failure_reason = KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED;
+		run->fail_entry.cpu = smp_processor_id();
+		*ret = 0;
+		return true;
+	}
+
 	return kvm_request_pending(vcpu) ||
 			need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
 			xfer_to_guest_mode_work_pending();
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 18361f367495..4526a5824dac 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -968,6 +968,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 			}
 
 			kvm->arch.arm_pmu = arm_pmu;
+			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
 		}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
