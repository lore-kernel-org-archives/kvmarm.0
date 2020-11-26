Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BF3C64E8A
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BAB3221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="o0AAoClP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BAB3221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D164C07C;
	Thu, 26 Nov 2020 10:54:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Fga-wXBaieO; Thu, 26 Nov 2020 10:54:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0E14BCDF;
	Thu, 26 Nov 2020 10:54:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A8AD4C066
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l4+jv+NGluHn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:39 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C69934BCEF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:38 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id m6so2631565wrg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=nvwTQNNZtO31OTVc289HlSj6IfrKQr68R/EeTn2wLTs=;
 b=o0AAoClPZbIUCVP2EtKok8cJTqxeoawIX1Wd9YfAPAFuA8F2TCi0PItChvL7vxjiHn
 OzZRwBQa+aU0FdKY+sA25K+2IbuMBayARYNwK/9gvWgxptk9OmcmiJIR+vVVrO9ThZh9
 MKYVqN+GcVdZuckTXr5oXkGhuIwsTxuanyrRQdDvDnNhk5iKBhRIoZaucAhhhZ+X+frM
 X5igaqE6Fl7XA5qPJaifUsszlOFo2CxdUEtAAYG8XJoT2vcIa6i+cHrTU9GqVuUg6p1g
 2EyD4CkdHEJZdYUO6VpHejlHPxASWrPYQuM7CngFoGZx/48UOBCIZpOZ/HnYkYsyX2Yh
 P5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=nvwTQNNZtO31OTVc289HlSj6IfrKQr68R/EeTn2wLTs=;
 b=HVuEICaSMTsk8Nqj5zqbjV9LT8HkVG3ycnEiXX/v0ND4ZmgsiKsbdMZmDwE22CrdZC
 X3BQ4R3q2pIvpjFGBOgRepRduGfjKr6vs9VazoZwERLsUSvdAdvqvNU40zhyVzkDxHyr
 jHqfVVynTu5getl7FIn/xKnXUycsC/c5GWpsw15P5bdi4RdyxJr4l1gl1lMP73sS4aZY
 AOEZPWX4S0MwCSq4YlXxiZBB2ueeYGXVkwGVItozYfQtveujYpF1WIIPkXKFn+yBK7FC
 t4O4AIddRq08wGxs8z577qOwtmsM/SOL8/QZFOBJTcxdyM9NoZQnPqZ1ZiLMuFIA55j8
 lzsg==
X-Gm-Message-State: AOAM533inmHQcT/UewBF+IOS8fYjsXVoO7Nsk6mGExYJyiKh7cqk9rSP
 YE7b2W9GrLkxUFfpwrK9JvCkeJXFVpe5sOpM
X-Google-Smtp-Source: ABdhPJwMxH9eVvxny0iYRpWwzhIl3VMG97fRb8jH6Zk997PRx8L3RSpUnmqsMsequCJqtSeaS0bqXQ==
X-Received: by 2002:adf:e502:: with SMTP id j2mr4647857wrm.73.1606406077218;
 Thu, 26 Nov 2020 07:54:37 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id t20sm9754665wmi.3.2020.11.26.07.54.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:36 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 05/23] arm64: Extract parts of el2_setup into a macro
Date: Thu, 26 Nov 2020 15:54:03 +0000
Message-Id: <20201126155421.14901-6-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

When the a CPU is booted in EL2, the kernel checks for VHE support and
initializes the CPU core accordingly. For nVHE it also installs the stub
vectors and drops down to EL1.

Once KVM gains the ability to boot cores without going through the
kernel entry point, it will need to initialize the CPU the same way.
Extract the relevant bits of el2_setup into an init_el2_state macro
with an argument specifying whether to initialize for VHE or nVHE.

