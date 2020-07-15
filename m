Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F96C433E5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 350892065F
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="T1zytl5B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 350892065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E38344B3EA;
	Wed, 15 Jul 2020 14:45:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5py4Q8DfGqtx; Wed, 15 Jul 2020 14:45:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4C04B3CB;
	Wed, 15 Jul 2020 14:45:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 773AF4B316
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wnNBZNdf-YCb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:14 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FA514B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:14 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id g6so1754282wmk.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=a2Ho+lepGR/y+cRuGpw9mRRd7tn63EYGoevk0RcWxuI=;
 b=T1zytl5BQ6TGZDgJ3AllM+YacCudT1mbAHCOwB4+WRw3ynrcopuS/FtecLG5tD7nTp
 ZYaElovK63x98UZo0BPe+WJmZRlQsKogosQdF+C+HQABSi1A0gphyrut+XTb4781laab
 6WxwV9BNEoabBFvrAGFWpjKxv9KABjVLzENYcYCVtlbrn6Xa540NwCE0agFWgSdLPXNj
 UEXuPeW0H7Ii/HDz6J9zjklFx90nfWpyunq0Co2Ni1KHDIFdAC7PmoMxw7ulNYDlicmM
 +LrVPD+YNJ3peo2CkqStFAE1KA0820TACSH68VT4O5vrOC+IkvwI3khtxaQxLt8UmqNO
 LpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=a2Ho+lepGR/y+cRuGpw9mRRd7tn63EYGoevk0RcWxuI=;
 b=kDyN625Ue10X1oLKPLxZPB+sV8AgC6JowlwTK8FEfFos9NBp1Lv0ykABIyrzBOCBjN
 GTiTXAEE6PwuhBzIcfNomrbAtRvxRHSskwGgccdRcTP5MbG5pnrL7fj6rnGlAjlaeSXq
 9mWXe8/l2an9riXPAFWOB72NKB3YEujOmMAwd3sQnFpyhWqHwmnmoYx3u71uLnC87/nc
 mkbbMsiiif26q4S0msQ4iDIw0e906PqQ0aOPiNOrpOzGLz7vzDGcD4W4JZ0bUQr95SPw
 wau/KsjntjWa25o7E96QIoKhBRdMmIusH/w7CobfCct3kCjDnvHVenMjHB9nk7t5q4qN
 V0SQ==
X-Gm-Message-State: AOAM530mwSEpAAp9czqFyloKU5wJi7vjKfxIZhuQgNB8O6iYjhlw5ApD
 Z35JpAcJD9Mogsr8Vj83U3L8SlgknrqmLBept2Mg81KN0ehMiE6keUalmqJSwRdh7APwXwthSf2
 +bnL6wBKpHAdeLTAH2Andlisg2OjVTtUeGbhVlVu0yEHZpoWjOlzom5OnkkoO+GliJxi8Yw==
X-Google-Smtp-Source: ABdhPJwO/Bo9UH033ZqioFrrxqlXl2z+/3jGpyipK0Ri32hIeu9VI8WqcyzzljWh9AeJ2S22V2ofRXtYwPE=
X-Received: by 2002:a05:6000:1c8:: with SMTP id t8mr766023wrx.73.1594838712926; 
 Wed, 15 Jul 2020 11:45:12 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:12 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-12-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 11/37] KVM: arm64: nVHE: Migrate hyp-init to SMCCC
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

To complete the transition to SMCCC, the hyp initialization is given a
function ID. This looks neater than comparing the hyp stub function IDs
to the page table physical address.

Some care is taken to only clobber x0-3 before the host context is saved
as only those registers can be clobbered accoring to SMCCC. Fortunately,
only a few acrobatics are needed. The possible new tpidr_el2 is moved to
the argument in x2 so that it can be stashed in tpidr_el2 early to free
up a scratch register. The page table configuration then makes use of
x0-2.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |  6 ---
 arch/arm64/kvm/Makefile            |  2 +-
 arch/arm64/kvm/arm.c               |  7 +++-
 arch/arm64/kvm/hyp.S               | 23 -----------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 63 +++++++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 +++
 6 files changed, 48 insertions(+), 59 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp.S

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5603d2f465eb..152c050e74a9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -493,12 +493,6 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
-u64 __kvm_call_hyp_init(phys_addr_t pgd_ptr,
-			unsigned long hyp_stack_ptr,
-			unsigned long vector_ptr,
-			unsigned long start_hyp,
-			unsigned long tpidr_el2);
-
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 99977c1972cc..1504c81fbf5d 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) += hyp/
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
-	 inject_fault.o regmap.o va_layout.o hyp.o handle_exit.o \
+	 inject_fault.o regmap.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 aarch32.o arch_timer.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c42c00c8141a..fe49203948d3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1265,6 +1265,7 @@ static void cpu_init_hyp_mode(void)
 	unsigned long vector_ptr;
 	unsigned long start_hyp;
 	unsigned long tpidr_el2;
+	struct arm_smccc_res res;
 
 	/* Switch from the HYP stub to our own HYP init vector */
 	__hyp_set_vectors(kvm_get_idmap_vector());
