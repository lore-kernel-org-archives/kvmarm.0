Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FC1C56201
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:48:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 421AC20809
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1I0kdLa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 421AC20809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D58214BA60;
	Mon,  9 Nov 2020 16:48:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cdCdEL7pGlc6; Mon,  9 Nov 2020 16:48:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 613264BA56;
	Mon,  9 Nov 2020 16:48:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B05754BA5E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UYJblmpIZAm9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 16:47:58 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14DEF4BA57
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:58 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ED1DE216C4;
 Mon,  9 Nov 2020 21:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604958477;
 bh=HuLkS+nTi7VaYL8OONvyv3+mmeLjJHBP/UInwjRQPMg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=f1I0kdLaesr/LNcsCZJOqCt7jZBvCL4qfntzo/3Aq3VLut8ZlDARxK6Cs8jhaD09i
 c82SdcOaktA3/LF85XEoB1pcDmfRIFofCwAFMuEn8F4qS5SZ0CMvGnHl9W4JJocLLA
 5bN0CuPp4xXkeaN3v0EBTkSel4XB9L43zhpGnQsI=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 8/9] arm64: spectre: Rename ARM64_HARDEN_EL2_VECTORS to
 ARM64_SPECTRE_V3A
Date: Mon,  9 Nov 2020 21:47:25 +0000
Message-Id: <20201109214726.15276-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109214726.15276-1-will@kernel.org>
References: <20201109214726.15276-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
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

Since ARM64_HARDEN_EL2_VECTORS is really a mitigation for Spectre-v3a,
rename it accordingly for consistency with the v2 and v4 mitigation.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/arm64/memory.rst   |  2 +-
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/include/asm/spectre.h |  2 +-
 arch/arm64/kernel/cpu_errata.c   |  6 +++---
 arch/arm64/kernel/proton-pack.c  | 13 ++++++++++---
 arch/arm64/kvm/arm.c             |  8 ++++----
 arch/arm64/kvm/hyp/hyp-entry.S   |  3 +--
 arch/arm64/kvm/va_layout.c       |  4 +---
 8 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/Documentation/arm64/memory.rst b/Documentation/arm64/memory.rst
index cf03b3290800..75df7fb30a7b 100644
--- a/Documentation/arm64/memory.rst
+++ b/Documentation/arm64/memory.rst
@@ -100,7 +100,7 @@ hypervisor maps kernel pages in EL2 at a fixed (and potentially
 random) offset from the linear mapping. See the kern_hyp_va macro and
 kvm_update_va_mask function for more details. MMIO devices such as
 GICv2 gets mapped next to the HYP idmap page, as do vectors when
-ARM64_HARDEN_EL2_VECTORS is selected for particular CPUs.
+ARM64_SPECTRE_V3A is enabled for particular CPUs.
 
 When using KVM with the Virtualization Host Extensions, no additional
 mappings are created, since the host kernel runs directly in EL2.
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index e7d98997c09c..162539d4c8cd 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -21,7 +21,7 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
-#define ARM64_HARDEN_EL2_VECTORS		14
+#define ARM64_SPECTRE_V3A			14
 #define ARM64_HAS_CNP				15
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index fa86b8f655b7..b4df683ed800 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -83,7 +83,7 @@ enum mitigation_state arm64_get_spectre_v2_state(void);
 bool has_spectre_v2(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
-void cpu_el2_vector_harden_enable(const struct arm64_cpu_capabilities *__unused);
+void spectre_v3a_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
 enum mitigation_state arm64_get_spectre_v4_state(void);
 bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 7a040abaedea..949d5615a47e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -460,10 +460,10 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_RANDOMIZE_BASE
 	{
 	/* Must come after the Spectre-v2 entry */
-		.desc = "EL2 vector hardening",
-		.capability = ARM64_HARDEN_EL2_VECTORS,
+		.desc = "Spectre-v3a",
+		.capability = ARM64_SPECTRE_V3A,
 		ERRATA_MIDR_RANGE_LIST(ca57_a72),
-		.cpu_enable = cpu_el2_vector_harden_enable,
+		.cpu_enable = spectre_v3a_enable_mitigation,
 	},
 #endif
 	{
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index a4ba94129750..cf9f8b885aea 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Handle detection, reporting and mitigation of Spectre v1, v2 and v4, as
+ * Handle detection, reporting and mitigation of Spectre v1, v2, v3a and v4, as
  * detailed at:
  *
  *   https://developer.arm.com/support/arm-security-updates/speculative-processor-vulnerability
@@ -270,11 +270,18 @@ void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
 	update_mitigation_state(&spectre_v2_state, state);
 }
 
-void cpu_el2_vector_harden_enable(const struct arm64_cpu_capabilities *__unused)
+/*
+ * Spectre-v3a.
+ *
+ * Phew, there's not an awful lot to do here! We just instruct EL2 to use
+ * an indirect trampoline for the hyp vectors so that guests can't read
+ * VBAR_EL2 to defeat randomisation of the hypervisor VA layout.
+ */
+void spectre_v3a_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
 {
 	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
 
-	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS))
+	if (this_cpu_has_cap(ARM64_SPECTRE_V3A))
 		data->slot += HYP_VECTOR_INDIRECT;
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ec6dce70c611..739b9ba37c74 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1314,7 +1314,7 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS))
+	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A))
 		return 0;
 
 	err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
@@ -1386,15 +1386,15 @@ static void cpu_hyp_reset(void)
  *   placed in one of the vector slots, which is executed before jumping
  *   to the real vectors.
  *
- * - If the CPU also has the ARM64_HARDEN_EL2_VECTORS cap, the slot
+ * - If the CPU also has the ARM64_SPECTRE_V3A cap, the slot
  *   containing the hardening sequence is mapped next to the idmap page,
  *   and executed before jumping to the real vectors.
  *
- * - If the CPU only has the ARM64_HARDEN_EL2_VECTORS cap, then an
+ * - If the CPU only has the ARM64_SPECTRE_V3A cap, then an
  *   empty slot is selected, mapped next to the idmap page, and
  *   executed before jumping to the real vectors.
  *
- * Note that ARM64_HARDEN_EL2_VECTORS is somewhat incompatible with
+ * Note that ARM64_SPECTRE_V3A is somewhat incompatible with
  * VHE, as we don't have hypervisor-specific mappings. If the system
  * is VHE and yet selects this capability, it will be ignored.
  */
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index f5e126e82db2..9d074ec34b1c 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -209,8 +209,7 @@ SYM_CODE_END(__kvm_hyp_vector)
 	.if \indirect != 0
 	alternative_cb  kvm_patch_vector_branch
 	/*
-	 * For ARM64_HARDEN_EL2_VECTORS configurations, these NOPs get replaced
-	 * with:
+	 * For ARM64_SPECTRE_V3A configurations, these NOPs get replaced with:
 	 *
 	 * movz	x0, #(addr & 0xffff)
 	 * movk	x0, #((addr >> 16) & 0xffff), lsl #16
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 1ae327006815..0782e4711aa2 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -139,10 +139,8 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 
 	BUG_ON(nr_inst != 3);
 
-	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS) ||
-	    WARN_ON_ONCE(has_vhe())) {
+	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A) || WARN_ON_ONCE(has_vhe()))
 		return;
-	}
 
 	/*
 	 * Compute HYP VA by using the same computation as kern_hyp_va()
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
