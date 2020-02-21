Return-Path: <SRS0=c+b0=4J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6054C35657
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 14:50:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7958624653
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 14:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7958624653
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E924AF0B;
	Fri, 21 Feb 2020 09:50:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ORQaKheOZ8LY; Fri, 21 Feb 2020 09:50:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B3F4AF18;
	Fri, 21 Feb 2020 09:50:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F634ACEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 09:50:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JR8zVhNBjgoE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Feb 2020 09:50:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97BE14ACF4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 09:50:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8193030E;
 Fri, 21 Feb 2020 06:50:32 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D6A93F703;
 Fri, 21 Feb 2020 06:50:31 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 1/2] arm64: cpufeature: add cpus_have_final_cap()
Date: Fri, 21 Feb 2020 14:50:21 +0000
Message-Id: <20200221145022.27217-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200221145022.27217-1-mark.rutland@arm.com>
References: <20200221145022.27217-1-mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When cpus_have_const_cap() was originally introduced it was intended to
be safe in hyp context, where it is not safe to access the cpu_hwcaps
array as cpus_have_cap() did. For more details see commit:

  a4023f682739439b ("arm64: Add hypervisor safe helper for checking constant capabilities")

We then made use of cpus_have_const_cap() throughout the kernel.

Subsequently, we had to defer updating the static_key associated with
each capability in order to avoid lockdep complaints. To avoid breaking
kernel-wide usage of cpus_have_const_cap(), this was updated to fall
back to the cpu_hwcaps array if called before the static_keys were
updated. As the kvm hyp code was only called later than this, the
fallback is redundant but not functionally harmful. For more details,
see commit:

  63a1e1c95e60e798 ("arm64/cpufeature: don't use mutex in bringup path")

Today we have more users of cpus_have_const_cap() which are only called
once the relevant static keys are initialized, and it would be
beneficial to avoid the redundant code.

To that end, this patch adds a new cpus_have_final_cap(), helper which
is intend to be used in code which is only run once capabilities have
been finalized, and will never check the cpus_hwcap array. This helps
the compiler to generate better code as it no longer needs to generate
code to address and test the cpus_hwcap array. To help catch misuse,
cpus_have_final_cap() will BUG() if called before capabilities are
finalized.

In hyp context, BUG() will result in a hyp panic, but the specific BUG()
instance will not be identified in the usual way.

Comments are added to the various cpus_have_*_cap() helpers to describe
the constraints on when they can be used. For clarity cpus_have_cap() is
moved above the other helpers. Similarly the helpers are updated to use
system_capabilities_finalized() consistently, and this is made
__always_inline as required by its new callers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 58 ++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 92ef9539874a..940b2b67b428 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -390,14 +390,16 @@ unsigned long cpu_get_elf_hwcap2(void);
 #define cpu_set_named_feature(name) cpu_set_feature(cpu_feature(name))
 #define cpu_have_named_feature(name) cpu_have_feature(cpu_feature(name))
 
-/* System capability check for constant caps */
-static __always_inline bool __cpus_have_const_cap(int num)
+static __always_inline bool system_capabilities_finalized(void)
 {
-	if (num >= ARM64_NCAPS)
-		return false;
-	return static_branch_unlikely(&cpu_hwcap_keys[num]);
+	return static_branch_likely(&arm64_const_caps_ready);
 }
 
+/*
+ * Test for a capability with a runtime check.
+ *
+ * Before the capability is detected, this returns false.
+ */
 static inline bool cpus_have_cap(unsigned int num)
 {
 	if (num >= ARM64_NCAPS)
@@ -405,14 +407,53 @@ static inline bool cpus_have_cap(unsigned int num)
 	return test_bit(num, cpu_hwcaps);
 }
 
+/*
+ * Test for a capability without a runtime check.
+ *
+ * Before capabilities are finalized, this returns false.
+ * After capabilities are finalized, this is patched to avoid a runtime check.
+ *
+ * @num must be a compile-time constant.
+ */
+static __always_inline bool __cpus_have_const_cap(int num)
+{
+	if (num >= ARM64_NCAPS)
+		return false;
+	return static_branch_unlikely(&cpu_hwcap_keys[num]);
+}
+
+/*
+ * Test for a capability, possibly with a runtime check.
+ *
+ * Before capabilities are finalized, this behaves as cpus_have_cap().
+ * After capabilities are finalized, this is patched to avoid a runtime check.
+ *
+ * @num must be a compile-time constant.
+ */
 static __always_inline bool cpus_have_const_cap(int num)
 {
-	if (static_branch_likely(&arm64_const_caps_ready))
+	if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
 		return cpus_have_cap(num);
 }
 
+/*
+ * Test for a capability without a runtime check.
+ *
+ * Before capabilities are finalized, this will BUG().
+ * After capabilities are finalized, this is patched to avoid a runtime check.
+ *
+ * @num must be a compile-time constant.
+ */
+static __always_inline bool cpus_have_final_cap(int num)
+{
+	if (system_capabilities_finalized())
+		return __cpus_have_const_cap(num);
+	else
+		BUG();
+}
+
 static inline void cpus_set_cap(unsigned int num)
 {
 	if (num >= ARM64_NCAPS) {
@@ -613,11 +654,6 @@ static inline bool system_has_prio_mask_debugging(void)
 	       system_uses_irq_prio_masking();
 }
 
-static inline bool system_capabilities_finalized(void)
-{
-	return static_branch_likely(&arm64_const_caps_ready);
-}
-
 #define ARM64_BP_HARDEN_UNKNOWN		-1
 #define ARM64_BP_HARDEN_WA_NEEDED	0
 #define ARM64_BP_HARDEN_NOT_REQUIRED	1
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
