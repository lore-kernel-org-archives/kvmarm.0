Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A675C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86387221FF
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="sDMK3pTx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86387221FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 270654B78B;
	Mon,  9 Nov 2020 06:33:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FI5YEVLKlTxs; Mon,  9 Nov 2020 06:33:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 576C04B77B;
	Mon,  9 Nov 2020 06:33:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59BDA4B72B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P3LcJgyoIpHb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:02 -0500 (EST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E30034B86B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:01 -0500 (EST)
Received: by mail-wm1-f47.google.com with SMTP id h62so7597675wme.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=cS8QTG5tjvfOjcLU9JKTQLemNTI4Nkc+jZ5k88XZZS8=;
 b=sDMK3pTxAt7vOBRuFEaRr0rc1hiztjacGbm8U9KifMn8e6XvYuf3pCNiamNY+0xrlg
 05bNGhtXeDC+tW5mvEHJ82P/wZyRsY8cDZObgax46lKiS24XcUSOuc2ekzJJhZEyvKFN
 aP37RG9Y4Dn+YupYVSx9SayJXheB0qxNENPqSyClW23eYrtDeLellezNoEcs7Mb+Ho3I
 Fgvmw36hj987NVF28rympN7eJE5LoCR/A0cwF4Ll9TI+d4vEMlM9PngU3NGn1I7MIeXk
 d9CtncuCPcfM90mzWAFFyb8NRjrAqIrQ0FkagQKY9bMa0n2V529iTOfXRtSjCMJo7a5/
 UUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=cS8QTG5tjvfOjcLU9JKTQLemNTI4Nkc+jZ5k88XZZS8=;
 b=ZcY4hfjAQexw57RD9oVadw+KRPWB13t68a69ktjh9XG7SLvLCVJaWREVsa+eQCiF/4
 qi5UJ3zzF8Bl8dTkeJw74RqCZnxzzjW8brApnZIWoQNv+c9vyhLfZkuXMHXeM25NEwer
 OzcJpK1f2zk2+svrn1LEoqwesfp/gPQFSasyGQ58Ep9rMSqodg1SPxqUUj9Cqs/aZcz3
 /Y5STTU3fcTqnOWayAjvPDCjnYy6ieYCvJBSLaiIbFKjAm5Xku6pYcefsgg+PPbLMZJW
 oyhK2S6NHdg8P5n8yJhCOHrJBExEsWfCoxEsQZgWi9PZMwrtAoErJpYBImPcY6q1X62t
 bdsA==
X-Gm-Message-State: AOAM531/jpK9D852ECnB6/qRGEZKamJZcNYW5b3pkTEBLDqFYJEp6q95
 aHStPpWmVsMZHFIQi1k0zwugcJ0dRAd2O6c1
X-Google-Smtp-Source: ABdhPJye+y3zRDBVgCLd/UA0xUtuzxRK1wXZpbz0oZSDKtXoM+MA+6ljUADR+3najNx1caAqVJWOnA==
X-Received: by 2002:a7b:cc05:: with SMTP id f5mr13884915wmh.123.1604921580371; 
 Mon, 09 Nov 2020 03:33:00 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id m22sm13556809wrb.97.2020.11.09.03.32.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:59 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 10/24] kvm: arm64: Extract parts of el2_setup into a macro
Date: Mon,  9 Nov 2020 11:32:19 +0000
Message-Id: <20201109113233.9012-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
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
Extract the relevant bits of el2_setup into init_el2_state macro
with an argument specifying whether to initialize for VHE or nVHE.

No functional change. Size of el2_setup increased by 148 bytes due
to duplication.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 128 ++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S         | 140 +++----------------------------
 2 files changed, 141 insertions(+), 127 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a49a87a186c3..893327d1e449 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -331,6 +331,134 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	msr	sp_el0, \tmp
 .endm
 