No functional change. Size of el2_setup increased by 148 bytes due
to duplication.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 182 +++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S           | 144 +++--------------------
 2 files changed, 198 insertions(+), 128 deletions(-)
 create mode 100644 arch/arm64/include/asm/el2_setup.h

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
new file mode 100644
index 000000000000..b6cfd8aa2a81
--- /dev/null
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -0,0 +1,182 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#ifndef __ARM_KVM_INIT_H__
+#define __ARM_KVM_INIT_H__
+
+#ifndef __ASSEMBLY__
+#error Assembly-only header
+#endif
+
+#include <asm/kvm_arm.h>
+#include <asm/ptrace.h>
+#include <asm/sysreg.h>
+#include <linux/irqchip/arm-gic-v3.h>
+
+.macro __init_el2_sctlr
+	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
+	msr	sctlr_el2, x0
+	isb
+.endm
+
+/*
+ * Allow Non-secure EL1 and EL0 to access physical timer and counter.
+ * This is not necessary for VHE, since the host kernel runs in EL2,
+ * and EL0 accesses are configured in the later stage of boot process.
+ * Note that when HCR_EL2.E2H == 1, CNTHCTL_EL2 has the same bit layout
+ * as CNTKCTL_EL1, and CNTKCTL_EL1 accessing instructions are redefined
+ * to access CNTHCTL_EL2. This allows the kernel designed to run at EL1
+ * to transparently mess with the EL0 bits via CNTKCTL_EL1 access in
+ * EL2.
+ */
+.macro __init_el2_timers mode
+.ifeqs "\mode", "nvhe"
+	mrs	x0, cnthctl_el2
+	orr	x0, x0, #3			// Enable EL1 physical timers
+	msr	cnthctl_el2, x0
+.endif
+	msr	cntvoff_el2, xzr		// Clear virtual offset
+.endm
+
+.macro __init_el2_debug mode
+	mrs	x1, id_aa64dfr0_el1
+	sbfx	x0, x1, #ID_AA64DFR0_PMUVER_SHIFT, #4
+	cmp	x0, #1
+	b.lt	1f				// Skip if no PMU present
+	mrs	x0, pmcr_el0			// Disable debug access traps
+	ubfx	x0, x0, #11, #5			// to EL2 and allow access to
+1:
+	csel	x2, xzr, x0, lt			// all PMU counters from EL1
+
+	/* Statistical profiling */
+	ubfx	x0, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
+	cbz	x0, 3f				// Skip if SPE not present
+
+.ifeqs "\mode", "nvhe"
+	mrs_s	x0, SYS_PMBIDR_EL1              // If SPE available at EL2,
+	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
+	cbnz	x0, 2f				// then permit sampling of physical
+	mov	x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT | \
+		      1 << SYS_PMSCR_EL2_PA_SHIFT)
+	msr_s	SYS_PMSCR_EL2, x0		// addresses and physical counter
+2:
+	mov	x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
+	orr	x2, x2, x0			// If we don't have VHE, then
+						// use EL1&0 translation.
+.else
+	orr	x2, x2, #MDCR_EL2_TPMS		// For VHE, use EL2 translation
+						// and disable access from EL1
+.endif
+
+3:
+	msr	mdcr_el2, x2			// Configure debug traps
+.endm
+
+/* LORegions */
+.macro __init_el2_lor
+	mrs	x1, id_aa64mmfr1_el1
+	ubfx	x0, x1, #ID_AA64MMFR1_LOR_SHIFT, 4
+	cbz	x0, 1f
+	msr_s	SYS_LORC_EL1, xzr
+1:
+.endm
+
+/* Stage-2 translation */
+.macro __init_el2_stage2
+	msr	vttbr_el2, xzr
+.endm
+
+/* GICv3 system register access */
+.macro __init_el2_gicv3
+	mrs	x0, id_aa64pfr0_el1
+	ubfx	x0, x0, #ID_AA64PFR0_GIC_SHIFT, #4
+	cbz	x0, 1f
+
+	mrs_s	x0, SYS_ICC_SRE_EL2
+	orr	x0, x0, #ICC_SRE_EL2_SRE	// Set ICC_SRE_EL2.SRE==1
+	orr	x0, x0, #ICC_SRE_EL2_ENABLE	// Set ICC_SRE_EL2.Enable==1
+	msr_s	SYS_ICC_SRE_EL2, x0
+	isb					// Make sure SRE is now set
+	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
+	tbz	x0, #0, 1f			// and check that it sticks
+	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
+1:
+.endm
+
+.macro __init_el2_hstr
+	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
+.endm
+
+/* Virtual CPU ID registers */
+.macro __init_el2_nvhe_idregs
+	mrs	x0, midr_el1
+	mrs	x1, mpidr_el1
+	msr	vpidr_el2, x0
+	msr	vmpidr_el2, x1
+.endm
+
+/* Coprocessor traps */
+.macro __init_el2_nvhe_cptr
+	mov	x0, #0x33ff
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+.endm
+
+/* SVE register access */
+.macro __init_el2_nvhe_sve
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x1, x1, #ID_AA64PFR0_SVE_SHIFT, #4
+	cbz	x1, 1f
+
+	bic	x0, x0, #CPTR_EL2_TZ		// Also disable SVE traps
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+	isb
+	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
+	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
+1:
+.endm
+
+.macro __init_el2_nvhe_prepare_eret
+	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
+		      PSR_MODE_EL1h)
+	msr	spsr_el2, x0
+.endm
+
+/**
+ * Initialize EL2 registers to sane values. This should be called early on all
+ * cores that were booted in EL2.
+ *
+ * Regs: x0, x1 and x2 are clobbered.
+ */
+.macro init_el2_state mode
+.ifnes "\mode", "vhe"
+.ifnes "\mode", "nvhe"
+.error "Invalid 'mode' argument"
+.endif
+.endif
+
+	__init_el2_sctlr
+	__init_el2_timers \mode
+	__init_el2_debug \mode
+	__init_el2_lor
+	__init_el2_stage2
+	__init_el2_gicv3
+	__init_el2_hstr
+
+	/*
+	 * When VHE is not in use, early init of EL2 needs to be done here.
+	 * When VHE _is_ in use, EL1 will not be used in the host and
+	 * requires no configuration, and all non-hyp-specific EL2 setup
+	 * will be done via the _EL1 system register aliases in __cpu_setup.
+	 */
+.ifeqs "\mode", "nvhe"
+	__init_el2_nvhe_idregs
+	__init_el2_nvhe_cptr
+	__init_el2_nvhe_sve
+	__init_el2_nvhe_prepare_eret
+.endif
+.endm
+
+#endif /* __ARM_KVM_INIT_H__ */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d8d9caf02834..da913ce9e89f 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -11,7 +11,6 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
-#include <linux/irqchip/arm-gic-v3.h>
 #include <linux/pgtable.h>
 
 #include <asm/asm_pointer_auth.h>
