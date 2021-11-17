Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE1DC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CA2B61AA5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0CA2B61AA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A31EF4B1AF;
	Wed, 17 Nov 2021 10:38:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4VZLDdPaci9f; Wed, 17 Nov 2021 10:38:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15D584B1C8;
	Wed, 17 Nov 2021 10:38:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 421714B1A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TeYyNxSoQOp6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:38:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9206D4B1BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:00 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 543651FB;
 Wed, 17 Nov 2021 07:38:00 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B90833F5A1;
 Wed, 17 Nov 2021 07:37:58 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 32/38] KVM: arm64: Allow guest to use physical
 timestamps if perfmon_capable()
Date: Wed, 17 Nov 2021 15:38:36 +0000
Message-Id: <20211117153842.302159-33-alexandru.elisei@arm.com>
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

The SPE driver allows userspace to use physical timestamps for records only
if the process if perfmon_capable(). Do the same for a virtual machine with
the SPE feature.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/asm/kvm_spe.h  |  9 +++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/hyp/nvhe/spe-sr.c  |  2 +-
 arch/arm64/kvm/hyp/vhe/spe-sr.c   |  2 +-
 arch/arm64/kvm/spe.c              | 17 +++++++++++++++++
 6 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3eef642d7bba..102e1c087798 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -158,6 +158,8 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	struct kvm_spe spe;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index ce92d5f1db19..7b87cf1eed37 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -21,6 +21,11 @@ struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrut number */
 };
 
+struct kvm_spe {
+	bool perfmon_capable;	/* Is the VM perfmon_capable()? */
+};
+
+void kvm_spe_init_vm(struct kvm *kvm);
 int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 
@@ -40,6 +45,10 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 struct kvm_vcpu_spe {
 };
 
+struct kvm_spe {
+};
+
+static inline void kvm_spe_init_vm(struct kvm *kvm) {}
 static inline int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a4f17f7bf943..5e166ffc6067 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -177,6 +177,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		goto out_free_stage2_pgd;
 
 	kvm_vgic_early_init(kvm);
+	kvm_spe_init_vm(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
diff --git a/arch/arm64/kvm/hyp/nvhe/spe-sr.c b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
index 46e47c9fd08f..4f6579daddb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
@@ -83,5 +83,5 @@ void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
-	write_sysreg_el2(0, SYS_PMSCR);
+	write_sysreg_el2(ctxt_sys_reg(guest_ctxt, PMSCR_EL2), SYS_PMSCR);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
index 00eab9e2ec60..f557ac64a1cc 100644
--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -21,7 +21,7 @@ void __spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
 
 	/* Disable profiling while the SPE context is being switched. */
 	pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
-	write_sysreg_el2(0, SYS_PMSCR);
+	write_sysreg_el2(__vcpu_sys_reg(vcpu, PMSCR_EL2), SYS_PMSCR);
 	isb();
 
 	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 9c0567dadff1..f5e9dc249e9a 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2021 - ARM Ltd
  */
 
+#include <linux/capability.h>
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
@@ -28,6 +29,19 @@ void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu)
 	mutex_unlock(&supported_cpus_lock);
 }
 
+void kvm_spe_init_vm(struct kvm *kvm)
+{
+	/*
+	 * Allow the guest to use the physical timer for timestamps only if the
+	 * VMM is perfmon_capable(), similar to what the SPE driver allows.
+	 *
+	 * CAP_PERFMON can be changed during the lifetime of the VM, so record
+	 * its value when the VM is created to avoid situations where only some
+	 * VCPUs allow physical timer timestamps, while others don't.
+	 */
+	kvm->arch.spe.perfmon_capable = perfmon_capable();
+}
+
 int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_supports_spe())
@@ -53,6 +67,9 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.spe.initialized)
 		return -EINVAL;
 
+	if (vcpu->kvm->arch.spe.perfmon_capable)
+		__vcpu_sys_reg(vcpu, PMSCR_EL2) = BIT(SYS_PMSCR_EL1_PCT_SHIFT);
+
 	return 0;
 }
 
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
