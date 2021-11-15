Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D0EC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:49:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5890861AED
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5890861AED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C7A4B1C9;
	Mon, 15 Nov 2021 11:49:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zqCqqta-sscb; Mon, 15 Nov 2021 11:49:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D90634B1D2;
	Mon, 15 Nov 2021 11:49:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E0C4B10E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:49:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HpLUxzMiYK06 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:49:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B02F4B19A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:49:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF7C11FB;
 Mon, 15 Nov 2021 08:49:25 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62D853F766;
 Mon, 15 Nov 2021 08:49:24 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/4] KVM: arm64: Refuse to run VCPU if the PMU doesn't match
 the physical CPU
Date: Mon, 15 Nov 2021 16:50:41 +0000
Message-Id: <20211115165041.194884-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165041.194884-1-alexandru.elisei@arm.com>
References: <20211115165041.194884-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The VCPU is flagged as being scheduled on the wrong CPU in vcpu_load(), but
the flag is cleared when the KVM_RUN enters the non-preemptible section
instead of in vcpu_put(); this has been done on purpose so the error
condition is communicated as soon as possible to userspace, otherwise
vcpu_load() on the wrong CPU followed by a vcpu_put() could clear the flag.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst          |  5 +++--
 Documentation/virt/kvm/devices/vcpu.rst |  3 ++-
 arch/arm64/include/asm/kvm_host.h       |  3 +++
 arch/arm64/kvm/arm.c                    | 15 +++++++++++++++
 arch/arm64/kvm/pmu-emul.c               |  1 +
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..5bbad8318ea5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -396,8 +396,9 @@ Errors:
 
   =======    ==============================================================
   EINTR      an unmasked signal is pending
-  ENOEXEC    the vcpu hasn't been initialized or the guest tried to execute
-             instructions from device memory (arm64)
+  ENOEXEC    the vcpu hasn't been initialized, the guest tried to execute
+             instructions from device memory (arm64) or the vcpu PMU is
+             different from the physical cpu PMU (arm64).
   ENOSYS     data abort outside memslots with no syndrome info and
              KVM_CAP_ARM_NISV_TO_USER not enabled (arm64)
   EPERM      SVE feature set but not finalized (arm64)
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 59ac382af59a..ca0da34da889 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -128,7 +128,8 @@ systems where there are at least two PMUs on the system.
 
 Note that KVM will not make any attempts to run the VCPU on the physical CPUs
 associated with the PMU specified by this attribute. This is entirely left to
-userspace.
+userspace. However, if the VCPU is scheduled on a CPU which has a different PMU,
+then KVM_RUN will return with the error code ENOEXEC.
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..ae2083b41d8a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -385,6 +385,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	cpumask_var_t supported_cpus;
+	bool cpu_not_supported;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2f03cbfefe67..5dbfd18c4e37 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -320,6 +320,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
+	if (!zalloc_cpumask_var(&vcpu->arch.supported_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
@@ -347,6 +350,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
+	free_cpumask_var(vcpu->arch.supported_cpus);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
@@ -425,6 +429,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+
+	if (!cpumask_empty(vcpu->arch.supported_cpus) &&
+	    !cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
+		vcpu->arch.cpu_not_supported = true;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -815,6 +823,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
+		if (unlikely(vcpu->arch.cpu_not_supported)) {
+			vcpu->arch.cpu_not_supported = false;
+			ret = -ENOEXEC;
+			preempt_enable();
+			continue;
+		}
+
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 53cedeb5dbf6..957a6d0cfa56 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -951,6 +951,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
 			kvm_pmu->arm_pmu = arm_pmu;
+			cpumask_copy(vcpu->arch.supported_cpus, &arm_pmu->supported_cpus);
 			return 0;
 		}
 	}
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
