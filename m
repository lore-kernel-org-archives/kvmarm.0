Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55414C5518B
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 16:14:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF5622082E
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 16:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ToSCtMEF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF5622082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9AD4B197;
	Wed, 22 Apr 2020 12:14:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UVuJi1I+csSZ; Wed, 22 Apr 2020 12:14:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6024B130;
	Wed, 22 Apr 2020 12:14:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AADB94B130
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 12:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GaL0cAw5UvuK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 12:14:12 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17B304B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 12:14:12 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id i10so1292254wrq.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 09:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=NzX7iIMbTEOWsnzC9IlvKEKgMj8+EoqY9PVohrjklMU=;
 b=ToSCtMEFmo/KC86W1fFL7g+5L9Jvr/PLsu40//phkYlpph6odPs0SZ3mOX9TPN0HUb
 YnJchDU48L8M00sayapJFN9gOE+mmIp3R4Gw1mMFA9EsyxNMlWNHKRYy4+3YfCQ5fh+G
 JCYOO2VQPvhLFkHor1neweVmXfQbf5R+m2XTAMeOefdwO1FgPmuOXnc/fu4NwoF9fLRI
 BeB2RzzXFZlnGb/d5urYQC+rxXWYwQGBzMSaHdXfOX3eNdaAncr36BtUgYkqfMnylIbp
 sbL7xgTT35y/uZzqA9FnrvlHRpKxTXn0SVkxRsiy8d/yQ8gjwNl8Gm1Cct2uB3PPu0Lo
 aldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=NzX7iIMbTEOWsnzC9IlvKEKgMj8+EoqY9PVohrjklMU=;
 b=as95LjcevmU3oWM7rS0JUFhN1vlMR3QtMhn5fAg4q7u0cCMGUWOibLt2VXscNz7AUt
 KgumKXVOBnwTtzip4jYgYPn+4Gg612IUm/FIXnDUiWm5tTWa0WYYdSw0w2cd8VqkpOsb
 4Ahi3SPvpSls1c0/HMlcBvkRWg/NPJAUcHRIDaa0AuFic0h9Q1FaZFbSVvRiEMhbsab+
 W7YCk/YgW/99AtmZgCparKcD+4WrIZb71LCV7imhHRinOdu7C6ckCNF3aKRWqMvytw97
 dQsWdxdXKkt2JLKm4nNzGXNGNsjkBWcAvg2jOgeBjXilLvgnTx80k1RdO+rwxG/dGPFk
 8oxw==
X-Gm-Message-State: AGi0PubW8NqwcEyagQcyKCotBjlQxTbluIAUST49XQCPDnyHy2EHv5Sc
 1QKvX1kLEEq5g69tjWUMQMu0tNnT7eMrR/+4L1bEVR7R0epaxvG76FLfzmSp6eYsNaTWM6NB/d2
 JCZwwzmRqA+7YygrrH63F3ewFKFizquX5Ju/BxQpUOt3ZFv4fBzfmv3vRElDo0HHWCYwYUw==
X-Google-Smtp-Source: APiQypJGTfJSMyRT0lUu9nNgclE7ZKZuInYYx6/hWCId6De8ex4Hxjpj7zA0OxNnezHefauonoD8oUFAQe0=
X-Received: by 2002:adf:f10c:: with SMTP id r12mr18839179wro.409.1587572050745; 
 Wed, 22 Apr 2020 09:14:10 -0700 (PDT)
Date: Wed, 22 Apr 2020 17:13:46 +0100
Message-Id: <20200422161346.67325-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2] arm64: Unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
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

Errata 1165522, 1319367 and 1530923 each allow TLB entries to be
allocated as a result of a speculative AT instruction. In order to
avoid mandating VHE on certain affected CPUs, apply the workaround to
both the nVHE and the VHE case for all affected CPUs.

Signed-off-by: Andrew Scull <ascull@google.com>
CC: Marc Zyngier <maz@kernel.org>
CC: James Morse <james.morse@arm.com>
CC: Suzuki K Poulose <suzuki.poulose@arm.com>
CC: Will Deacon <will@kernel.org>
CC: Steven Price <steven.price@arm.com>
---
* From v1 <20200327143941.195626-1-ascull@google.com>:
  - Restored registers in VHE path
  - RFC: Remove trust in host
