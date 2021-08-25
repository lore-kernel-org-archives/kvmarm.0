Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87578C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D7686115A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D7686115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D656F4B265;
	Wed, 25 Aug 2021 12:19:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ytju64LTU790; Wed, 25 Aug 2021 12:19:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB8DE4B2E6;
	Wed, 25 Aug 2021 12:18:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9654B264
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lZwmda4kJW8r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D9A4B25A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A85F11474;
 Wed, 25 Aug 2021 09:18:05 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5985A3F66F;
 Wed, 25 Aug 2021 09:18:04 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 33/39] KVM: arm64: Allow guest to use physical
 timestamps if perfmon_capable()
Date: Wed, 25 Aug 2021 17:18:09 +0100
Message-Id: <20210825161815.266051-34-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
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
 arch/arm64/include/asm/kvm_spe.h  |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/spe-sr.c  |  2 +-
 arch/arm64/kvm/hyp/vhe/spe-sr.c   |  2 +-
 arch/arm64/kvm/spe.c              | 14 ++++++++++++++
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 66f0b999cb5f..cc46f1406196 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -157,6 +157,8 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	struct kvm_spe spe;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 6b8d4cf2cd37..272f1eec64f2 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -21,6 +21,10 @@ struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrut number */
 };
 
+struct kvm_spe {
+	bool perfmon_capable;	/* Is the VM perfmon_capable()? */
+};
+
 void kvm_spe_init_supported_cpus(void);
 void kvm_spe_vm_init(struct kvm *kvm);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
@@ -41,6 +45,9 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 struct kvm_vcpu_spe {
 };
 
+struct kvm_spe {
+};
+
 static inline void kvm_spe_init_supported_cpus(void) {}
 static inline void kvm_spe_vm_init(struct kvm *kvm) {}
 static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
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
index 711736c49f63..054bb16bbd79 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2021 - ARM Ltd
  */
 
+#include <linux/capability.h>
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_pmu.h>
@@ -29,6 +30,16 @@ void kvm_spe_vm_init(struct kvm *kvm)
 {
 	/* Set supported_cpus if it isn't already initialized. */
 	kvm_spe_init_supported_cpus();
+
+	/*
+	 * Allow the guest to use the physical timer for timestamps only if the
+	 * VMM is perfmon_capable(), similar to what the SPE driver allows.
+	 *
+	 * CAP_PERFMON can be changed during the lifetime of the VM, so record
+	 * its value when the VM is created to avoid situations where only some
+	 * VCPUs allow physical timer timestamps, while others don't.
+	 */
+	kvm->arch.spe.perfmon_capable = perfmon_capable();
 }
 
 static int kvm_spe_check_supported_cpus(struct kvm_vcpu *vcpu)
@@ -54,6 +65,9 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.spe.initialized)
 		return -EPERM;
 
+	if (vcpu->kvm->arch.spe.perfmon_capable)
+		__vcpu_sys_reg(vcpu, PMSCR_EL2) = BIT(SYS_PMSCR_EL1_PCT_SHIFT);
+
 	return 0;
 }
 
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
