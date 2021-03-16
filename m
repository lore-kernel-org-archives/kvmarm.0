Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59673C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:11:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2BDE650DF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2BDE650DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 085874B48A;
	Tue, 16 Mar 2021 00:11:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nw7ziyIBcskA; Tue, 16 Mar 2021 00:11:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 019E04B405;
	Tue, 16 Mar 2021 00:11:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D7C4B3EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:11:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pdVKyW8uxBjt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 00:11:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7F8D4B3DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:11:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615867897;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=r+17IQWtv/wBkvaPEi3N+nCMeCCp+098AbtNh4M0c3Y=;
 b=UxCMgkd9o7vTzlcJT8secyWdXU/iKOgHjw+buygyVtWzRXlQrEwphhrnIH7nOxZLFcSTv8
 TdEfNAib8kGwZ1K1xpU8gtrmOim5PGr/BsEaW/TuXF6w+1GCfG9KqGBxYgZ/wTYlAhzyA8
 jy3KqqCuuZP6ggg1zXSBTVqVRU/gnkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-FGuNs7kmNfimLMJbDYVnPA-1; Tue, 16 Mar 2021 00:11:34 -0400
X-MC-Unique: FGuNs7kmNfimLMJbDYVnPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E210107ACCA;
 Tue, 16 Mar 2021 04:11:33 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2E15F5B4A8;
 Tue, 16 Mar 2021 04:11:29 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/3] KVM: arm64: Minor page fault handler improvement
Date: Tue, 16 Mar 2021 12:11:23 +0800
Message-Id: <20210316041126.81860-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com
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

The series includes several minior improvements to stage-2 page fault
handler: PATCH[1/2] are cleaning up the code. PATCH[3] don't retrieve
the memory slot again in the page fault handler to save a bit CPU cycles.

Changelog
=========
v2:
   * Rebased to 5.12.rc3 and include r-bs from Keqian  (Gavin)
   * Drop patch to fix IPA limit boundary issue        (Keqian)
   * Comments on why we use __gfn_to_pfn_memslot()     (Keqian)

Gavin Shan (3):
  KVM: arm64: Hide kvm_mmu_wp_memory_region()
  KVM: arm64: Use find_vma_intersection()
  KVM: arm64: Don't retrieve memory slot again in page fault handler

 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/mmu.c              | 21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
