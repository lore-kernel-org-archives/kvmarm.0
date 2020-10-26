Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CD2C55178
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:49:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 855AF22460
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 855AF22460
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394DE4B50B;
	Mon, 26 Oct 2020 09:49:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k1fAOJrt-Jv3; Mon, 26 Oct 2020 09:49:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E783D4B4FF;
	Mon, 26 Oct 2020 09:49:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A20E14B250
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:49:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZjEbBG-1fWGn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:49:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6264D4B4FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:49:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2119D1476;
 Mon, 26 Oct 2020 06:49:45 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3A7593F68F;
 Mon, 26 Oct 2020 06:49:44 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 3/3] arm64: cpufeature: upgrade hyp caps to final
Date: Mon, 26 Oct 2020 13:49:31 +0000
Message-Id: <20201026134931.28246-4-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201026134931.28246-1-mark.rutland@arm.com>
References: <20201026134931.28246-1-mark.rutland@arm.com>
Cc: maz@kernel.org, will@kernel.org
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

We finalize caps before initializing kvm hyp code, and any use of
cpus_have_const_cap() in kvm hyp code generates redundant and
potentially unsound code to read the cpu_hwcaps array.

A number of helper functions used in both hyp context and regular kernel
context use cpus_have_const_cap(), as some regular kernel code runs
before the capabilities are finalized. It's tedious and error-prone to
write separate copies of these for hyp and non-hyp code.

So that we can avoid the redundant code, let's automatically upgrade
cpus_have_const_cap() to cpus_have_final_cap() when used in hyp context.
With this change, there's never a reason to access to cpu_hwcaps array
from hyp code, and we don't need to create an NVHE alias for this.

This should have no effect on non-hyp code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 26 ++++++++++++++++++++++++--
 arch/arm64/include/asm/virt.h       | 12 ------------
 arch/arm64/kernel/image-vars.h      |  1 -
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 5d18c54507e6a..97244d4feca9c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -375,6 +375,23 @@ cpucap_multi_entry_cap_matches(const struct arm64_cpu_capabilities *entry,
 	return false;
 }
 
+static __always_inline bool is_vhe_hyp_code(void)
+{
+	/* Only defined for code run in VHE hyp context */
+	return __is_defined(__KVM_VHE_HYPERVISOR__);
+}
+
+static __always_inline bool is_nvhe_hyp_code(void)
+{
+	/* Only defined for code run in NVHE hyp context */
+	return __is_defined(__KVM_NVHE_HYPERVISOR__);
+}
+
+static __always_inline bool is_hyp_code(void)
+{
+	return is_vhe_hyp_code() || is_nvhe_hyp_code();
+}
+
 extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 extern struct static_key_false cpu_hwcap_keys[ARM64_NCAPS];
 extern struct static_key_false arm64_const_caps_ready;
@@ -444,8 +461,11 @@ static __always_inline bool cpus_have_final_cap(int num)
 }
 
 /*
- * Test for a capability, possibly with a runtime check.
+ * Test for a capability, possibly with a runtime check for non-hyp code.
  *
+ * For hyp code, this behaves the same as cpus_have_final_cap().
+ *
+ * For non-hyp code:
  * Before capabilities are finalized, this behaves as cpus_have_cap().
  * After capabilities are finalized, this is patched to avoid a runtime check.
  *
@@ -453,7 +473,9 @@ static __always_inline bool cpus_have_final_cap(int num)
  */
 static __always_inline bool cpus_have_const_cap(int num)
 {
-	if (system_capabilities_finalized())
+	if (is_hyp_code())
+		return cpus_have_final_cap(num);
+	else if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
 		return cpus_have_cap(num);
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 300be14ba77b2..6069be50baf9f 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -83,18 +83,6 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
-static __always_inline bool is_vhe_hyp_code(void)
-{
-	/* Only defined for code run in VHE hyp context */
-	return __is_defined(__KVM_VHE_HYPERVISOR__);
-}
-
-static __always_inline bool is_nvhe_hyp_code(void)
-{
-	/* Only defined for code run in NVHE hyp context */
-	return __is_defined(__KVM_NVHE_HYPERVISOR__);
-}
-
 static __always_inline bool has_vhe(void)
 {
 	/*
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 61684a5009148..c615b285ff5b3 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -87,7 +87,6 @@ KVM_NVHE_ALIAS(__icache_flags);
 /* Kernel symbols needed for cpus_have_final/const_caps checks. */
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
-KVM_NVHE_ALIAS(cpu_hwcaps);
 
 /* Static keys which are set if a vGIC trap should be handled in hyp. */
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
