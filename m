Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AAAC433E1
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AC1C22B42
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XcgA7ZQK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AC1C22B42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5D84B782;
	Tue,  4 Aug 2020 13:06:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0-BuOCr+bi1i; Tue,  4 Aug 2020 13:06:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0804B73E;
	Tue,  4 Aug 2020 13:06:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C4B14B136
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sMTCL+9rxE7x for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 13:06:14 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AF54B6DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596560774;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7HlVkiJnSNVI4x7t+z04fPiRVA5fdQRUo1magtB6wKU=;
 b=XcgA7ZQK5MoM/hxgkXuv7b+KBMcu53bt5u25uI/IdZ//IcBQnno7KHD0QR2hlTmgashjPL
 6n1bxTIjn4RLMPdyDnSuVs4tY9wKRxcF02wGQm5T4n1F9pYgGwRP4BHg/Uq4gHh8vjxtul
 OPu0tlP9rhflRnrnAiY0cGHJQXLTgHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-LBjWo_doM36pEaK3DmHtUg-1; Tue, 04 Aug 2020 13:06:13 -0400
X-MC-Unique: LBjWo_doM36pEaK3DmHtUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2A36106B243;
 Tue,  4 Aug 2020 17:06:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
 by smtp.corp.redhat.com (Postfix) with ESMTP id EBA4C88D58;
 Tue,  4 Aug 2020 17:06:09 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/6] KVM: arm64: pvtime: Fix potential loss of stolen time
Date: Tue,  4 Aug 2020 19:06:00 +0200
Message-Id: <20200804170604.42662-3-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: maz@kernel.org, pbonzini@redhat.com, steven.price@arm.com
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

We should only check current->sched_info.run_delay once when
updating stolen time. Otherwise there's a chance there could
be a change between checks that we miss (preemption disabling
comes after vcpu request checks).

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index c3ef4ebd6846..95f9580275b1 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -13,6 +13,7 @@
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
+	u64 last_steal = vcpu->arch.steal.last_steal;
 	u64 steal;
 	__le64 steal_le;
 	u64 offset;
@@ -24,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 
 	/* Let's do the local bookkeeping */
 	steal = vcpu->arch.steal.steal;
-	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
-	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
+	steal += vcpu->arch.steal.last_steal - last_steal;
 	vcpu->arch.steal.steal = steal;
 
 	steal_le = cpu_to_le64(steal);
-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