@@ -21,6 +20,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
 #include <asm/cputype.h>
+#include <asm/el2_setup.h>
 #include <asm/elf.h>
 #include <asm/image.h>
 #include <asm/kernel-pgtable.h>
@@ -493,159 +493,47 @@ SYM_FUNC_START(el2_setup)
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
 	b.eq	1f
+
 	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
 	msr	sctlr_el1, x0
 	mov	w0, #BOOT_CPU_MODE_EL1		// This cpu booted in EL1
 	isb
 	ret
 
-1:	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
-	msr	sctlr_el2, x0
-
+1:
 #ifdef CONFIG_ARM64_VHE
 	/*
-	 * Check for VHE being present. For the rest of the EL2 setup,
-	 * x2 being non-zero indicates that we do have VHE, and that the
-	 * kernel is intended to run at EL2.
+	 * Check for VHE being present. x2 being non-zero indicates that we
+	 * do have VHE, and that the kernel is intended to run at EL2.
 	 */
 	mrs	x2, id_aa64mmfr1_el1
 	ubfx	x2, x2, #ID_AA64MMFR1_VHE_SHIFT, #4
-#else
-	mov	x2, xzr
-#endif
+	cbz	x2, el2_setup_nvhe
 
-	/* Hyp configuration. */
-	mov_q	x0, HCR_HOST_NVHE_FLAGS
-	cbz	x2, set_hcr
 	mov_q	x0, HCR_HOST_VHE_FLAGS
-set_hcr:
 	msr	hcr_el2, x0
 	isb
 
