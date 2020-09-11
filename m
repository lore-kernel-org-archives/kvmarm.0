Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FF5C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 068C0221E7
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="z08YvyOM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 068C0221E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B18354B31F;
	Fri, 11 Sep 2020 09:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zB3kCc1Ax2WV; Fri, 11 Sep 2020 09:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95C64B43D;
	Fri, 11 Sep 2020 09:26:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1A24B331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n9xr8cQcQkKI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 09:26:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF1B04B415
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:29 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F391322224;
 Fri, 11 Sep 2020 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599830789;
 bh=+XNAajIc1t6cx/tFvSUuFerdwbHUuIBguS9pmk7s8u4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=z08YvyOMSbLaDBfahfcpPl8LyE49D2XeSubfi2yJPPfR/Hhv+lsiRXzV+6UHcYqTH
 dGHN5Qk53x5w0U67yqNfcqiDEKurW2YYtod5mD/z2G2JiT/fEdb829RQhHiGUJwZmQ
 hQpavZ7qCQc2GEmvoj02eyck478yVRgP5PXtCFqA=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 21/21] KVM: arm64: Don't constrain maximum IPA size based
 on host configuration
Date: Fri, 11 Sep 2020 14:25:29 +0100
Message-Id: <20200911132529.19844-22-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200911132529.19844-1-will@kernel.org>
References: <20200911132529.19844-1-will@kernel.org>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/reset.c | 40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ee33875c5c2a..2202b710d44c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -339,7 +339,7 @@ u32 get_kvm_ipa_limit(void)
 
 int kvm_set_ipa_limit(void)
 {
-	unsigned int ipa_max, pa_max, va_max, parange, tgran_2;
+	unsigned int parange, tgran_2;
 	u64 mmfr0;
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
@@ -376,39 +376,11 @@ int kvm_set_ipa_limit(void)
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
-	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
+	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
+	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
+	     "KVM IPA Size Limit (%d bits) is smaller than default size\n",
+	     kvm_ipa_limit);
+	kvm_info("IPA Size Limit: %d bits\n", kvm_ipa_limit);
 
 	return 0;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
