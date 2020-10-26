Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE09C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:49:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 407DF24641
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 407DF24641
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E684B510;
	Mon, 26 Oct 2020 09:49:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hgX96mz6kMsB; Mon, 26 Oct 2020 09:49:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A4E4B4F8;
	Mon, 26 Oct 2020 09:49:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CE5A4B4DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:49:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCZSPJewsqXo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:49:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 729704B4DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:49:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FA451476;
 Mon, 26 Oct 2020 06:49:41 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4A2483F68F;
 Mon, 26 Oct 2020 06:49:40 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 1/3] arm64: kvm: factor out is_{vhe,nvhe}_hyp_code()
Date: Mon, 26 Oct 2020 13:49:29 +0000
Message-Id: <20201026134931.28246-2-mark.rutland@arm.com>
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

Currently has_vhe() detects whether it is being compiled for VHE/NVHE
hyp code based on preprocessor definitions, and uses this knowledge to
avoid redundant runtime checks.

There are other cases where we'd like to use this knowledge, so let's
factor the preprocessor checks out into separate helpers.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/virt.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 09977acc007d1..300be14ba77b2 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -83,16 +83,27 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
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
 static __always_inline bool has_vhe(void)
 {
 	/*
-	 * The following macros are defined for code specic to VHE/nVHE.
-	 * If has_vhe() is inlined into those compilation units, it can
-	 * be determined statically. Otherwise fall back to caps.
+	 * Code only run in VHE/NVHE hyp context can assume VHE is present or
+	 * absent. Otherwise fall back to caps.
 	 */
-	if (__is_defined(__KVM_VHE_HYPERVISOR__))
+	if (is_vhe_hyp_code())
 		return true;
-	else if (__is_defined(__KVM_NVHE_HYPERVISOR__))
+	else if (is_nvhe_hyp_code())
 		return false;
 	else
 		return cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN);
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