-	/*
-	 * Allow Non-secure EL1 and EL0 to access physical timer and counter.
-	 * This is not necessary for VHE, since the host kernel runs in EL2,
-	 * and EL0 accesses are configured in the later stage of boot process.
-	 * Note that when HCR_EL2.E2H == 1, CNTHCTL_EL2 has the same bit layout
-	 * as CNTKCTL_EL1, and CNTKCTL_EL1 accessing instructions are redefined
-	 * to access CNTHCTL_EL2. This allows the kernel designed to run at EL1
-	 * to transparently mess with the EL0 bits via CNTKCTL_EL1 access in
-	 * EL2.
-	 */
-	cbnz	x2, 1f
-	mrs	x0, cnthctl_el2
-	orr	x0, x0, #3			// Enable EL1 physical timers
-	msr	cnthctl_el2, x0
-1:
-	msr	cntvoff_el2, xzr		// Clear virtual offset
-
-#ifdef CONFIG_ARM_GIC_V3
-	/* GICv3 system register access */
-	mrs	x0, id_aa64pfr0_el1
-	ubfx	x0, x0, #ID_AA64PFR0_GIC_SHIFT, #4
-	cbz	x0, 3f
-
-	mrs_s	x0, SYS_ICC_SRE_EL2
-	orr	x0, x0, #ICC_SRE_EL2_SRE	// Set ICC_SRE_EL2.SRE==1
-	orr	x0, x0, #ICC_SRE_EL2_ENABLE	// Set ICC_SRE_EL2.Enable==1
-	msr_s	SYS_ICC_SRE_EL2, x0
-	isb					// Make sure SRE is now set
-	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
-	tbz	x0, #0, 3f			// and check that it sticks
-	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
-
-3:
-#endif
-
-	/* Populate ID registers. */
-	mrs	x0, midr_el1
-	mrs	x1, mpidr_el1
-	msr	vpidr_el2, x0
-	msr	vmpidr_el2, x1
-
-#ifdef CONFIG_COMPAT
-	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
-#endif
-
-	/* EL2 debug */
-	mrs	x1, id_aa64dfr0_el1
-	sbfx	x0, x1, #ID_AA64DFR0_PMUVER_SHIFT, #4
-	cmp	x0, #1
-	b.lt	4f				// Skip if no PMU present
-	mrs	x0, pmcr_el0			// Disable debug access traps
-	ubfx	x0, x0, #11, #5			// to EL2 and allow access to
-4:
-	csel	x3, xzr, x0, lt			// all PMU counters from EL1
-
-	/* Statistical profiling */
-	ubfx	x0, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
-	cbz	x0, 7f				// Skip if SPE not present
-	cbnz	x2, 6f				// VHE?
-	mrs_s	x4, SYS_PMBIDR_EL1		// If SPE available at EL2,
-	and	x4, x4, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
-	cbnz	x4, 5f				// then permit sampling of physical
-	mov	x4, #(1 << SYS_PMSCR_EL2_PCT_SHIFT | \
-		      1 << SYS_PMSCR_EL2_PA_SHIFT)
-	msr_s	SYS_PMSCR_EL2, x4		// addresses and physical counter
-5:
-	mov	x1, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
-	orr	x3, x3, x1			// If we don't have VHE, then
-	b	7f				// use EL1&0 translation.
-6:						// For VHE, use EL2 translation
-	orr	x3, x3, #MDCR_EL2_TPMS		// and disable access from EL1
-7:
-	msr	mdcr_el2, x3			// Configure debug traps
-
-	/* LORegions */
-	mrs	x1, id_aa64mmfr1_el1
-	ubfx	x0, x1, #ID_AA64MMFR1_LOR_SHIFT, 4
-	cbz	x0, 1f
-	msr_s	SYS_LORC_EL1, xzr
-1:
-
-	/* Stage-2 translation */
-	msr	vttbr_el2, xzr
-
-	cbz	x2, install_el2_stub
+	init_el2_state vhe
 
 	mov	w0, #BOOT_CPU_MODE_EL2		// This CPU booted in EL2
 	isb
 	ret
+#endif
 
-SYM_INNER_LABEL(install_el2_stub, SYM_L_LOCAL)
-	/*
-	 * When VHE is not in use, early init of EL2 and EL1 needs to be
-	 * done here.
-	 * When VHE _is_ in use, EL1 will not be used in the host and
-	 * requires no configuration, and all non-hyp-specific EL2 setup
-	 * will be done via the _EL1 system register aliases in __cpu_setup.
-	 */
-	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
-	msr	sctlr_el1, x0
-
-	/* Coprocessor traps. */
-	mov	x0, #0x33ff
-	msr	cptr_el2, x0			// Disable copro. traps to EL2
-
-	/* SVE register access */
-	mrs	x1, id_aa64pfr0_el1
-	ubfx	x1, x1, #ID_AA64PFR0_SVE_SHIFT, #4
-	cbz	x1, 7f
-
-	bic	x0, x0, #CPTR_EL2_TZ		// Also disable SVE traps
-	msr	cptr_el2, x0			// Disable copro. traps to EL2
+SYM_INNER_LABEL(el2_setup_nvhe, SYM_L_LOCAL)
+	mov_q	x0, HCR_HOST_NVHE_FLAGS
+	msr	hcr_el2, x0
 	isb
-	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
-	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
+
+	init_el2_state nvhe
 
 	/* Hypervisor stub */
-7:	adr_l	x0, __hyp_stub_vectors
+	adr_l	x0, __hyp_stub_vectors
 	msr	vbar_el2, x0
 
-	/* spsr */
-	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
-		      PSR_MODE_EL1h)
-	msr	spsr_el2, x0
+	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
+	msr	sctlr_el1, x0
 	msr	elr_el2, lr
 	mov	w0, #BOOT_CPU_MODE_EL2		// This CPU booted in EL2
 	eret
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
