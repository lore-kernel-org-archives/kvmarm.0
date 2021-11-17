Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF73C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39FF761BFE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 39FF761BFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E17B14B131;
	Wed, 17 Nov 2021 10:37:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wss-UNN8tLk6; Wed, 17 Nov 2021 10:37:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 667194B17C;
	Wed, 17 Nov 2021 10:37:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C66E4B15E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SR2NbfKBAo63 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C131B4B160
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E57CED1;
 Wed, 17 Nov 2021 07:37:34 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F8F03F5A1;
 Wed, 17 Nov 2021 07:37:32 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 19/38] KVM: arm64: Do not run a VCPU on a CPU without
 SPE
Date: Wed, 17 Nov 2021 15:38:23 +0000
Message-Id: <20211117153842.302159-20-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
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

The kernel allows heterogeneous systems where FEAT_SPE is not present on
all CPUs. This presents a challenge for KVM, as it will have to touch the
SPE registers when emulating SPE for a guest, and those accesses will cause
an undefined exception if SPE is not present on the CPU.

Avoid this situation by keeping a cpumask of CPUs that the VCPU is
allowed run on, which for SPE is the reunion of all CPUs that support
SPE, and refuse to run the VCPU on a CPU which is not part of the
cpumask.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arm.c              | 15 +++++++++++++++
 arch/arm64/kvm/spe.c              |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b3faed48914..96ce98f6135d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -405,6 +405,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	cpumask_var_t supported_cpus;
+	bool cpu_not_supported;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b2997b919be2..8a7c01d1df58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -351,6 +351,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
+	if (!zalloc_cpumask_var(&vcpu->arch.supported_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
@@ -378,6 +381,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
+	free_cpumask_var(vcpu->arch.supported_cpus);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
@@ -456,6 +460,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
+
+	if (!cpumask_empty(vcpu->arch.supported_cpus) &&
+	    !cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
+		vcpu->arch.cpu_not_supported = true;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -893,6 +901,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 7c6f94358cc1..f3863728bab6 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -40,5 +40,7 @@ int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
 	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT))
 		return -EINVAL;
 
+	cpumask_copy(vcpu->arch.supported_cpus, &supported_cpus);
+
 	return 0;
 }
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
