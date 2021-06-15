Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C35C48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A02C761474
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A02C761474
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55E7A4B0E2;
	Tue, 15 Jun 2021 09:40:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yReDKBsEfPth; Tue, 15 Jun 2021 09:40:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6E6D4B0E5;
	Tue, 15 Jun 2021 09:40:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE854AC78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id smlqi28aUj1P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:13 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6AA64B0FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:12 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 f9-20020a5d64c90000b029011a3c2a0337so5382597wri.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VeLACBAwCl5cQGDrEAN9ld1vrG7cP0tGCGNtCmEB3O8=;
 b=jyMWNGhjGunUjwrEyn4c4pxdcmrIqsS56IRSmRNkftcBroykABbWVwydgkd6sEXiOH
 NqW4rLnTaWhuCw94Dp/3a5ANRZ0S+7o4QmWqU738LMZrlUxzOxWWpS290Oc3uqL4S4T1
 WXBFIiRP28u1oujBKfpNxQVqT2vjWEACuh94nKfz69y7ratcUGG3dtsQ1hMKtRgrZ/ub
 C3oWCs4KzGxeMdgVRlFdpsnEmT5KZw9H5GihOhRZq7Yz8bMaOcutEfiGBcIPORo2Yz05
 1wu6jy/zBINhErsmC9k9yMbfpe7mnypNWFL4EBLUEQM4WQ6lQZdhYevFml15/vcwVysw
 44tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VeLACBAwCl5cQGDrEAN9ld1vrG7cP0tGCGNtCmEB3O8=;
 b=kpICHTChbmhRpqwPwpG/PTFPjQwSKclueZHXLhXLP+PyDSFMpPLAOC0Wwa95nZRief
 uBh3oNnC++jpJulfgLTsg2G8vki1TfzU6cakv0Vbopi6MZVpDKl9TiLF+w4/SVuC3ky5
 nSGXrQ4vXnq2+hjspYrWxqRUPfhtqPDluqjWHV+h9WOyNQ9WfN0dV9kj3sDQ2rRDNygW
 9bLo0UIwC+kUZI8hrv7ywapCPjMbgb3AiSkOsKR06NFJAoXAABKDMR/vDCU5+tiE42YA
 oiBpF7Yx6iXG/Bd80ZPeahLuQHw825eZgy9vW/+6AY302a+uvfYyDhlkJkV5lRsVUPsy
 QD3g==
X-Gm-Message-State: AOAM530iu4ASw7EERpk/6V0EKDdl69DI5KEomluV1YwqY0brj+tonYxP
 7YiPIMh8gSdkCr+keWR41F3VFRiHY84Z+AUhbGH13fT7jb0i/oL0h2H+Fx59xYvEswHIKRKXK/9
 XLhnUTRmCXyMTHYeqJIH0nRziFWOqAjVmeCSzfWp7WO/TB1SdFzdOA2gZG6fRI+yZDJY=
X-Google-Smtp-Source: ABdhPJxs79nP5pLQULpbyP4uAK3PHmLC4J7ABT7ACl1jwV7XcVRR1K2V3yaVMR2QePnxRLDHpLW0DRDsng==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:7918:: with SMTP id
 l24mr5298801wme.126.1623764411950; 
 Tue, 15 Jun 2021 06:40:11 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:46 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-10-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 09/13] KVM: arm64: Add trap handlers for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Add trap handlers for protected VMs. These are mainly for Sys64
and debug traps.

No functional change intended as these are not hooked in yet.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |   3 +
 arch/arm64/kvm/arm.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 475 +++++++++++++++++++++++++++++
 4 files changed, 482 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..7e81e42107e1 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -115,7 +115,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
 
+extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d71da6089822..363493395eba 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1751,8 +1751,11 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	void *addr = phys_to_virt(hyp_mem_base);
 	int ret;
 
