Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F234C55178
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C827020756
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMzaZswC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C827020756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 603034B21B;
	Fri, 30 Oct 2020 12:40:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YzYdw7xT4CuC; Fri, 30 Oct 2020 12:40:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D0844B5AB;
	Fri, 30 Oct 2020 12:40:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5F44B21C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7KvBhqY6RLut for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:40:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C9744B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:30 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4E0F42083B;
 Fri, 30 Oct 2020 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076029;
 bh=gtN4RQwcHpFVJT3JZbmt4zNSOYqUGAv+JQxZ8TNJjQU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IMzaZswCuWdtSH0r0ygl16uS/zBWiJD3XemxJTtq2moCEQ3M4j3cKPakx5glsDpXI
 LedoXdyrAD7dBEvgf2LuoLL2hEocoJDXuAvlwW/9qi3solmcKV+6aj4UoSE8ZXSU6C
 oILqlwEQrpHSGyjUTZWnUb+mRZScxVB3Wo2I5MoU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXRz-005noK-H6; Fri, 30 Oct 2020 16:40:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/12] KVM: arm64: Use fallback mapping sizes for contiguous
 huge page sizes
Date: Fri, 30 Oct 2020 16:40:12 +0000
Message-Id: <20201030164017.244287-8-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com,
 james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com,
 qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Qais Yousef <qais.yousef@arm.com>
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

From: Gavin Shan <gshan@redhat.com>

Although huge pages can be created out of multiple contiguous PMDs
or PTEs, the corresponding sizes are not supported at Stage-2 yet.

Instead of failing the mapping, fall back to the nearer supported
mapping size (CONT_PMD to PMD and CONT_PTE to PTE respectively).

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
[maz: rewritten commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201025230626.18501-1-gshan@redhat.com
---
 arch/arm64/kvm/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a816cb8e619b..e431d2d8e368 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -787,14 +787,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = PAGE_SHIFT;
 	}
 
-	if (vma_shift == PUD_SHIFT &&
-	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-	       vma_shift = PMD_SHIFT;
-
-	if (vma_shift == PMD_SHIFT &&
-	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		force_pte = true;
+	switch (vma_shift) {
+	case PUD_SHIFT:
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+			break;
+		fallthrough;
+	case CONT_PMD_SHIFT:
+		vma_shift = PMD_SHIFT;
+		fallthrough;
+	case PMD_SHIFT:
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+			break;
+		fallthrough;
+	case CONT_PTE_SHIFT:
 		vma_shift = PAGE_SHIFT;
+		force_pte = true;
+		fallthrough;
+	case PAGE_SHIFT:
+		break;
+	default:
+		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 	}
 
 	vma_pagesize = 1UL << vma_shift;
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
