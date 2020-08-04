Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71621C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26CAA208C7
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUjuzYk8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26CAA208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C93604B758;
	Tue,  4 Aug 2020 13:06:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VHOiGpZWquav; Tue,  4 Aug 2020 13:06:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B32604B57A;
	Tue,  4 Aug 2020 13:06:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E10304B532
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cdV9ZCQV-gzX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 13:06:19 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C12494B72F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596560778;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4r8eOHvP6f0oDrekacIxhK5fe0vBr0vL63RZi5tQK4o=;
 b=GUjuzYk8+kG7DB7O6nrd9OP2IwcwqB7Xek2R2l0wV0waRgsVQNOwkdCU4SWyI8MWmTOit8
 j/JDYoDuMH8pTD5sBzbu310d1SgWtXItvC2NL3TMbWE3ZIkNv9Qe/ZkfGwc2+1CKYQGUMt
 AxFq/YQarf3NhCBYQnEykN412ytGvm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-gsF3w5IWPf2mkKvi0ZLVrw-1; Tue, 04 Aug 2020 13:06:14 -0400
X-MC-Unique: gsF3w5IWPf2mkKvi0ZLVrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE6D157;
 Tue,  4 Aug 2020 17:06:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1C85272E48;
 Tue,  4 Aug 2020 17:06:11 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/6] KVM: arm64: Drop type input from kvm_put_guest
Date: Tue,  4 Aug 2020 19:06:01 +0200
Message-Id: <20200804170604.42662-4-drjones@redhat.com>
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

We can use typeof() to avoid the need for the type input.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c  |  2 +-
 include/linux/kvm_host.h | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 95f9580275b1..241ded7ee0ad 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -32,7 +32,7 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	steal_le = cpu_to_le64(steal);
 	idx = srcu_read_lock(&kvm->srcu);
 	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
-	kvm_put_guest(kvm, base + offset, steal_le, u64);
+	kvm_put_guest(kvm, base + offset, steal_le);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d564855243d8..cf51b06a5edd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -749,25 +749,26 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
 
-#define __kvm_put_guest(kvm, gfn, offset, value, type)			\
+#define __kvm_put_guest(kvm, gfn, offset, v)				\
 ({									\
 	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
-	type __user *__uaddr = (type __user *)(__addr + offset);	\
+	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
 	int __ret = -EFAULT;						\
 									\
 	if (!kvm_is_error_hva(__addr))					\
-		__ret = put_user(value, __uaddr);			\
+		__ret = put_user(v, __uaddr);				\
 	if (!__ret)							\
 		mark_page_dirty(kvm, gfn);				\
 	__ret;								\
 })
 
-#define kvm_put_guest(kvm, gpa, value, type)				\
+#define kvm_put_guest(kvm, gpa, v)					\
 ({									\
 	gpa_t __gpa = gpa;						\
 	struct kvm *__kvm = kvm;					\
+									\
 	__kvm_put_guest(__kvm, __gpa >> PAGE_SHIFT,			\
-			offset_in_page(__gpa), (value), type);		\
+			offset_in_page(__gpa), v);			\
 })
 
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
