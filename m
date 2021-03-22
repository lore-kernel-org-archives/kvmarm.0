Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC08C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 16:48:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 990C86191D
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 16:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 990C86191D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B1044B0A3;
	Mon, 22 Mar 2021 12:48:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gvM3W1KCAoQW; Mon, 22 Mar 2021 12:48:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD8C84B37B;
	Mon, 22 Mar 2021 12:48:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 612584B381
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 12:48:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZWANfG4fWATr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 12:48:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEA614B376
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 12:48:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 25402619A0;
 Mon, 22 Mar 2021 16:48:38 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lONjI-0037Ov-Bm; Mon, 22 Mar 2021 16:48:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: [PATCH 3/3] KVM: arm64: Drop the CPU_FTR_REG_HYP_COPY infrastructure
Date: Mon, 22 Mar 2021 16:48:28 +0000
Message-Id: <20210322164828.800662-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322164828.800662-1-maz@kernel.org>
References: <20210322164828.800662-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: qperret@google.com, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, tabba@google.com,
 ardb@kernel.org, mark.rutland@arm.com, dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 tabba@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

Now that the read_ctr macro has been specialised for nVHE,
the whole CPU_FTR_REG_HYP_COPY infrastrcture looks completely
overengineered.

Simplify it by populating the two u64 quantities (MMFR0 and 1)
that the hypervisor need.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h     |  1 -
 arch/arm64/include/asm/kvm_cpufeature.h | 26 -------------------------
 arch/arm64/include/asm/kvm_host.h       |  4 ----
 arch/arm64/include/asm/kvm_hyp.h        |  3 +++
 arch/arm64/kernel/cpufeature.c          | 13 -------------
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 ++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  5 ++---
 arch/arm64/kvm/sys_regs.c               | 23 ++--------------------
 8 files changed, 9 insertions(+), 72 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_cpufeature.h

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a85cea2cac57..61177bac49fa 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -607,7 +607,6 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
-int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
deleted file mode 100644
index ff302d15e840..000000000000
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2020 - Google LLC
- * Author: Quentin Perret <qperret@google.com>
- */
-
-#ifndef __ARM64_KVM_CPUFEATURE_H__
-#define __ARM64_KVM_CPUFEATURE_H__
-
-#include <asm/cpufeature.h>
-
-#include <linux/build_bug.h>
-
-#if defined(__KVM_NVHE_HYPERVISOR__)
-#define DECLARE_KVM_HYP_CPU_FTR_REG(name) extern struct arm64_ftr_reg name
-#define DEFINE_KVM_HYP_CPU_FTR_REG(name) struct arm64_ftr_reg name
-#else
-#define DECLARE_KVM_HYP_CPU_FTR_REG(name) extern struct arm64_ftr_reg kvm_nvhe_sym(name)
-#define DEFINE_KVM_HYP_CPU_FTR_REG(name) BUILD_BUG()
-#endif
-
-DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
-DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr0_el1);
-DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr1_el1);
-
-#endif
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4859c9de75d7..09979cdec28b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -740,13 +740,9 @@ void kvm_clr_pmu_events(u32 clr);
 
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
-
-void setup_kvm_el2_caps(void);
 #else
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
-
-static inline void setup_kvm_el2_caps(void) {}
 #endif
 
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index de40a565d7e5..8ef9d88826d4 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -116,4 +116,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
 
+extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
+
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6252476e4e73..066030717a4c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1154,18 +1154,6 @@ u64 read_sanitised_ftr_reg(u32 id)
 }
 EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
 
-int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst)
-{
-	struct arm64_ftr_reg *regp = get_arm64_ftr_reg(id);
-
-	if (!regp)
-		return -EINVAL;
-
-	*dst = *regp;
-
-	return 0;
-}
-
 #define read_sysreg_case(r)	\
 	case r:		val = read_sysreg_s(r); break;
 
@@ -2785,7 +2773,6 @@ void __init setup_cpu_features(void)
 
 	setup_system_capabilities();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
-	setup_kvm_el2_caps();
 
 	if (system_supports_32bit_el0())
 		setup_elf_hwcaps(compat_elf_hwcaps);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 17ad1b3a9530..706056013eb0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -5,16 +5,14 @@
  */
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_cpufeature.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
 /*
  * Copies of the host's CPU features registers holding sanitized values.
  */
-DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
-DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr0_el1);
-DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_id_aa64mmfr1_el1);
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 
 /*
  * nVHE copy of data structures tracking available CPU cores.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 808e2471091b..be1148e763d0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include <asm/kvm_cpufeature.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -74,8 +73,8 @@ static void prepare_host_vtcr(void)
 	u32 parange, phys_shift;
 	u64 mmfr0, mmfr1;
 
-	mmfr0 = arm64_ftr_reg_id_aa64mmfr0_el1.sys_val;
-	mmfr1 = arm64_ftr_reg_id_aa64mmfr1_el1.sys_val;
+	mmfr0 = id_aa64mmfr0_el1_sys_val;
+	mmfr1 = id_aa64mmfr1_el1_sys_val;
 
 	/* The host stage 2 is id-mapped, so use parange for T0SZ */
 	parange = kvm_get_parange(mmfr0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dfb3b4f9ca84..3093ac1b1099 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -21,7 +21,6 @@
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_cpufeature.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -2775,25 +2774,7 @@ void kvm_sys_reg_table_init(void)
 			break;
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
-}
-
-#define CPU_FTR_REG_HYP_COPY(id, name) \
-	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) }
-struct __ftr_reg_copy_entry {
-	u32			sys_id;
-	struct arm64_ftr_reg	*dst;
-} hyp_ftr_regs[] __initdata = {
-	CPU_FTR_REG_HYP_COPY(SYS_CTR_EL0, arm64_ftr_reg_ctrel0),
-	CPU_FTR_REG_HYP_COPY(SYS_ID_AA64MMFR0_EL1, arm64_ftr_reg_id_aa64mmfr0_el1),
-	CPU_FTR_REG_HYP_COPY(SYS_ID_AA64MMFR1_EL1, arm64_ftr_reg_id_aa64mmfr1_el1),
-};
 
-void __init setup_kvm_el2_caps(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(hyp_ftr_regs); i++) {
-		WARN(copy_ftr_reg(hyp_ftr_regs[i].sys_id, hyp_ftr_regs[i].dst),
-		     "%u feature register not found\n", hyp_ftr_regs[i].sys_id);
-	}
+	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 }
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
