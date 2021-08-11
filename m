Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B78AC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 04:52:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B03F560F38
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 04:52:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B03F560F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29B374A1A7;
	Wed, 11 Aug 2021 00:52:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6jBlR7Ng6ZTu; Wed, 11 Aug 2021 00:52:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F0F4A023;
	Wed, 11 Aug 2021 00:52:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16A05407EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 00:52:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HeDTTTA6i4px for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 00:51:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA195405A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 00:51:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E0E66D;
 Tue, 10 Aug 2021 21:51:55 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.67.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B1BF13F40C;
 Tue, 10 Aug 2021 21:51:51 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and
 16K page size
Date: Wed, 11 Aug 2021 10:22:29 +0530
Message-Id: <1628657549-27584-1-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

Even though ID_AA64MMFR0.PARANGE reports 52 bit PA size support, it cannot
be enabled as guest IPA size on 4K or 16K page size configurations. Hence
kvm_ipa_limit must be restricted to 48 bits. This change achieves required
IPA capping.

Before the commit c9b69a0cf0b4 ("KVM: arm64: Don't constrain maximum IPA
size based on host configuration"), the problem here would have been just
latent via PHYS_MASK_SHIFT (which earlier in turn capped kvm_ipa_limit),
which remains capped at 48 bits on 4K and 16K configs.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org
Fixes: c9b69a0cf0b4 ("KVM: arm64: Don't constrain maximum IPA size based on host configuration")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This applies on v5.14-rc5

 arch/arm64/kvm/reset.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 20588220fe66..e66974c4b9d3 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -337,6 +337,15 @@ int kvm_set_ipa_limit(void)
 		return -EINVAL;
 	}
 
+	/*
+	 * IPA size beyond 48 bits could not be supported
+	 * on either 4K or 16K page size. Hence let's cap
+	 * it to 48 bits, in case it's reported as larger
+	 * on the system.
+	 */
+	if (!IS_ENABLED(CONFIG_ARM64_64K_PAGES))
+		parange = min(parange, (unsigned int)ID_AA64MMFR0_PARANGE_48);
+
 	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
 	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
 		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