@@ -1290,8 +1291,10 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp_init(pgd_ptr, hyp_stack_ptr, vector_ptr, start_hyp,
-			    tpidr_el2);
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init),
+			  pgd_ptr, tpidr_el2, start_hyp, hyp_stack_ptr,
+			  vector_ptr, &res);
+	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
deleted file mode 100644
index 0891625c8648..000000000000
--- a/arch/arm64/kvm/hyp.S
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- */
-
-#include <linux/linkage.h>
-
-#include <asm/alternative.h>
-#include <asm/assembler.h>
-#include <asm/cpufeature.h>
-
-/*
- * u64 __kvm_call_hyp_init(phys_addr_t pgd_ptr,
- * 			   unsigned long hyp_stack_ptr,
- * 			   unsigned long vector_ptr,
- * 			   unsigned long start_hyp,
- * 			   unsigned long tpidr_el2);
- */
-SYM_FUNC_START(__kvm_call_hyp_init)
-	hvc	#0
-	ret
-SYM_FUNC_END(__kvm_call_hyp_init)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 029c51365d03..df2a7904a83b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -4,10 +4,12 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/linkage.h>
 
 #include <asm/assembler.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/sysreg.h>
@@ -43,31 +45,38 @@ __invalid:
 	b	.
 
 	/*
-	 * x0: HYP pgd
-	 * x1: HYP stack
-	 * x2: HYP vectors
+	 * x0: SMCCC function ID
+	 * x1: HYP pgd
+	 * x2: per-CPU offset
 	 * x3: __kvm_hyp_start HYP address
-	 * x4: per-CPU offset
+	 * x4: HYP stack
+	 * x5: HYP vectors
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
-	/* Set tpidr_el2 for use by HYP */
-	msr	tpidr_el2, x4
+	/* Set tpidr_el2 for use by HYP to free a register */
+	msr	tpidr_el2, x2
 
-	phys_to_ttbr x4, x0
+	mov	x2, #KVM_HOST_SMCCC_FUNC(__kvm_hyp_init)
+	cmp	x0, x2
+	b.eq	1f
+	mov	x0, #SMCCC_RET_NOT_SUPPORTED
+	eret
+
+1:	phys_to_ttbr x0, x1
 alternative_if ARM64_HAS_CNP
-	orr	x4, x4, #TTBR_CNP_BIT
+	orr	x0, x0, #TTBR_CNP_BIT
 alternative_else_nop_endif
-	msr	ttbr0_el2, x4
+	msr	ttbr0_el2, x0
 
-	mrs	x4, tcr_el1
-	mov_q	x5, TCR_EL2_MASK
-	and	x4, x4, x5
-	mov	x5, #TCR_EL2_RES1
-	orr	x4, x4, x5
+	mrs	x0, tcr_el1
+	mov_q	x1, TCR_EL2_MASK
+	and	x0, x0, x1
+	mov	x1, #TCR_EL2_RES1
+	orr	x0, x0, x1
 
 	/*
 	 * The ID map may be configured to use an extended virtual address
@@ -83,18 +92,18 @@ alternative_else_nop_endif
 	 *
 	 * So use the same T0SZ value we use for the ID map.
 	 */
-	ldr_l	x5, idmap_t0sz
-	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	ldr_l	x1, idmap_t0sz
+	bfi	x0, x1, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 
 	/*
 	 * Set the PS bits in TCR_EL2.
 	 */
-	tcr_compute_pa_size x4, #TCR_EL2_PS_SHIFT, x5, x6
+	tcr_compute_pa_size x0, #TCR_EL2_PS_SHIFT, x1, x2
 
-	msr	tcr_el2, x4
+	msr	tcr_el2, x0
 
-	mrs	x4, mair_el1
-	msr	mair_el2, x4
+	mrs	x0, mair_el1
+	msr	mair_el2, x0
 	isb
 
 	/* Invalidate the stale TLBs from Bootloader */
@@ -106,19 +115,19 @@ alternative_else_nop_endif
 	 * as well as the EE bit on BE. Drop the A flag since the compiler
 	 * is allowed to generate unaligned accesses.
 	 */
-	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
-CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
+	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
+CPU_BE(	orr	x0, x0, #SCTLR_ELx_EE)
 alternative_if ARM64_HAS_ADDRESS_AUTH
-	mov_q	x5, (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
+	mov_q	x1, (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
 		     SCTLR_ELx_ENDA | SCTLR_ELx_ENDB)
-	orr	x4, x4, x5
+	orr	x0, x0, x1
 alternative_else_nop_endif
-	msr	sctlr_el2, x4
+	msr	sctlr_el2, x0
 	isb
 
 	/* Set the stack and new vectors */
-	mov	sp, x1
-	msr	vbar_el2, x2
+	mov	sp, x4
+	msr	vbar_el2, x5
 
 	/* Leave the idmap posthaste and head over to __kvm_hyp_start */
 	br	x3
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7e7c074f8093..4e3634cdfde6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,12 @@ void __noreturn kvm_hyp_main(void)
 	host_vcpu->arch.flags = KVM_ARM64_HOST_VCPU_FLAGS;
 	host_vcpu->arch.workaround_flags = VCPU_WORKAROUND_2_FLAG;
 
+	/*
+	 * The first time entering the host is seen by the host as the return
+	 * of the initialization HVC so mark it as successful.
+	 */
+	smccc_set_retval(host_vcpu, SMCCC_RET_SUCCESS, 0, 0, 0);
+
 	while (true) {
 		u64 exit_code;
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
