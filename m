Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01848C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 15:23:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BAF84B164;
	Mon, 13 Dec 2021 10:23:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xUnSU4+b0tjU; Mon, 13 Dec 2021 10:23:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B5E4B152;
	Mon, 13 Dec 2021 10:23:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F4F4B162
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 10:23:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kPJCyw2GUQfN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 10:23:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222304B186
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 10:23:31 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7B591FB;
 Mon, 13 Dec 2021 07:23:30 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 182413F73B;
 Mon, 13 Dec 2021 07:23:28 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 4/4] KVM: arm64: Refuse to run VCPU if the PMU doesn't
 match the physical CPU
Date: Mon, 13 Dec 2021 15:23:09 +0000
Message-Id: <20211213152309.158462-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213152309.158462-1-alexandru.elisei@arm.com>
References: <20211213152309.158462-1-alexandru.elisei@arm.com>
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
 Documentation/virt/kvm/devices/vcpu.rst |  6 ++++-
 arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  3 +++
 arch/arm64/kvm/arm.c                    | 29 +++++++++++++++++++++++--
 arch/arm64/kvm/pmu-emul.c               |  1 +
 5 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index b918669bf925..dd8348879a8e 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -129,7 +129,11 @@ the same PMU, otherwise KVM_ARM_VCPU_PMU_V3_INIT will fail.
 
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
index 2a5f7f38006f..0c453f2e48b6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -385,6 +385,8 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	cpumask_var_t supported_cpus;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -420,6 +422,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
 #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
+#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 14) /* Physical CPU not in supported_cpus */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
@@ -460,6 +463,15 @@ struct kvm_vcpu_arch {
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
index e4727dc771bf..373e6a3d7221 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -327,6 +327,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
+	if (!zalloc_cpumask_var(&vcpu->arch.supported_cpus, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_copy(vcpu->arch.supported_cpus, cpu_possible_mask);
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
@@ -340,9 +344,16 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
-		return err;
+		goto out_err;
+
+	err = create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
+	if (err)
+		goto out_err;
+	return 0;
 
-	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
+out_err:
+	free_cpumask_var(vcpu->arch.supported_cpus);
+	return err;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -354,6 +365,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
+	free_cpumask_var(vcpu->arch.supported_cpus);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
@@ -432,6 +444,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+
+	if (!cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
+		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -444,6 +459,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
 
+	vcpu_clear_on_unsupported_cpu(vcpu);
 	vcpu->cpu = -1;
 }
 
@@ -759,6 +775,15 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 		}
 	}
 
+	if (unlikely(vcpu_on_unsupported_cpu(vcpu))) {
+		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		run->fail_entry.hardware_entry_failure_reason
+			= KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED;
+		run->fail_entry.cpu = smp_processor_id();
+		*ret = 0;
+		return true;
+	}
+
 	return kvm_request_pending(vcpu) ||
 			need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
 			xfer_to_guest_mode_work_pending();
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8de38d7fa493..d0581e3258f0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -974,6 +974,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
 			kvm_pmu->arm_pmu = arm_pmu;
+			cpumask_copy(vcpu->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			goto out_unlock;
 		}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
