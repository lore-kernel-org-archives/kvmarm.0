Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938F5C433E9
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 09:46:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D11F22B37
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 09:46:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D11F22B37
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AEA14B279;
	Mon, 18 Jan 2021 04:46:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Idu-bEPGciON; Mon, 18 Jan 2021 04:46:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED3C24B2A2;
	Mon, 18 Jan 2021 04:46:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F5E4B2A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 04:46:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yOtZ7Ni5m6fq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 04:46:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7223E4B27E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 04:46:07 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8BD46224B0;
 Mon, 18 Jan 2021 09:46:06 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l1R6q-008RhD-RS; Mon, 18 Jan 2021 09:46:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/21] arm64: Simplify init_el2_state to be non-VHE only
Date: Mon, 18 Jan 2021 09:45:19 +0000
Message-Id: <20210118094533.2874082-8-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118094533.2874082-1-maz@kernel.org>
References: <20210118094533.2874082-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

As init_el2_state is now nVHE only, let's simplify it and drop
the VHE setup.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 36 +++++++-----------------------
 arch/arm64/kernel/head.S           |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  2 +-
 3 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 540116de80bf..d77d358f9395 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -32,16 +32,14 @@
  * to transparently mess with the EL0 bits via CNTKCTL_EL1 access in
  * EL2.
  */
-.macro __init_el2_timers mode
-.ifeqs "\mode", "nvhe"
+.macro __init_el2_timers
 	mrs	x0, cnthctl_el2
 	orr	x0, x0, #3			// Enable EL1 physical timers
 	msr	cnthctl_el2, x0
-.endif
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
 
-.macro __init_el2_debug mode
+.macro __init_el2_debug
 	mrs	x1, id_aa64dfr0_el1
 	sbfx	x0, x1, #ID_AA64DFR0_PMUVER_SHIFT, #4
 	cmp	x0, #1
@@ -55,7 +53,6 @@
 	ubfx	x0, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
 	cbz	x0, .Lskip_spe_\@		// Skip if SPE not present
 
-.ifeqs "\mode", "nvhe"
 	mrs_s	x0, SYS_PMBIDR_EL1              // If SPE available at EL2,
 	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
 	cbnz	x0, .Lskip_spe_el2_\@		// then permit sampling of physical
@@ -66,10 +63,6 @@
 	mov	x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
 	orr	x2, x2, x0			// If we don't have VHE, then
 						// use EL1&0 translation.
-.else
-	orr	x2, x2, #MDCR_EL2_TPMS		// For VHE, use EL2 translation
-						// and disable access from EL1
-.endif
 
 .Lskip_spe_\@:
 	msr	mdcr_el2, x2			// Configure debug traps
@@ -145,37 +138,24 @@
 
 /**
  * Initialize EL2 registers to sane values. This should be called early on all
- * cores that were booted in EL2.
+ * cores that were booted in EL2. Note that everything gets initialised as
+ * if VHE was not evailable. The kernel context will be upgraded to VHE
+ * if possible later on in the boot process
  *
  * Regs: x0, x1 and x2 are clobbered.
  */
-.macro init_el2_state mode
-.ifnes "\mode", "vhe"
-.ifnes "\mode", "nvhe"
-.error "Invalid 'mode' argument"
-.endif
-.endif
-
+.macro init_el2_state
 	__init_el2_sctlr
-	__init_el2_timers \mode
-	__init_el2_debug \mode
+	__init_el2_timers
+	__init_el2_debug
 	__init_el2_lor
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
-
-	/*
-	 * When VHE is not in use, early init of EL2 needs to be done here.
-	 * When VHE _is_ in use, EL1 will not be used in the host and
-	 * requires no configuration, and all non-hyp-specific EL2 setup
-	 * will be done via the _EL1 system register aliases in __cpu_setup.
-	 */
-.ifeqs "\mode", "nvhe"
 	__init_el2_nvhe_idregs
 	__init_el2_nvhe_cptr
 	__init_el2_nvhe_sve
 	__init_el2_nvhe_prepare_eret
-.endif
 .endm
 
 #endif /* __ARM_KVM_INIT_H__ */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 07445fd976ef..36212c05df42 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -501,7 +501,7 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	msr	hcr_el2, x0
 	isb
 
-	init_el2_state nvhe
+	init_el2_state
 
 	/* Hypervisor stub */
 	adr_l	x0, __hyp_stub_vectors
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 31b060a44045..222cfc3e7190 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -189,7 +189,7 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 2:	msr	SPsel, #1			// We want to use SP_EL{1,2}
 
 	/* Initialize EL2 CPU state to sane values. */
-	init_el2_state nvhe			// Clobbers x0..x2
+	init_el2_state				// Clobbers x0..x2
 
 	/* Enable MMU, set vectors and stack. */
 	mov	x0, x28
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
