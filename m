Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E66BC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:50:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A86162070C
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONTYoNZH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A86162070C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2499E4AFBA;
	Tue, 21 Jan 2020 08:50:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FjBXj50v6ubG; Tue, 21 Jan 2020 08:50:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC5B4AFDC;
	Tue, 21 Jan 2020 08:50:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D08FC4AF2A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 00:57:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iEBanVOJ7Nr3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 00:57:12 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D36EC4AF27
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 00:57:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579586232;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=BGAXAa5VaHXPgggqPLCwDaDm1UbfpZCWsj65um9+hNM=;
 b=ONTYoNZHXhTwRbBZxvdpC4Ajg6vktsSkdfsaF5z5N3/7wsCaYGm0k3gPOLtF51faaf9ueL
 YZnvIeqbZXNkofASVj71zsIr0KbUn0RzR/fix6itRiJltb36KtA/xMYkVW8JcAMmTM+sX6
 2E+rP8OzRkG9kWWAD5X2Awp8urjKXI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-7Nc9kkgQPi2wF6YHEaFu0w-1; Tue, 21 Jan 2020 00:57:11 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDFA5800D41;
 Tue, 21 Jan 2020 05:57:09 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-75.bne.redhat.com
 [10.64.54.75])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8453389E9D;
 Tue, 21 Jan 2020 05:57:05 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm/arm64: Fix young bit from mmu notifier
Date: Tue, 21 Jan 2020 16:56:59 +1100
Message-Id: <20200121055659.19560-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 7Nc9kkgQPi2wF6YHEaFu0w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 21 Jan 2020 08:50:02 -0500
Cc: maz@kernel.org
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

kvm_test_age_hva() is called upon mmu_notifier_test_young(), but wrong
address range has been passed to handle_hva_to_gpa(). With the wrong
address range, no young bits will be checked in handle_hva_to_gpa().
It means zero is always returned from mmu_notifier_test_young().

This fixes the issue by passing correct address range to the underly
function handle_hva_to_gpa(), so that the hardware young (access) bit
will be visited.

Cc: stable@vger.kernel.org # v4.1+
Fixes: 35307b9a5f7e ("arm/arm64: KVM: Implement Stage-2 page aging")
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/arm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0b32a904a1bb..a2777efb558e 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2147,7 +2147,8 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	if (!kvm->arch.pgd)
 		return 0;
 	trace_kvm_test_age_hva(hva);
-	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
+	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
+				 kvm_test_age_hva_handler, NULL);
 }
 
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