+	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 
 	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
 	if (ret)
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 5df6193fc430..a23f417a0c20 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
new file mode 100644
index 000000000000..ab09ccc64fea
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -0,0 +1,475 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Google LLC
+ * Author: Fuad Tabba <tabba@google.com>
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
+
+#include <hyp/adjust_pc.h>
+
+#include "../../sys_regs.h"
+
+/*
+ * Copies of the host's CPU features registers holding sanitized values.
+ */
+u64 id_aa64pfr0_el1_sys_val;
+u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr2_el1_sys_val;
+
+/*
+ * Inject an undefined exception to the guest.
+ */
+static void inject_undef(struct kvm_vcpu *vcpu)
+{
+	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1 |
+			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+			     KVM_ARM64_PENDING_EXCEPTION);
+
+	__kvm_adjust_pc(vcpu);
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+}
+
+/*
+ * Accessor for undefined accesses.
+ */
+static bool undef_access(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	inject_undef(vcpu);
+	return false;
+}
+
+/*
+ * Accessors for feature registers.
+ *
+ * If access is allowed, set the regval to the protected VM's view of the
+ * register and return true.
+ * Otherwise, inject an undefined exception and return false.
+ */
+
+/* Accessor for ID_AA64PFR0_EL1. */
+static bool pvm_access_id_aa64pfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
+	u64 allow_mask = 0;
+	u64 set_mask = 0;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Only allow:
+	 * - Floating-point
+	 * - Advanced SIMD
+	 * - Data Independent Timing
+	 */
+	allow_mask |= FEATURE(ID_AA64PFR0_FP) |
+		      FEATURE(ID_AA64PFR0_ASIMD) |
+		      FEATURE(ID_AA64PFR0_DIT);
+
+	/* - ARMv8.4-RAS (not later than v1) */
+	if (id_aa64pfr0_el1_sys_val & FEATURE(ID_AA64PFR0_RAS))
+		set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_RAS),
+				       ID_AA64PFR0_RAS_V1);
+
+	/* - AArch64 guests */
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL0),
+			       ID_AA64PFR0_EL0_64BIT_ONLY) |
+		    FIELD_PREP(FEATURE(ID_AA64PFR0_EL1),
+			       ID_AA64PFR0_EL1_64BIT_ONLY) |
+		    FIELD_PREP(FEATURE(ID_AA64PFR0_EL2),
+			       ID_AA64PFR0_EL2_64BIT_ONLY);
+
+	/* (only set EL3 exception handling if EL3 exists) */
+	if (id_aa64pfr0_el1_sys_val & FEATURE(ID_AA64PFR0_EL3))
+		set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3),
+				       ID_AA64PFR0_EL3_64BIT_ONLY);
+
+	/* - Spectre and Meltdown mitigation */
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2),
+			       (u64)kvm->arch.pfr0_csv2);
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3),
+			       (u64)kvm->arch.pfr0_csv3);
+
+	p->regval = (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64PFR1_EL1. */
+static bool pvm_access_id_aa64pfr1(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	u64 allow_mask = 0;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Only allow:
+	 * - Branch Target Identification
+	 * - Speculative Store Bypassing
+	 */
+	allow_mask |= FEATURE(ID_AA64PFR1_BT) |
+		      FEATURE(ID_AA64PFR1_SSBS);
+
+	p->regval = id_aa64pfr1_el1_sys_val & allow_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64ZFR0_EL1. */
+static bool pvm_access_id_aa64zfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/* No support for Scalable Vectors */
+	p->regval = 0;
+	return true;
+}
+
+/* Accessor for ID_AA64DFR0_EL1. */
+static bool pvm_access_id_aa64dfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/* No support for debug, including breakpoints, and watchpoints */
+	p->regval = 0;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR0_EL1. */
+static bool pvm_access_id_aa64mmfr0(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 allow_mask = 0;
+	u64 set_mask = 0;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Only allow:
+	 * - Mixed-endian
+	 * - Distinction between Secure and Non-secure Memory
+	 * - Mixed-endian at EL0 only
+	 * - Non-context synchronizing exception entry and exit
+	 */
+	allow_mask |= FEATURE(ID_AA64MMFR0_BIGENDEL) |
+		      FEATURE(ID_AA64MMFR0_SNSMEM) |
+		      FEATURE(ID_AA64MMFR0_BIGENDEL0) |
+		      FEATURE(ID_AA64MMFR0_EXS);
+
+	/*
+	 * - 40-bit IPA
+	 * - 16-bit ASID
+	 * - 4KB granule
+	 */
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE),
+			       ID_AA64MMFR0_PARANGE_40) |
+		    FIELD_PREP(FEATURE(ID_AA64MMFR0_ASID),
+			       ID_AA64MMFR0_ASID_16) |
+		    FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64),
+			       ID_AA64MMFR0_TGRAN64_NI);
+
+	p->regval = (id_aa64mmfr0_el1_sys_val & allow_mask) | set_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR1_EL1. */
+static bool pvm_access_id_aa64mmfr1(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 allow_mask = 0;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Only allow:
+	 * - Hardware translation table updates to Access flag and Dirty state
+	 * - Number of VMID bits from CPU
+	 * - Hierarchical Permission Disables
+	 * - Privileged Access Never
+	 * - SError interrupt exceptions from speculative reads
+	 * - Enhanced Translation Synchronization
+	 */
+	allow_mask |= FEATURE(ID_AA64MMFR1_HADBS) |
+		      FEATURE(ID_AA64MMFR1_VMIDBITS) |
+		      FEATURE(ID_AA64MMFR1_HPD) |
+		      FEATURE(ID_AA64MMFR1_PAN) |
+		      FEATURE(ID_AA64MMFR1_SPECSEI) |
+		      FEATURE(ID_AA64MMFR1_ETS);
+
+	p->regval = id_aa64mmfr1_el1_sys_val & allow_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR2_EL1. */
+static bool pvm_access_id_aa64mmfr2(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 allow_mask = 0;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Only allow:
+	 * - Common not Private translations
+	 * - User Access Override
+	 * - IESB bit in the SCTLR_ELx registers
+	 * - Unaligned single-copy atomicity and atomic functions
+	 * - ESR_ELx.EC value on an exception by read access to feature ID space
+	 * - TTL field in address operations.
+	 * - Break-before-make sequences when changing translation block size
+	 * - E0PDx mechanism
+	 */
+	allow_mask |= FEATURE(ID_AA64MMFR2_CNP) |
+		      FEATURE(ID_AA64MMFR2_UAO) |
+		      FEATURE(ID_AA64MMFR2_IESB) |
+		      FEATURE(ID_AA64MMFR2_AT) |
+		      FEATURE(ID_AA64MMFR2_IDS) |
+		      FEATURE(ID_AA64MMFR2_TTL) |
+		      FEATURE(ID_AA64MMFR2_BBM) |
+		      FEATURE(ID_AA64MMFR2_E0PD);
+
+	p->regval = id_aa64mmfr2_el1_sys_val & allow_mask;
+	return true;
+}
+
+/*
+ * Accessor for AArch32 Processor Feature Registers.
+ *
+ * The value of these registers is "unknown" according to the spec if AArch32
+ * isn't supported.
+ */
+static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
+				  struct sys_reg_params *p,
+				  const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/* Use 0 for architecturally "unknown" values. */
+	p->regval = 0;
+	return true;
+}
+
+/* Mark the specified system register as an AArch32 feature register. */
+#define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
+
+/* Mark the specified system register as not being handled in hyp. */
+#define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
+
+/*
+ * Architected system registers.
+ * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
+ *
+ * NOTE: Anything not explicitly listed here will be *restricted by default*,
+ * i.e., it will lead to injecting an exception into the guest.
+ */
+static const struct sys_reg_desc pvm_sys_reg_descs[] = {
+	/* Cache maintenance by set/way operations are restricted. */
+
+	/* Debug and Trace Registers are all restricted */
+
+	/* AArch64 mappings of the AArch32 ID registers */
+	/* CRm=1 */
+	AARCH32(SYS_ID_PFR0_EL1),
+	AARCH32(SYS_ID_PFR1_EL1),
+	AARCH32(SYS_ID_DFR0_EL1),
+	AARCH32(SYS_ID_AFR0_EL1),
+	AARCH32(SYS_ID_MMFR0_EL1),
+	AARCH32(SYS_ID_MMFR1_EL1),
+	AARCH32(SYS_ID_MMFR2_EL1),
+	AARCH32(SYS_ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	AARCH32(SYS_ID_ISAR0_EL1),
+	AARCH32(SYS_ID_ISAR1_EL1),
+	AARCH32(SYS_ID_ISAR2_EL1),
+	AARCH32(SYS_ID_ISAR3_EL1),
+	AARCH32(SYS_ID_ISAR4_EL1),
+	AARCH32(SYS_ID_ISAR5_EL1),
+	AARCH32(SYS_ID_MMFR4_EL1),
+	AARCH32(SYS_ID_ISAR6_EL1),
+
+	/* CRm=3 */
+	AARCH32(SYS_MVFR0_EL1),
+	AARCH32(SYS_MVFR1_EL1),
+	AARCH32(SYS_MVFR2_EL1),
+	AARCH32(SYS_ID_PFR2_EL1),
+	AARCH32(SYS_ID_DFR1_EL1),
+	AARCH32(SYS_ID_MMFR5_EL1),
+
+	/* AArch64 ID registers */
+	/* CRm=4 */
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = pvm_access_id_aa64pfr0 },
+	{ SYS_DESC(SYS_ID_AA64PFR1_EL1), .access = pvm_access_id_aa64pfr1 },
+	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), .access = pvm_access_id_aa64zfr0 },
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = pvm_access_id_aa64dfr0 },
+	HOST_HANDLED(SYS_ID_AA64DFR1_EL1),
+	HOST_HANDLED(SYS_ID_AA64AFR0_EL1),
+	HOST_HANDLED(SYS_ID_AA64AFR1_EL1),
+	HOST_HANDLED(SYS_ID_AA64ISAR0_EL1),
+	HOST_HANDLED(SYS_ID_AA64ISAR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR0_EL1), .access = pvm_access_id_aa64mmfr0 },
+	{ SYS_DESC(SYS_ID_AA64MMFR1_EL1), .access = pvm_access_id_aa64mmfr1 },
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1), .access = pvm_access_id_aa64mmfr2 },
+
+	HOST_HANDLED(SYS_SCTLR_EL1),
+	HOST_HANDLED(SYS_ACTLR_EL1),
+	HOST_HANDLED(SYS_CPACR_EL1),
+
+	HOST_HANDLED(SYS_RGSR_EL1),
+	HOST_HANDLED(SYS_GCR_EL1),
+
+	/* Scalable Vector Registers are restricted. */
+
+	HOST_HANDLED(SYS_TTBR0_EL1),
+	HOST_HANDLED(SYS_TTBR1_EL1),
+	HOST_HANDLED(SYS_TCR_EL1),
+
+	HOST_HANDLED(SYS_APIAKEYLO_EL1),
+	HOST_HANDLED(SYS_APIAKEYHI_EL1),
+	HOST_HANDLED(SYS_APIBKEYLO_EL1),
+	HOST_HANDLED(SYS_APIBKEYHI_EL1),
+	HOST_HANDLED(SYS_APDAKEYLO_EL1),
+	HOST_HANDLED(SYS_APDAKEYHI_EL1),
+	HOST_HANDLED(SYS_APDBKEYLO_EL1),
+	HOST_HANDLED(SYS_APDBKEYHI_EL1),
+	HOST_HANDLED(SYS_APGAKEYLO_EL1),
+	HOST_HANDLED(SYS_APGAKEYHI_EL1),
+
+	HOST_HANDLED(SYS_AFSR0_EL1),
+	HOST_HANDLED(SYS_AFSR1_EL1),
+	HOST_HANDLED(SYS_ESR_EL1),
+
+	HOST_HANDLED(SYS_ERRIDR_EL1),
+	HOST_HANDLED(SYS_ERRSELR_EL1),
+	HOST_HANDLED(SYS_ERXFR_EL1),
+	HOST_HANDLED(SYS_ERXCTLR_EL1),
+	HOST_HANDLED(SYS_ERXSTATUS_EL1),
+	HOST_HANDLED(SYS_ERXADDR_EL1),
+	HOST_HANDLED(SYS_ERXMISC0_EL1),
+	HOST_HANDLED(SYS_ERXMISC1_EL1),
+
+	HOST_HANDLED(SYS_TFSR_EL1),
+	HOST_HANDLED(SYS_TFSRE0_EL1),
+
+	HOST_HANDLED(SYS_FAR_EL1),
+	HOST_HANDLED(SYS_PAR_EL1),
+
+	/* Performance Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_MAIR_EL1),
+	HOST_HANDLED(SYS_AMAIR_EL1),
+
+	/* Limited Ordering Regions Registers are restricted. */
+
+	HOST_HANDLED(SYS_VBAR_EL1),
+	HOST_HANDLED(SYS_DISR_EL1),
+
+	/* GIC CPU Interface registers are restricted. */
+
+	HOST_HANDLED(SYS_CONTEXTIDR_EL1),
+	HOST_HANDLED(SYS_TPIDR_EL1),
+
+	HOST_HANDLED(SYS_SCXTNUM_EL1),
+
+	HOST_HANDLED(SYS_CNTKCTL_EL1),
+
+	HOST_HANDLED(SYS_CCSIDR_EL1),
+	HOST_HANDLED(SYS_CLIDR_EL1),
+	HOST_HANDLED(SYS_CSSELR_EL1),
+	HOST_HANDLED(SYS_CTR_EL0),
+
+	/* Performance Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_TPIDR_EL0),
+	HOST_HANDLED(SYS_TPIDRRO_EL0),
+
+	HOST_HANDLED(SYS_SCXTNUM_EL0),
+
+	/* Activity Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_CNTP_TVAL_EL0),
+	HOST_HANDLED(SYS_CNTP_CTL_EL0),
+	HOST_HANDLED(SYS_CNTP_CVAL_EL0),
+
+	/* Performance Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_DACR32_EL2),
+	HOST_HANDLED(SYS_IFSR32_EL2),
+	HOST_HANDLED(SYS_FPEXC32_EL2),
+};
+
+/*
+ * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu)
+{
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	unsigned long esr = kvm_vcpu_get_esr(vcpu);
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+
+	params = esr_sys64_to_params(esr);
+	params.regval = vcpu_get_reg(vcpu, Rt);
+
+	r = find_reg(&params, pvm_sys_reg_descs, ARRAY_SIZE(pvm_sys_reg_descs));
+
+	/* Undefined access (RESTRICTED). */
+	if (r == NULL) {
+		inject_undef(vcpu);
+		return 1;
+	}
+
+	/* Handled by the host (HOST_HANDLED) */
+	if (r->access == NULL)
+		return 0;
+
+	/* Handled by hyp: skip instruction if instructed to do so. */
+	if (r->access(vcpu, &params, r))
+		__kvm_skip_instr(vcpu);
+
+	vcpu_set_reg(vcpu, Rt, params.regval);
+	return 1;
+}
+
+/*
+ * Handler for protected VM restricted exceptions.
+ *
+ * Inject an undefined exception into the guest and return 1 to indicate that
+ * it was handled.
+ */
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu)
+{
+	inject_undef(vcpu);
+	return 1;
+}
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
