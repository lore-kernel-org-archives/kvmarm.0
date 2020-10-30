Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64292C00A89
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE0C820727
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbntlizH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE0C820727
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B574B32C;
	Fri, 30 Oct 2020 12:40:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Do3g5BfqET63; Fri, 30 Oct 2020 12:40:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 530D74B4E8;
	Fri, 30 Oct 2020 12:40:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D3C64B502
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kOKJJiq8P0Jx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:40:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E74E4B21B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9474B221EB;
 Fri, 30 Oct 2020 16:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076028;
 bh=KGWPYmZiPDvFv1f0Es+fc6Vw18AcklCgwiLjk6xgWEs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HbntlizH+1kn1Nvito1xAPwkP9UFkB/mD4CTWWesc6SqWn9KAYChNAK0Lg5nROqDL
 c1ilU59wQ5NMy+I7wY/ExiINWXk/0cbP/0+i70cGqeKK7BZhnhzzu7+CVYcb3BW9CD
 3jmeT3TvAv2geR1H7hh5ZF6isyW+hjZP1HZYkH/Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXRy-005noK-PY; Fri, 30 Oct 2020 16:40:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 06/12] KVM: arm64: Fix masks in stage2_pte_cacheable()
Date: Fri, 30 Oct 2020 16:40:11 +0000
Message-Id: <20201030164017.244287-7-maz@kernel.org>
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

From: Will Deacon <will@kernel.org>

stage2_pte_cacheable() tries to figure out whether the mapping installed
in its 'pte' parameter is cacheable or not. Unfortunately, it fails
miserably because it extracts the memory attributes from the entry using
FIELD_GET(), which returns the attributes shifted down to bit 0, but then
compares this with the unshifted value generated by the PAGE_S2_MEMATTR()
macro.

A direct consequence of this bug is that cache maintenance is silently
skipped, which in turn causes 32-bit guests to crash early on when their
set/way maintenance is trapped but not emulated correctly.

Fix the broken masks by avoiding the use of FIELD_GET() altogether.

Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20201029144716.30476-1-will@kernel.org
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 95141b0d6088..0271b4a3b9fe 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -635,7 +635,7 @@ static void stage2_flush_dcache(void *addr, u64 size)
 
 static bool stage2_pte_cacheable(kvm_pte_t pte)
 {
-	u64 memattr = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR, pte);
+	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
 	return memattr == PAGE_S2_MEMATTR(NORMAL);
 }
 
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
