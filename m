Return-Path: <SRS0=oSDe=EA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A43C4363A
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 23:06:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6218223BD
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 23:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEJF9f98"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6218223BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12EC94BB9D;
	Sun, 25 Oct 2020 19:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jIDOp0Hzo2Xc; Sun, 25 Oct 2020 19:06:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03C4A4BB89;
	Sun, 25 Oct 2020 19:06:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1AB84BB89
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Oct 2020 19:06:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CVK4Ih54aOXY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Oct 2020 19:06:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AEDB4BB7A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Oct 2020 19:06:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603667196;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=7BRGU5rTEtGL07TDZZjVTtYyTgqopSVQ1gclv9XT9uU=;
 b=XEJF9f98Bt7+Zjy/3qjtIFYNx0kluMMPGQKiSavTBRNnZ3/2P2gctg7UegQ1NVNLAMcXBD
 EhPrTK+8KYZrwBvHk+YN6nchhhJwngoPITjW1vk58QqhpTemcjYOQpan/HXhk3fYdLEyN7
 CQCqQVmf2IeRhupkwBx+UAqKW7mQCMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-oheGtoIiOby-lNTQdRm2mQ-1; Sun, 25 Oct 2020 19:06:32 -0400
X-MC-Unique: oheGtoIiOby-lNTQdRm2mQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C9B68030CB;
 Sun, 25 Oct 2020 23:06:31 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-35.bne.redhat.com [10.64.54.35])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A503860BF3;
 Sun, 25 Oct 2020 23:06:29 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: arm64: Failback on unsupported huge page sizes
Date: Mon, 26 Oct 2020 10:06:26 +1100
Message-Id: <20201025230626.18501-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: will@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com
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

The huge page could be mapped through multiple contiguous PMDs or PTEs.
The corresponding huge page sizes aren't supported by the page table
walker currently.

This fails the unsupported huge page sizes to the near one. Otherwise,
the guest can't boot successfully: CONT_PMD_SHIFT and CONT_PTE_SHIFT
fail back to PMD_SHIFT and PAGE_SHIFT separately.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
v2: Reorganize the code as Marc suggested
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
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
