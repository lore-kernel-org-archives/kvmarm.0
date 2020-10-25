Return-Path: <SRS0=oSDe=EA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D52C55179
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 00:27:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16120222B9
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 00:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hb4kumo7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16120222B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C1D4BA98;
	Sat, 24 Oct 2020 20:27:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eOjdps8U9E9i; Sat, 24 Oct 2020 20:27:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4681D4B972;
	Sat, 24 Oct 2020 20:27:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5054B9A5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2020 20:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KLJQn+vrA-9C for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Oct 2020 20:27:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4857E4B96A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2020 20:27:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603585669;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=iOSUoowuEp25G04aIP7AbuswglFDkH8pCpq/5LlyW/Y=;
 b=hb4kumo73BxscwgkUBbHiW6HgJlGnt0KHR24WBt4KSNyLilq0WhjmO415H0ZGOFIGqDfxp
 3JaNv3QEqY4p2t7koEOAiNvOhWb8d0UDDVusfOn96vj6Hi3+669enRUFsuPsoDkJa++t+s
 lx5gPu5qG06xs1M97fKrr/WX+Lo28Lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-NV28RzB-OLCVaqiRnSNZ3g-1; Sat, 24 Oct 2020 20:27:47 -0400
X-MC-Unique: NV28RzB-OLCVaqiRnSNZ3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 446665F9F3;
 Sun, 25 Oct 2020 00:27:46 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-35.bne.redhat.com [10.64.54.35])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 045AB5C1DA;
 Sun, 25 Oct 2020 00:27:43 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/3] KVM: arm64: Failback on unsupported huge pages
Date: Sun, 25 Oct 2020 11:27:36 +1100
Message-Id: <20201025002739.5804-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: will@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
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

Guest fails to boot when the memory is backed up by hugetlbfs regions,
which correspond to contiguous PMDs or PTEs. For example, the guest
fails to boot when its memory is backed up by 64KB hugetlbfs pages.

The first two patches are sorts of cleanup, not introducing any logical
changes. The last patch resolves the issue by fail the unsupported huge
page sizes back to nearby one. Ideally, we teach the stage-2 page table
to use contiguous mapping in this case, but the page-table walker doesn't
it well and needs some sort of reworks and I will do that in the future.

Gavin Shan (3):
  KVM: arm64: Check if 52-bits PA is enabled
  KVM: arm64: Don't map PUD huge page if it's not available
  KVM: arm64: Failback on unsupported huge page sizes

 arch/arm64/kvm/hyp/pgtable.c | 10 ++++++----
 arch/arm64/kvm/mmu.c         | 12 +++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
