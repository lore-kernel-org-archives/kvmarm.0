Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33C7C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7AF0821D91
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="P8DIwxZK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF0821D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 288E24B387;
	Tue, 15 Sep 2020 06:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cFSNhhx9JV18; Tue, 15 Sep 2020 06:47:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D31A4B32C;
	Tue, 15 Sep 2020 06:47:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0035F4B37D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3q3J0lGg3syN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:29 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CED894B36A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:29 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id l67so2995187ybb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=mafVxDcrCwGZ32vUVjqZWh+uxGRgnqRROBAdTDzh6ec=;
 b=P8DIwxZKN19Z2G9g5Qq66UtIMtLGNzu1WsLbGrPkRiSxFszQzTAl4HynU4DozFERbl
 defc+u831XCH8dovDK81zGf4By93IL/WngJeMnVSEmYadTXTn3RoccQs7pidz+Y7qyzb
 KCOc4xFztR2XpKathGoErvis1VqvXikxxn8d0P2szarbzpLZ2dayBa42xoH25b2l4xUF
 CN8dzT9JICgOmPdsuWTryPBRXzOApka9oXIIhMqS9eYUwrmpnBtQXGK7hFWdPwA6cDhj
 pJROsYM/I4vkEbbdJc+odjx4Jrze1AB+ZRH5hexsoiv0Vp2uuQjwxfusHC6jY8FCR3X6
 AKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mafVxDcrCwGZ32vUVjqZWh+uxGRgnqRROBAdTDzh6ec=;
 b=rfMNeHuRliTopgeCs9xEDrIx1BpvW7g+3hApMVQskBUGkG6Z8ISVHrGBUPJTLmb0J+
 IQZsm1YLCc1p9Zil1i5h2JoOonLudYIVFdmZUE2eH1PWma19PwASpDfp50VVEO7DMDCk
 CcRlLrHHq4BjBMY6CTGzqOICqZuBrrWT+5lAt5gE5+v07TLBqQO9vA8Dxz1QuAxFZeBY
 1ISlW8CJBK/+cpDMM7VWB1OGfRBGb1+2OBOhhK+qN9cJqOz5jejg3pzLU2AevRLTqN0u
 omwwwY1SCvZfWx2X/quZVgXr1Y1pALitjZyOgQ92sFcxYXRG96aZdp4L18q8Eepo4Pb/
 Wejg==
X-Gm-Message-State: AOAM532d2xd5S9gtuY5dz/eAn4Hq1nBCJDYP/56AkyZ28sHbNnKe4qjo
 yAWllEqgCtn4EDrMkli0USjf5PTQfkesovgqNNWpRnDJqQAe8axNZRpJaOwH2ItvcT7m40gPk00
 jz317m3dVTJmqf/wELSsOV78TEQ+3yOZl1fAJm5/11kDYcuxWP9L8UcTJRVm/mYI47cmZ/g==
X-Google-Smtp-Source: ABdhPJw0I+Do0ibTgMpuLk+6frXADSygGV+nHNUWHxfz8C7+d1pxCAm2+xwDvVAH+WO1JgoWpr1oXbSyiWk=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a5b:804:: with SMTP id
 x4mr27119263ybp.404.1600166849129; 
 Tue, 15 Sep 2020 03:47:29 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:42 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-19-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 18/19] KVM: arm64: nVHE: Migrate hyp-init to SMCCC
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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
 arch/arm64/include/asm/kvm_host.h  |  5 ---
 arch/arm64/kvm/Makefile            |  2 +-
 arch/arm64/kvm/arm.c               |  5 ++-
 arch/arm64/kvm/hyp.S               | 22 ----------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 66 +++++++++++++++++-------------
 5 files changed, 43 insertions(+), 57 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp.S

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 82c941cf8890..ef0325c42ca0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -480,11 +480,6 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
-u64 __kvm_call_hyp_init(phys_addr_t pgd_ptr,
-			unsigned long hyp_stack_ptr,
-			unsigned long vector_ptr,
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
index 49aa08bd26de..c074d9824d54 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1264,6 +1264,7 @@ static void cpu_init_hyp_mode(void)
 	unsigned long hyp_stack_ptr;
 	unsigned long vector_ptr;
 	unsigned long tpidr_el2;
+	struct arm_smccc_res res;
 
 	/* Switch from the HYP stub to our own HYP init vector */
 	__hyp_set_vectors(kvm_get_idmap_vector());
@@ -1288,7 +1289,9 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp_init(pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init),
+			  pgd_ptr, tpidr_el2, hyp_stack_ptr, vector_ptr, &res);
+	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
deleted file mode 100644
index 12aa426f7559..000000000000
--- a/arch/arm64/kvm/hyp.S
+++ /dev/null
@@ -1,22 +0,0 @@
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
- * 			   unsigned long tpidr_el2);
- */
-SYM_FUNC_START(__kvm_call_hyp_init)
-	hvc	#0
-	ret
-SYM_FUNC_END(__kvm_call_hyp_init)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index abe885e26fe2..47224dc62c51 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -4,11 +4,13 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/linkage.h>
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/sysreg.h>
@@ -44,27 +46,37 @@ __invalid:
 	b	.
 
 	/*
-	 * x0: HYP pgd
-	 * x1: HYP stack
-	 * x2: HYP vectors
-	 * x3: per-CPU offset
+	 * x0: SMCCC function ID
+	 * x1: HYP pgd
+	 * x2: per-CPU offset
+	 * x3: HYP stack
+	 * x4: HYP vectors
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
-	phys_to_ttbr x4, x0
+	/* Set tpidr_el2 for use by HYP to free a register */
+	msr	tpidr_el2, x2
+
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
@@ -80,18 +92,18 @@ alternative_else_nop_endif
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
@@ -103,24 +115,22 @@ alternative_else_nop_endif
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
-
-	/* Set tpidr_el2 for use by HYP */
-	msr	tpidr_el2, x3
+	mov	sp, x3
+	msr	vbar_el2, x4
 
 	/* Hello, World! */
+	mov	x0, #SMCCC_RET_SUCCESS
 	eret
 SYM_CODE_END(__kvm_hyp_init)
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
