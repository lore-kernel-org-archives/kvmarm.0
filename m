Return-Path: <SRS0=snoh=CD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C097C433E1
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA1202074D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oL8vxTpR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA1202074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 945BE4C04F;
	Tue, 25 Aug 2020 05:40:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8TISM8rXuBns; Tue, 25 Aug 2020 05:40:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9344BFF4;
	Tue, 25 Aug 2020 05:40:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 116174BFDB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Um2Q4tVOF5Ct for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Aug 2020 05:40:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB26A4BE71
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:48 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7BD3520706;
 Tue, 25 Aug 2020 09:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598348448;
 bh=jrWsDu1BIunwcNrTEgIMwFEYkK2KzW+U1zZqvUJ6Srs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oL8vxTpRQLE3+pemV2OcFX7IDULOOA9HPKnbOyEmB2gOr7ImjE8MkXhvvIpv7NyPQ
 PBA2VKuW4fiON0Vgxb9bbwtkEeYG1ycB5dzDOYBYORdW/4jLo2sFoqy287vWgg4xEU
 uhWhAfOhHnqfiw/bV6fikXVHXdNB/QNoGXaFhpDM=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 21/21] KVM: arm64: Don't constrain maximum IPA size based
 on host configuration
Date: Tue, 25 Aug 2020 10:39:53 +0100
Message-Id: <20200825093953.26493-22-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200825093953.26493-1-will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Now that the guest stage-2 page-tables are managed independently from
the host stage-1 page-tables, we can avoid constraining the IPA size
based on the host and instead limit it only based on the PARange field
of the ID_AA64MMFR0 register.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/reset.c | 38 +++++---------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ee33875c5c2a..471ee9234e40 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -339,7 +339,7 @@ u32 get_kvm_ipa_limit(void)
 
 int kvm_set_ipa_limit(void)
 {
-	unsigned int ipa_max, pa_max, va_max, parange, tgran_2;
+	unsigned int parange, tgran_2;
 	u64 mmfr0;
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
@@ -376,38 +376,10 @@ int kvm_set_ipa_limit(void)
 		break;
 	}
 
-	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
-
-	/* Clamp the IPA limit to the PA size supported by the kernel */
-	ipa_max = (pa_max > PHYS_MASK_SHIFT) ? PHYS_MASK_SHIFT : pa_max;
-	/*
-	 * Since our stage2 table is dependent on the stage1 page table code,
-	 * we must always honor the following condition:
-	 *
-	 *  Number of levels in Stage1 >= Number of levels in Stage2.
-	 *
-	 * So clamp the ipa limit further down to limit the number of levels.
-	 * Since we can concatenate upto 16 tables at entry level, we could
-	 * go upto 4bits above the maximum VA addressable with the current
-	 * number of levels.
-	 */
-	va_max = PGDIR_SHIFT + PAGE_SHIFT - 3;
-	va_max += 4;
-
-	if (va_max < ipa_max)
-		ipa_max = va_max;
-
-	/*
-	 * If the final limit is lower than the real physical address
-	 * limit of the CPUs, report the reason.
-	 */
-	if (ipa_max < pa_max)
-		pr_info("kvm: Limiting the IPA size due to kernel %s Address limit\n",
-			(va_max < pa_max) ? "Virtual" : "Physical");
-
-	WARN(ipa_max < KVM_PHYS_SHIFT,
-	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
-	kvm_ipa_limit = ipa_max;
+	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
+	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
+	     "KVM IPA limit (%d bit) is smaller than default size\n",
+	     kvm_ipa_limit);
 	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
 
 	return 0;
-- 
2.28.0.297.g1956fa8f8d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