---
 arch/arm64/Kconfig                | 39 ++++++++++++++-----------------
 arch/arm64/include/asm/cpucaps.h  | 15 ++++++------
 arch/arm64/include/asm/kvm_host.h |  4 ----
 arch/arm64/include/asm/kvm_hyp.h  |  2 +-
 arch/arm64/kernel/cpu_errata.c    | 25 +++++++++-----------
 arch/arm64/kvm/hyp/switch.c       |  6 ++---
 arch/arm64/kvm/hyp/sysreg-sr.c    |  6 +++--
 arch/arm64/kvm/hyp/tlb.c          | 11 +++++----
 8 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 40fb05d96c60..c0298e8f1a2d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -524,13 +524,13 @@ config ARM64_ERRATUM_1418040
 
 	  If unsure, say Y.
 
-config ARM64_WORKAROUND_SPECULATIVE_AT_VHE
+config ARM64_WORKAROUND_SPECULATIVE_AT
 	bool
 
 config ARM64_ERRATUM_1165522
-	bool "Cortex-A76: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
+	bool "Cortex-A76: 1165522: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
 	default y
-	select ARM64_WORKAROUND_SPECULATIVE_AT_VHE
+	select ARM64_WORKAROUND_SPECULATIVE_AT
 	help
 	  This option adds a workaround for ARM Cortex-A76 erratum 1165522.
 
@@ -540,10 +540,23 @@ config ARM64_ERRATUM_1165522
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1319367
+	bool "Cortex-A57/A72: 1319537: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
+	default y
+	select ARM64_WORKAROUND_SPECULATIVE_AT
+	help
+	  This option adds work arounds for ARM Cortex-A57 erratum 1319537
+	  and A72 erratum 1319367
+
+	  Cortex-A57 and A72 cores could end-up with corrupted TLBs by
+	  speculating an AT instruction during a guest context switch.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_1530923
-	bool "Cortex-A55: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
+	bool "Cortex-A55: 1530923: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
 	default y
-	select ARM64_WORKAROUND_SPECULATIVE_AT_VHE
+	select ARM64_WORKAROUND_SPECULATIVE_AT
 	help
 	  This option adds a workaround for ARM Cortex-A55 erratum 1530923.
 
@@ -569,22 +582,6 @@ config ARM64_ERRATUM_1286807
 	  invalidated has been observed by other observers. The
 	  workaround repeats the TLBI+DSB operation.
 
-config ARM64_WORKAROUND_SPECULATIVE_AT_NVHE
-	bool
-
-config ARM64_ERRATUM_1319367
-	bool "Cortex-A57/A72: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
-	default y
-	select ARM64_WORKAROUND_SPECULATIVE_AT_NVHE
-	help
-	  This option adds work arounds for ARM Cortex-A57 erratum 1319537
-	  and A72 erratum 1319367
-
-	  Cortex-A57 and A72 cores could end-up with corrupted TLBs by
-	  speculating an AT instruction during a guest context switch.
-
-	  If unsure, say Y.
-
 config ARM64_ERRATUM_1463225
 	bool "Cortex-A76: Software Step might prevent interrupt recognition"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8eb5a088ae65..dc70883062ba 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -44,7 +44,7 @@
 #define ARM64_SSBS				34
 #define ARM64_WORKAROUND_1418040		35
 #define ARM64_HAS_SB				36
-#define ARM64_WORKAROUND_SPECULATIVE_AT_VHE	37
+#define ARM64_WORKAROUND_SPECULATIVE_AT	37
 #define ARM64_HAS_ADDRESS_AUTH_ARCH		38
 #define ARM64_HAS_ADDRESS_AUTH_IMP_DEF		39
 #define ARM64_HAS_GENERIC_AUTH_ARCH		40
@@ -55,13 +55,12 @@
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	45
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM	46
 #define ARM64_WORKAROUND_1542419		47
-#define ARM64_WORKAROUND_SPECULATIVE_AT_NVHE	48
-#define ARM64_HAS_E0PD				49
-#define ARM64_HAS_RNG				50
-#define ARM64_HAS_AMU_EXTN			51
-#define ARM64_HAS_ADDRESS_AUTH			52
-#define ARM64_HAS_GENERIC_AUTH			53
+#define ARM64_HAS_E0PD				48
+#define ARM64_HAS_RNG				49
+#define ARM64_HAS_AMU_EXTN			50
+#define ARM64_HAS_ADDRESS_AUTH			51
+#define ARM64_HAS_GENERIC_AUTH			52
 
