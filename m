Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4EBC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68E3320857
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="hHbmDkEy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68E3320857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 256364B539;
	Thu, 25 Jun 2020 09:14:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q25lfFDR3hCo; Thu, 25 Jun 2020 09:14:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A85F74B544;
	Thu, 25 Jun 2020 09:14:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FB24B4ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zOrg5acLXyIW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:38 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D3184B4F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:38 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id h5so5794441wrc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=pxpH4jpQXXXoBiK6Le2IRR+lOB1xGedSH4AkLw3y4po=;
 b=hHbmDkEyPFKO/drkrTC2Q9wbItcK+FWBwdlM4DUyC0rVXeXQL2tNo7emTd2nWq0ESD
 NOgFeNTq0+4yf0at64xAtMJN04HvwOPgChi362ZQMR/A4Zj6/o2yswkF89e9D8oJ6PmZ
 m88YOryyUsl2XHiAv1JvIZlKaf34rvz4UWr9CPHuHoFoVOg9ziTHH7SjRecKzVwLwlok
 Go8pI8y4AFFdRs75yqeiobMuTXJ3W/yZzdOALr4tmR6c694XOIP5/K1Ml+tXmouVan0+
 r+k0R/JdCtK1e91SpU+9BpKfpsk9dRQ49+hgUDgjvRkTfCBxXdtPevO7eElzdWIMGOFe
 UnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pxpH4jpQXXXoBiK6Le2IRR+lOB1xGedSH4AkLw3y4po=;
 b=RYWkTZUplQ1f/gFaXOL/xtjWOoZlx2a3DxrXLXBsS5Josyyc1KEY5pBMjFxQm0JksG
 Uv/mrs92hT7vdtm6u+PYDnaTgq6NYt1+jHZPYBAr2FcZTd6BVRu77Oxk3yIPm0zEFOe1
 1ZDPLRGLm1+IxrPYNZn4HmNaNQ8ge5lhVtfXmQF1VeHvPaCLdZVlqYZbhbF/D0rGs/fJ
 aI/2G9OVAHgHywbgSCcooKaDvSwt/x3MysIzHCU03bwoZ/8bqlPHHiPkrD38wcrcUb/d
 LtNTLZz/rxdK8HThqnqvtTic663xkSvWJlyu09Pye2E9PJZcPPyFxLGQUuLmI5kN8nHs
 s36w==
X-Gm-Message-State: AOAM532jKdPGiI7xTMxvSoOxWIslwS/7DsBlSnaD9bipdIrD0kwHL+kU
 6245IbvlOggKLCnOLw85YdWZ3w==
X-Google-Smtp-Source: ABdhPJxIAxslQf40rp0/zDNWgHggXkNwUFfbwbjVzcFayV61flcycTiscUwgeFoEcVxoW57hbRWdLg==
X-Received: by 2002:adf:fe4b:: with SMTP id m11mr36043789wrs.36.1593090877315; 
 Thu, 25 Jun 2020 06:14:37 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id e25sm32108639wrc.69.2020.06.25.06.14.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:36 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 07/15] arm64: kvm: Move hyp-init.S to nVHE
Date: Thu, 25 Jun 2020 14:14:12 +0100
Message-Id: <20200625131420.71444-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Andrew Scull <ascull@google.com>

hyp-init.S contains the identity mapped initialisation code for the
non-VHE code that runs at EL2. It is only used for non-VHE.

Adjust code that calls into this to use the prefixed symbol name.

Signed-off-by: Andrew Scull <ascull@google.com>

[David: pass idmap_t0sz as an argument]
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h         |  5 ++---
 arch/arm64/kernel/image-vars.h           |  6 +++---
 arch/arm64/kvm/Makefile                  |  2 +-
 arch/arm64/kvm/arm.c                     |  2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile         |  2 +-
 arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S | 24 ++++++++++++------------
 6 files changed, 20 insertions(+), 21 deletions(-)
 rename arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S (91%)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6026cbd204ae..3476abb046e3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -78,10 +78,9 @@
 struct kvm;
 struct kvm_vcpu;
 
-extern char __kvm_hyp_init[];
-extern char __kvm_hyp_init_end[];
-
+DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
+#define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index f28da486b75a..c3643df22a9b 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,9 +71,6 @@ KVM_NVHE_ALIAS(__guest_exit);
 KVM_NVHE_ALIAS(abort_guest_exit_end);
 KVM_NVHE_ALIAS(abort_guest_exit_start);
 
-/* Symbols defined in hyp-init.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__kvm_handle_stub_hvc);
-
 /* Symbols defined in switch.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_vcpu_run_nvhe);
 KVM_NVHE_ALIAS(hyp_panic);
@@ -113,6 +110,9 @@ KVM_NVHE_ALIAS(kimage_voffset);
 /* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
 KVM_NVHE_ALIAS(panic);
 
+/* Vectors installed by hyp-init on reset HVC. */
+KVM_NVHE_ALIAS(__hyp_stub_vectors);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8d3d9513cbfe..152d8845a1a2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) += hyp/
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
-	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
+	 inject_fault.o regmap.o va_layout.o hyp.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 aarch32.o arch_timer.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 34b551385153..2e20b4bbf4e8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1298,7 +1298,7 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
+	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2, idmap_t0sz);
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 79eb8eed96a1..bf2d8dea5400 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := ../hyp-entry.o
+obj-y := hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
similarity index 91%
rename from arch/arm64/kvm/hyp-init.S
rename to arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 6e6ed5581eed..7bb75acbede0 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -47,23 +47,24 @@ __invalid:
 	 * x1: HYP stack
 	 * x2: HYP vectors
 	 * x3: per-CPU offset
+	 * x4: idmap_t0sz
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
-	phys_to_ttbr x4, x0
+	phys_to_ttbr x5, x0
 alternative_if ARM64_HAS_CNP
-	orr	x4, x4, #TTBR_CNP_BIT
+	orr	x5, x5, #TTBR_CNP_BIT
 alternative_else_nop_endif
-	msr	ttbr0_el2, x4
+	msr	ttbr0_el2, x5
 
-	mrs	x4, tcr_el1
-	mov_q	x5, TCR_EL2_MASK
-	and	x4, x4, x5
-	mov	x5, #TCR_EL2_RES1
-	orr	x4, x4, x5
+	mrs	x5, tcr_el1
+	mov_q	x6, TCR_EL2_MASK
+	and	x5, x5, x6
+	mov	x6, #TCR_EL2_RES1
+	orr	x5, x5, x6
 
 	/*
 	 * The ID map may be configured to use an extended virtual address
@@ -79,15 +80,14 @@ alternative_else_nop_endif
 	 *
 	 * So use the same T0SZ value we use for the ID map.
 	 */
-	ldr_l	x5, idmap_t0sz
-	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	bfi	x5, x4, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 
 	/*
 	 * Set the PS bits in TCR_EL2.
 	 */
-	tcr_compute_pa_size x4, #TCR_EL2_PS_SHIFT, x5, x6
+	tcr_compute_pa_size x5, #TCR_EL2_PS_SHIFT, x4, x6
 
-	msr	tcr_el2, x4
+	msr	tcr_el2, x5
 
 	mrs	x4, mair_el1
 	msr	mair_el2, x4
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
