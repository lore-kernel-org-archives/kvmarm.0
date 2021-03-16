Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35096C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:11:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB60F650E6
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB60F650E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CF284B4FA;
	Tue, 16 Mar 2021 00:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S48eGQNyTdDE; Tue, 16 Mar 2021 00:11:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E264B4FC;
	Tue, 16 Mar 2021 00:11:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 609184B4FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X7nsbQVN91aQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 00:11:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 776304B4EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:11:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615867904;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7t4qhw6jU/9PDoGhNsF+pqlTZlOK7T+vOjDSD8iGPHM=;
 b=WuX/WLDOq2qIKwOGfHwXLnMwHST/kQb7NDYY/AhA3hCJIWWDc60/gN63TgFMcE0tYZHyzj
 wscNkvr4g0kxUUmW8sDGWxU02nX0M7RbKQedY6Ky1YRmH/feJbryU4yTXYtp+JfWjWeUnF
 q4xBq1ewyUQj0GE1SDlbbp+LBtgJJho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-xm_PCw3wM5SPZqY9qc6T6Q-1; Tue, 16 Mar 2021 00:11:40 -0400
X-MC-Unique: xm_PCw3wM5SPZqY9qc6T6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 132AE1074659;
 Tue, 16 Mar 2021 04:11:39 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTP id EE6995B4A8;
 Tue, 16 Mar 2021 04:11:36 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/3] KVM: arm64: Use find_vma_intersection()
Date: Tue, 16 Mar 2021 12:11:25 +0800
Message-Id: <20210316041126.81860-3-gshan@redhat.com>
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

find_vma_intersection() has been existing to search the intersected
vma. This uses the function where it's applicable, to simplify the
code.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 28f3b3736dc8..192e0df2fc8e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -421,10 +421,11 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	 *     +--------------------------------------------+
 	 */
 	do {
-		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		struct vm_area_struct *vma;
 		hva_t vm_start, vm_end;
 
-		if (!vma || vma->vm_start >= reg_end)
+		vma = find_vma_intersection(current->mm, hva, reg_end);
+		if (!vma)
 			break;
 
 		/*
@@ -1329,10 +1330,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 *     +--------------------------------------------+
 	 */
 	do {
-		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		struct vm_area_struct *vma;
 		hva_t vm_start, vm_end;
 
-		if (!vma || vma->vm_start >= reg_end)
+		vma = find_vma_intersection(current->mm, hva, reg_end);
+		if (!vma)
 			break;
 
 		/*
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