-#define ARM64_NCAPS				54
+#define ARM64_NCAPS				53
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32c8a675e5a4..d0e7d7934a1f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -573,10 +573,6 @@ static inline bool kvm_arch_requires_vhe(void)
 	if (system_supports_sve())
 		return true;
 
-	/* Some implementations have defects that confine them to VHE */
-	if (cpus_have_cap(ARM64_WORKAROUND_SPECULATIVE_AT_VHE))
-		return true;
-
 	return false;
 }
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fe57f60f06a8..238d2e049694 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -102,7 +102,7 @@ static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
 	 * above before we can switch to the EL1/EL0 translation regime used by
 	 * the guest.
 	 */
-	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index df56d2295d16..95006a791026 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -635,7 +635,7 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
-#if defined(CONFIG_HARDEN_EL2_VECTORS) || defined(CONFIG_ARM64_ERRATUM_1319367)
+#if defined(CONFIG_HARDEN_EL2_VECTORS)
 
 static const struct midr_range ca57_a72[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -757,12 +757,16 @@ static const struct arm64_cpu_capabilities erratum_843419_list[] = {
 };
 #endif
 
-#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT_VHE
-static const struct midr_range erratum_speculative_at_vhe_list[] = {
+#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT
+static const struct midr_range erratum_speculative_at_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1165522
 	/* Cortex A76 r0p0 to r2p0 */
 	MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1319367
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_1530923
 	/* Cortex A55 r0p0 to r2p0 */
 	MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 2, 0),
@@ -897,11 +901,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(erratum_1418040_list),
 	},
 #endif
-#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT_VHE
+#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT
 	{
-		.desc = "ARM errata 1165522, 1530923",
-		.capability = ARM64_WORKAROUND_SPECULATIVE_AT_VHE,
-		ERRATA_MIDR_RANGE_LIST(erratum_speculative_at_vhe_list),
+		.desc = "ARM errata 1165522, 1319367, 1530923",
+		.capability = ARM64_WORKAROUND_SPECULATIVE_AT,
+		ERRATA_MIDR_RANGE_LIST(erratum_speculative_at_list),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1463225
@@ -934,13 +938,6 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_neoverse_n1_erratum_1542419,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
-#endif
-#ifdef CONFIG_ARM64_ERRATUM_1319367
-	{
-		.desc = "ARM erratum 1319367",
-		.capability = ARM64_WORKAROUND_SPECULATIVE_AT_NVHE,
-		ERRATA_MIDR_RANGE_LIST(ca57_a72),
-	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8a1e81a400e0..651820f537fb 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -138,7 +138,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 
 	write_sysreg(val, cptr_el2);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
 
 		isb();
@@ -181,7 +181,7 @@ static void deactivate_traps_vhe(void)
 	 * above before we can switch to the EL2/EL0 translation regime used by
 	 * the host.
 	 */
-	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
@@ -192,7 +192,7 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
 		/*
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 75b1925763f1..8f56f30d0833 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -118,7 +118,8 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
 
-	if (!cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
+	if (has_vhe() ||
+	    !cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
 		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
 	} else	if (!ctxt->__hyp_running_vcpu) {
@@ -149,7 +150,8 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
 	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE) &&
+	if (!has_vhe() &&
+	    cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
 	    ctxt->__hyp_running_vcpu) {
 		/*
 		 * Must only be done for host registers, hence the context
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index ceaddbe4279f..59d127204345 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -23,7 +23,7 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
 
 	local_irq_save(cxt->flags);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_VHE)) {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/*
 		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
 		 * we cannot trust stage-1 to be in a correct state at that
@@ -63,7 +63,7 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
 static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 						  struct tlb_inv_context *cxt)
 {
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
 		/*
@@ -79,8 +79,9 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 		isb();
 	}
 
+	/* __load_guest_stage2() includes an ISB for the workaround. */
 	__load_guest_stage2(kvm);
-	isb();
+	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
 static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
@@ -103,7 +104,7 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	isb();
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_VHE)) {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Restore the registers to what they were */
 		write_sysreg_el1(cxt->tcr, SYS_TCR);
 		write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
@@ -117,7 +118,7 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
 {
 	write_sysreg(0, vttbr_el2);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Ensure write of the host VMID */
 		isb();
 		/* Restore the host's TCR_EL1 */
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
