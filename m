Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7573C34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 12:45:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CDFB2173E
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 12:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CDFB2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 959854AF1D;
	Tue, 18 Feb 2020 07:45:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 244oBUPyH1sG; Tue, 18 Feb 2020 07:45:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 709884AF3D;
	Tue, 18 Feb 2020 07:45:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E692D4AF1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 07:45:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kIHrhysXqGSF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 07:45:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B364AF1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 07:45:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0AB71FB;
 Tue, 18 Feb 2020 04:45:04 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74B253F6CF;
 Tue, 18 Feb 2020 04:45:04 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
Date: Tue, 18 Feb 2020 12:44:55 +0000
Message-Id: <20200218124456.10615-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

We have recently introduced new macros for annotating assembly symbols
for things that aren't C functions, SYM_CODE_START() and SYM_CODE_END(),
in an effort to clarify and simplify our annotations of assembly files.

Using these for __bp_harden_hyp_vecs is more involved than for most symbols
as this symbol is annotated quite unusually as rather than just have the
explicit symbol we define _start and _end symbols which we then use to
compute the length. This does not play at all nicely with the new style
macros. Since the size of the vectors is a known constant which won't vary
the simplest thing to do is simply to drop the separate _start and _end
symbols and just use a #define for the size.

Ideally we would have a build time assert to make sure we got this right
but we don't have such a thing for assembly code and given how unlikely
the size is to change it seems disproportionately difficult to write one
just for this.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 9 ++++-----
 arch/arm64/include/asm/mmu.h     | 5 ++++-
 arch/arm64/kernel/cpu_errata.c   | 2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   | 4 ++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 53d846f1bfe7..b5f723cf9599 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -480,7 +480,7 @@ static inline void *kvm_get_hyp_vector(void)
 	int slot = -1;
 
 	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
-		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs_start));
+		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 		slot = data->hyp_vectors_slot;
 	}
 
@@ -509,14 +509,13 @@ static inline int kvm_map_vectors(void)
 	 *  HBP +  HEL2 -> use hardened vertors and use exec mapping
 	 */
 	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
-		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs_start);
+		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs);
 		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
 	}
 
 	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
-		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs_start);
-		unsigned long size = (__bp_harden_hyp_vecs_end -
-				      __bp_harden_hyp_vecs_start);
+		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs);
+		unsigned long size = __BP_HARDEN_HYP_VECS_SZ;
 
 		/*
 		 * Always allocate a spare vector slot, as we don't
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index e4d862420bb4..c6e811767a12 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -45,7 +45,10 @@ struct bp_hardening_data {
 
 #if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
      defined(CONFIG_HARDEN_EL2_VECTORS))
-extern char __bp_harden_hyp_vecs_start[], __bp_harden_hyp_vecs_end[];
+
+#define __BP_HARDEN_HYP_VECS_SZ (BP_HARDEN_EL2_SLOTS * SZ_2K)
+
+extern char __bp_harden_hyp_vecs[];
 extern atomic_t arm64_el2_vector_last_slot;
 #endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS */
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 703ad0a84f99..0af2201cefda 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -119,7 +119,7 @@ extern char __smccc_workaround_1_smc_end[];
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
 {
-	void *dst = lm_alias(__bp_harden_hyp_vecs_start + slot * SZ_2K);
+	void *dst = lm_alias(__bp_harden_hyp_vecs + slot * SZ_2K);
 	int i;
 
 	for (i = 0; i < SZ_2K; i += 0x80)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 0aea8f9ab23d..8976276685a1 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -312,11 +312,11 @@ alternative_cb_end
 .endm
 
 	.align	11
-ENTRY(__bp_harden_hyp_vecs_start)
+SYM_CODE_START(__bp_harden_hyp_vecs)
 	.rept BP_HARDEN_EL2_SLOTS
 	generate_vectors
 	.endr
-ENTRY(__bp_harden_hyp_vecs_end)
+SYM_CODE_END(__bp_harden_hyp_vecs)
 
 	.popsection
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
