Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F33DC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 17:33:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C80463366
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 17:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0C80463366
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A13104025B;
	Mon, 20 Sep 2021 13:33:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ybGxWcXIln7g; Mon, 20 Sep 2021 13:33:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0F0401A2;
	Mon, 20 Sep 2021 13:33:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5320401A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 13:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4f5aid8ccuto for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 13:33:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70BA940191
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 13:33:35 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A766335C;
 Mon, 20 Sep 2021 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1632159213;
 bh=CR846wXXXHl/Ng8G88sA14qia9OWfF1CL4/79f+daRE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Sj/8i3yKeaZ3/Re7XqH4Mjpd3N1Ux+fZgKS0DP1PmUh3W7jF5KdNmVPALncZcTHxi
 4e2R3HoO6cWU+F0z3wnFnA0o/6Mv77mu3QTb4BBEPqoyeYwvt0foxTOq5zR+eekusg
 P204089QZ+FWIwK8lrgvTRBmIHGsAH11ZlWHz+20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5.14 127/168] KVM: arm64: Restrict IPA size to maximum 48 bits
 on 4K and 16K page size
Date: Mon, 20 Sep 2021 18:44:25 +0200
Message-Id: <20210920163925.839290093@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Cc: Sasha Levin <sashal@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, stable@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 5e5df9571c319fb107d7a523cc96fcc99961ee70 ]

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1628680275-16578-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/reset.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cba7872d69a8..78d4bd897fbc 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -317,6 +317,14 @@ int kvm_set_ipa_limit(void)
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	parange = cpuid_feature_extract_unsigned_field(mmfr0,
 				ID_AA64MMFR0_PARANGE_SHIFT);
+	/*
+	 * IPA size beyond 48 bits could not be supported
+	 * on either 4K or 16K page size. Hence let's cap
+	 * it to 48 bits, in case it's reported as larger
+	 * on the system.
+	 */
+	if (PAGE_SIZE != SZ_64K)
+		parange = min(parange, (unsigned int)ID_AA64MMFR0_PARANGE_48);
 
 	/*
 	 * Check with ARMv8.5-GTG that our PAGE_SIZE is supported at
-- 
2.30.2



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
