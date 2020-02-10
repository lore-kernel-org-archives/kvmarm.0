Return-Path: <SRS0=nwVD=36=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57EE2C352A3
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 12:27:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C54520873
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 12:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C54520873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C105D4A5C6;
	Mon, 10 Feb 2020 07:27:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id orroHBKmjupg; Mon, 10 Feb 2020 07:27:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 324854A957;
	Mon, 10 Feb 2020 07:27:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 737034A7FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 07:27:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SbVRSx3iZHx0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Feb 2020 07:27:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 250444A65C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 07:27:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCC34328;
 Mon, 10 Feb 2020 04:27:23 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 98FBF3F6CF;
 Mon, 10 Feb 2020 04:27:22 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] arm64: cpufeature: add cpus_have_final_cap()
Date: Mon, 10 Feb 2020 12:27:07 +0000
Message-Id: <20200210122708.38826-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200210122708.38826-1-mark.rutland@arm.com>
References: <20200210122708.38826-1-mark.rutland@arm.com>
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
moved above the other helpers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 47 +++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 92ef9539874a..bf752282bfc0 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -390,21 +390,42 @@ unsigned long cpu_get_elf_hwcap2(void);
 #define cpu_set_named_feature(name) cpu_set_feature(cpu_feature(name))
 #define cpu_have_named_feature(name) cpu_have_feature(cpu_feature(name))
 
-/* System capability check for constant caps */
-static __always_inline bool __cpus_have_const_cap(int num)
+/*
+ * Test for a capability with a runtime check.
+ *
+ * Before the capability is detected, this returns false.
+ */
+static inline bool cpus_have_cap(unsigned int num)
 {
 	if (num >= ARM64_NCAPS)
 		return false;
-	return static_branch_unlikely(&cpu_hwcap_keys[num]);
+	return test_bit(num, cpu_hwcaps);
 }
 
-static inline bool cpus_have_cap(unsigned int num)
+/*
+ * Test for a capability without a runtime check.
+ *
+ * Before capabilities are finalized, this returns false.
+ * After capabilities are finalized, this is patched to avoid a runtime check.
+ *
+ * @num must be a compile-time constant.
+ */
+static __always_inline bool __cpus_have_const_cap(int num)
 {
 	if (num >= ARM64_NCAPS)
 		return false;
-	return test_bit(num, cpu_hwcaps);
+	return static_branch_unlikely(&cpu_hwcap_keys[num]);
 }
 
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
 	if (static_branch_likely(&arm64_const_caps_ready))
@@ -413,6 +434,22 @@ static __always_inline bool cpus_have_const_cap(int num)
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
+	if (static_branch_likely(&arm64_const_caps_ready))
+		return __cpus_have_const_cap(num);
+	else
+		BUG();
+}
+
 static inline void cpus_set_cap(unsigned int num)
 {
 	if (num >= ARM64_NCAPS) {
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
