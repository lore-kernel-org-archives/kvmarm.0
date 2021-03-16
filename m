Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4F7C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:11:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9A29650E2
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9A29650E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7AD4B34C;
	Tue, 16 Mar 2021 00:11:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 42SdjCrfX8sM; Tue, 16 Mar 2021 00:11:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BD44B50E;
	Tue, 16 Mar 2021 00:11:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE24B4B4EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DE-6h1y2FwQH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 00:11:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D044B442
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:11:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615867904;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hGQu6Iyp8Y2I2yKE1NAdsEcAZL0FpRmrQ13l4m0YyJc=;
 b=MBc3gFf5iRlLxGaDbdHUiXaN49ic4PF/b4bfjYmmJGBo9foiQ6rmnfajMvAG4c6A5WyOHl
 kVYKsyUtlZ3/15fE1SxI5sGmo40MTZNqTGQQLx1Ks8ewCsyIB4f61deNQsC2irkGzwkEr/
 Ms8eAgxhzqYJIWVUe9VUBiVmiFBOr9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-wInswR3qPoeVpv7yQz-IlA-1; Tue, 16 Mar 2021 00:11:42 -0400
X-MC-Unique: wInswR3qPoeVpv7yQz-IlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2658D107ACCA;
 Tue, 16 Mar 2021 04:11:41 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 73C595B4A8;
 Tue, 16 Mar 2021 04:11:39 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/3] KVM: arm64: Don't retrieve memory slot again in page
 fault handler
Date: Tue, 16 Mar 2021 12:11:26 +0800
Message-Id: <20210316041126.81860-4-gshan@redhat.com>
In-Reply-To: <20210316041126.81860-1-gshan@redhat.com>
References: <20210316041126.81860-1-gshan@redhat.com>
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

We needn't retrieve the memory slot again in user_mem_abort() because
the corresponding memory slot has been passed from the caller. This
would save some CPU cycles. For example, the time used to write 1GB
memory, which is backed by 2MB hugetlb pages and write-protected, is
dropped by 6.8% from 928ms to 864ms.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 192e0df2fc8e..2491b40a294a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -843,10 +843,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * unmapped afterwards, the call to kvm_unmap_hva will take it away
 	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
 	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
+	 *
+	 * Besides, __gfn_to_pfn_memslot() instead of gfn_to_pfn_prot() is
+	 * used to avoid unnecessary overhead introduced to locate the memory
+	 * slot because it's always fixed even @gfn is adjusted for huge pages.
 	 */
 	smp_rmb();
 
-	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+				   write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -912,7 +917,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
-		mark_page_dirty(kvm, gfn);
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
 out_unlock:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
