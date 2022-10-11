Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEA5C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 06:17:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E9D64B63B;
	Tue, 11 Oct 2022 02:17:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bwTq20ouebao; Tue, 11 Oct 2022 02:17:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA9FF4B63F;
	Tue, 11 Oct 2022 02:17:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E2D34B638
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 02:17:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cgHpcTTFtO1i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Oct 2022 02:17:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0707540B8F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 02:17:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665469044;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=A9ZS0D2+thpmOhdj1R2mZDkXLTceBJH5yl2mi+5Q4vM=;
 b=eQpa3Hg94Ut+oioRI7Mmnh+xfkWI9g6fU26b7a9DDOsRkUo/ZDv6+K0fAUT4fBHOuU8OUk
 9/9K84MkwUMY1vXZGgXopc7YWXXflJiMaUgZE0Ova1Ku8nRh9zwwwHeRGu2Bf9S7XHxPax
 eRl+xyuxLBVCT0omi6sRQSxahLTcnQQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-DYMqC3IgNl-DL0I3mP_hYA-1; Tue, 11 Oct 2022 02:17:19 -0400
X-MC-Unique: DYMqC3IgNl-DL0I3mP_hYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3016185A792;
 Tue, 11 Oct 2022 06:17:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20105112D402;
 Tue, 11 Oct 2022 06:17:11 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v6 5/8] KVM: selftests: Enable
 KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP if possible
Date: Tue, 11 Oct 2022 14:14:44 +0800
Message-Id: <20221011061447.131531-6-gshan@redhat.com>
In-Reply-To: <20221011061447.131531-1-gshan@redhat.com>
References: <20221011061447.131531-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, shan.gavin@gmail.com, catalin.marinas@arm.com,
 dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP if it's supported. Otherwise,
we will fail to enable KVM_CAP_DIRTY_LOG_RING_ACQ_REL on aarch64.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 411a4c0bc81c..54740caea155 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -82,6 +82,9 @@ unsigned int kvm_check_cap(long cap)
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
+	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP))
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP, 0);
+
 	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
 		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL, ring_size);
 	else
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
