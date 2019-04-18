Return-Path: <SRS0=ZrZ1=SU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C98C10F0E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D90221479
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D90221479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2914A540;
	Thu, 18 Apr 2019 12:08:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WHBNJFmKMDGs; Thu, 18 Apr 2019 12:08:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FC994A511;
	Thu, 18 Apr 2019 12:08:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0DF4A4FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mkNmisE2L2Zb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 960AB4A494
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAE9615AB;
 Thu, 18 Apr 2019 09:07:59 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C6D3F3F5AF;
 Thu, 18 Apr 2019 09:07:57 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 01/14] arm64/sve: Clarify vq map semantics
Date: Thu, 18 Apr 2019 17:06:58 +0100
Message-Id: <1555603631-8107-2-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190418160658.rbTLmxrRqT9ImQUB9eGDsbrv1rkorJpWDS0BAy_XAH8@z>

Currently the meanings of sve_vq_map and the ancillary helpers
__bit_to_vq() and __vq_to_bit() are not clearly explained.

This patch makes the explanatory comment clearer, and removes the
duplicate comment from fpsimd.h.

The WARN_ON() currently present in __bit_to_vq() confuses the
intended use of this helper.  Since these are low-level helpers not
intended for general-purpose use anyway, it is better not to make
guesses about how these functions will be used: rather, this patch
removes the WARN_ON() and relies on callers to use the helpers
sensibly.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/fpsimd.h | 4 ----
 arch/arm64/kernel/fpsimd.c      | 7 ++++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index ad6d2e4..df62bbd 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -92,7 +92,6 @@ extern u64 read_zcr_features(void);
 
 extern int __ro_after_init sve_max_vl;
 extern int __ro_after_init sve_max_virtualisable_vl;
-/* Set of available vector lengths, as vq_to_bit(vq): */
 extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 
 /*
@@ -107,9 +106,6 @@ static inline unsigned int __vq_to_bit(unsigned int vq)
 
 static inline unsigned int __bit_to_vq(unsigned int bit)
 {
-	if (WARN_ON(bit >= SVE_VQ_MAX))
-		bit = SVE_VQ_MAX - 1;
-
 	return SVE_VQ_MAX - bit;
 }
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 577296b..56afa40 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -135,10 +135,15 @@ static int sve_default_vl = -1;
 /* Maximum supported vector length across all CPUs (initially poisoned) */
 int __ro_after_init sve_max_vl = SVE_VL_MIN;
 int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
-/* Set of available vector lengths, as vq_to_bit(vq): */
+
+/*
+ * Set of available vector lengths,
+ * where length vq encoded as bit __vq_to_bit(vq):
+ */
 __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 /* Set of vector lengths present on at least one cpu: */
 static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
+
 static void __percpu *efi_sve_state;
 
 #else /* ! CONFIG_ARM64_SVE */
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