+.macro init_el2_state mode
+
+.ifnes "\mode", "vhe"
+.ifnes "\mode", "nvhe"
+.error "Invalid 'mode' argument"
+.endif
+.endif
+
+	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
+	msr	sctlr_el2, x0
+	isb
+
+	/*
+	 * Allow Non-secure EL1 and EL0 to access physical timer and counter.
+	 * This is not necessary for VHE, since the host kernel runs in EL2,
+	 * and EL0 accesses are configured in the later stage of boot process.
+	 * Note that when HCR_EL2.E2H == 1, CNTHCTL_EL2 has the same bit layout
+	 * as CNTKCTL_EL1, and CNTKCTL_EL1 accessing instructions are redefined
+	 * to access CNTHCTL_EL2. This allows the kernel designed to run at EL1
+	 * to transparently mess with the EL0 bits via CNTKCTL_EL1 access in
+	 * EL2.
+	 */
+.ifeqs "\mode", "nvhe"
+	mrs	x0, cnthctl_el2
+	orr	x0, x0, #3			// Enable EL1 physical timers
+	msr	cnthctl_el2, x0
+.endif
+	msr	cntvoff_el2, xzr		// Clear virtual offset
+
+#ifdef CONFIG_ARM_GIC_V3
+	/* GICv3 system register access */
+	mrs	x0, id_aa64pfr0_el1
+	ubfx	x0, x0, #ID_AA64PFR0_GIC_SHIFT, #4
+	cbz	x0, 3f
+
+	mrs_s	x0, SYS_ICC_SRE_EL2
+	orr	x0, x0, #ICC_SRE_EL2_SRE	// Set ICC_SRE_EL2.SRE==1
+	orr	x0, x0, #ICC_SRE_EL2_ENABLE	// Set ICC_SRE_EL2.Enable==1
+	msr_s	SYS_ICC_SRE_EL2, x0
+	isb					// Make sure SRE is now set
+	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
+	tbz	x0, #0, 3f			// and check that it sticks
+	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
+3:
+#endif
+
+	/* Populate ID registers. */
+	mrs	x0, midr_el1
+	mrs	x1, mpidr_el1
+	msr	vpidr_el2, x0
+	msr	vmpidr_el2, x1
+
+#ifdef CONFIG_COMPAT
+	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
+#endif
+
+	/* EL2 debug */
+	mrs	x1, id_aa64dfr0_el1
+	sbfx	x0, x1, #ID_AA64DFR0_PMUVER_SHIFT, #4
+	cmp	x0, #1
+	b.lt	4f				// Skip if no PMU present
+	mrs	x0, pmcr_el0			// Disable debug access traps
+	ubfx	x0, x0, #11, #5			// to EL2 and allow access to
+4:
+	csel	x3, xzr, x0, lt			// all PMU counters from EL1
+
+	/* Statistical profiling */
+	ubfx	x0, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
+	cbz	x0, 7f				// Skip if SPE not present
+.ifeqs "\mode", "nvhe"
+	mrs_s	x4, SYS_PMBIDR_EL1		// If SPE available at EL2,
+	and	x4, x4, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
+	cbnz	x4, 5f				// then permit sampling of physical
+	mov	x4, #(1 << SYS_PMSCR_EL2_PCT_SHIFT | \
+		      1 << SYS_PMSCR_EL2_PA_SHIFT)
+	msr_s	SYS_PMSCR_EL2, x4		// addresses and physical counter
+5:
+	mov	x1, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
+	orr	x3, x3, x1			// If we don't have VHE, then
+	b	7f				// use EL1&0 translation.
+.endif
+	orr	x3, x3, #MDCR_EL2_TPMS		// and disable access from EL1
+7:
+	msr	mdcr_el2, x3			// Configure debug traps
+
+	/* LORegions */
+	mrs	x1, id_aa64mmfr1_el1
+	ubfx	x0, x1, #ID_AA64MMFR1_LOR_SHIFT, 4
+	cbz	x0, 1f
+	msr_s	SYS_LORC_EL1, xzr
+1:
+
+	/* Stage-2 translation */
+	msr	vttbr_el2, xzr
+
+.ifeqs "\mode", "nvhe"
+	/*
+	 * When VHE is not in use, early init of EL2 and EL1 needs to be
+	 * done here.
+	 * When VHE _is_ in use, EL1 will not be used in the host and
+	 * requires no configuration, and all non-hyp-specific EL2 setup
+	 * will be done via the _EL1 system register aliases in __cpu_setup.
+	 */
+	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
+	msr	sctlr_el1, x0
+
+	/* Coprocessor traps. */
+	mov	x0, #0x33ff
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+
+	/* SVE register access */
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x1, x1, #ID_AA64PFR0_SVE_SHIFT, #4
+	cbz	x1, 7f
+
+	bic	x0, x0, #CPTR_EL2_TZ		// Also disable SVE traps
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+	isb
+	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
+	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
+
+	/* spsr */
+7:	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
+		      PSR_MODE_EL1h)
+	msr	spsr_el2, x0
+.endif
+.endm
+
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d8d9caf02834..e7270b63abed 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -25,6 +25,7 @@
 #include <asm/image.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/page.h>
@@ -499,153 +500,38 @@ SYM_FUNC_START(el2_setup)
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
 	msr	elr_el2, lr
 	mov	w0, #BOOT_CPU_MODE_EL2		// This CPU booted in EL2
 	eret
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
