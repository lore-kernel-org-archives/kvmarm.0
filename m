Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11966C38A2B
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBC2520775
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Maq4iTIY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBC2520775
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739574B254;
	Wed, 15 Apr 2020 05:23:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mm4pu0yN26j6; Wed, 15 Apr 2020 05:23:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D95C4B22B;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6104B1D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 04:43:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3eRyN2iWZgy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 04:43:44 -0400 (EDT)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com
 [207.171.184.29])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CC434B1D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 04:43:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1586940225; x=1618476225;
 h=from:to:cc:subject:date:message-id;
 bh=EMYtFdH844Gy8q0zDObO0i3soKGeCT1N6ZnKHQH7qjI=;
 b=Maq4iTIYb0FmOKjDfKztvMbToKSVLsmNYVIgLHXlsQ+zjv9iXA2hMHRU
 lviHfUr1bXe2r6uKskP9lwBiBKn5MglqfEupM9ITcNc4J1Lprct4/qQwo
 ZYMhpAIS6KkCjRL6vv9kTF/nF8UfjFAtdfXoCgNvtPyc/th8ox1j0OaFf 4=;
IronPort-SDR: sh/mYkNm0w7U8qD8vmxXEf50rvhX5vgl8boba5UFNT+Gie7eTRc2Nu1whcyXfttLtiJVNkb6Bf
 2HJbI0RIxMHQ==
X-IronPort-AV: E=Sophos;i="5.72,386,1580774400"; d="scan'208";a="37157160"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO
 email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
 by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP;
 15 Apr 2020 08:43:42 +0000
Received: from u8ac3f2494b6e5c.ant.amazon.com
 (iad7-ws-svc-lb50-vlan2.amazon.com [10.0.93.210])
 by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS
 id F023DA218E; Wed, 15 Apr 2020 08:43:37 +0000 (UTC)
Received: from u8ac3f2494b6e5c.ant.amazon.com (localhost [127.0.0.1])
 by u8ac3f2494b6e5c.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTPS id
 03F8hZjA007973
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
 Wed, 15 Apr 2020 10:43:35 +0200
Received: (from giangyi@localhost)
 by u8ac3f2494b6e5c.ant.amazon.com (8.15.2/8.15.2/Submit) id 03F8hYvM007966;
 Wed, 15 Apr 2020 10:43:34 +0200
From: Jiang Yi <giangyi@amazon.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm/arm64: release kvm->mmu_lock in loop to prevent
 starvation
Date: Wed, 15 Apr 2020 10:42:29 +0200
Message-Id: <20200415084229.29992-1-giangyi@amazon.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Wed, 15 Apr 2020 05:23:47 -0400
Cc: Jiang Yi <giangyi@amazon.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Do cond_resched_lock() in stage2_flush_memslot() like what is done in
unmap_stage2_range() and other places holding mmu_lock while processing
a possibly large range of memory.

Signed-off-by: Jiang Yi <giangyi@amazon.com>
---
 virt/kvm/arm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e3b9ee268823..7315af2c52f8 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -417,16 +417,19 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t next;
 	pgd_t *pgd;
 
 	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (!stage2_pgd_none(kvm, *pgd))
 			stage2_flush_puds(kvm, pgd, addr, next);
+
+		if (next != end)
+			cond_resched_lock(&kvm->mmu_lock);
 	} while (pgd++, addr = next, addr != end);
 }
 
 /**
  * stage2_flush_vm - Invalidate cache for pages mapped in stage 2
  * @kvm: The struct kvm pointer
  *
  * Go through the stage 2 page tables and invalidate any cache lines
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
