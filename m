Return-Path: <SRS0=kGQk=ZD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C697CC17441
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 14:12:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85AE3222C5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 14:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85AE3222C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA274AEA0;
	Mon, 11 Nov 2019 09:12:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rqYlid66rmSC; Mon, 11 Nov 2019 09:12:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34904ACD5;
	Mon, 11 Nov 2019 09:12:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25F604AC88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 09:12:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LkSv8OS+Th80 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Nov 2019 09:12:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F02F4B0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 09:12:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E269D46A;
 Mon, 11 Nov 2019 06:12:25 -0800 (PST)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com
 [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8ED7D3F534;
 Mon, 11 Nov 2019 06:12:24 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 2/2] arm64: Workaround for Cortex-A55 erratum 1530923
Date: Mon, 11 Nov 2019 14:11:57 +0000
Message-Id: <20191111141157.55062-3-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191111141157.55062-1-steven.price@arm.com>
References: <20191111141157.55062-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Cortex-A55 erratum 1530923 allows TLB entries to be allocated as a
result of a speculative AT instruction. This may happen in the middle of
a guest world switch while the relevant VMSA configuration is in an
inconsistent state, leading to erroneous content being allocated into
TLBs.

The same workaround as is used for Cortex-A76 erratum 1165522
(WORKAROUND_SPECULATIVE_AT) can be used here. Note that this mandates
the use of VHE on affected parts.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 13 +++++++++++++
 arch/arm64/include/asm/kvm_hyp.h       |  4 ++--
 arch/arm64/kernel/cpu_errata.c         |  6 +++++-
 arch/arm64/kvm/hyp/switch.c            |  4 ++--
 arch/arm64/kvm/hyp/tlb.c               |  4 ++--
 6 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 5a09661330fc..3640441ac63b 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -84,6 +84,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A55      | #1530923        | ARM64_ERRATUM_1530923       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6cb4eff602c6..98d1675ef3b8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -526,6 +526,19 @@ config ARM64_ERRATUM_1165522
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1530923
+	bool "Cortex-A55: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
+	default y
+	select ARM64_WORKAROUND_SPECULATIVE_AT
+	help
+	  This option adds a workaround for ARM Cortex-A55 erratum 1530923.
+
+	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0, r2p0) could end-up with
+	  corrupted TLBs by speculating an AT instruction during a guest
+	  context switch.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_1286807
 	bool "Cortex-A76: Modification of the translation table for a virtual address might lead to read-after-read ordering violation"
 	default y
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 43d6c30b1bcc..a210c76f75b0 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -91,8 +91,8 @@ static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
 	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
 
 	/*
-	 * ARM erratum 1165522 requires the actual execution of the above
-	 * before we can switch to the EL1/EL0 translation regime used by
+	 * ARM errata 1165522 and 1530923 require the actual execution of the
+	 * above before we can switch to the EL1/EL0 translation regime used by
 	 * the guest.
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT)); }
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a9ea19fdaf03..7720eb71966e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -777,6 +777,10 @@ static const struct midr_range erratum_speculative_at_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1165522
 	/* Cortex A76 r0p0 to r2p0 */
 	MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1530923
+	/* Cortex A55 r0p0 to r2p0 */
+	MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 2, 0),
 #endif
 	{},
 };
@@ -910,7 +914,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT
 	{
-		.desc = "ARM erratum 1165522",
+		.desc = "ARM errata 1165522, 1530923",
 		.capability = ARM64_WORKAROUND_SPECULATIVE_AT,
 		ERRATA_MIDR_RANGE_LIST(erratum_speculative_at_list),
 	},
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9b88627f9da9..574cb0ac50a8 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -144,8 +144,8 @@ static void deactivate_traps_vhe(void)
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 
 	/*
-	 * ARM erratum 1165522 requires the actual execution of the above
-	 * before we can switch to the EL2/EL0 translation regime used by
+	 * ARM errata 1165522 and 1530923 require the actual execution of the
+	 * above before we can switch to the EL2/EL0 translation regime used by
 	 * the host.
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 97e4b21367f1..879dcb0053b3 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -25,8 +25,8 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
 
 	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/*
-		 * For CPUs that are affected by ARM erratum 1165522, we
-		 * cannot trust stage-1 to be in a correct state at that
+		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
+		 * we cannot trust stage-1 to be in a correct state at that
 		 * point. Since we do not want to force a full load of the
 		 * vcpu state, we prevent the EL1 page-table walker to
 		 * allocate new TLBs. This is done by setting the EPD bits
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
