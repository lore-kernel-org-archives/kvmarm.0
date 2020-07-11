Return-Path: <SRS0=gvHH=AW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34ECC433E8
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jul 2020 10:04:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D83020720
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jul 2020 10:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ph5eN80m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D83020720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 163904B120;
	Sat, 11 Jul 2020 06:04:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h5fhMOVJqYxG; Sat, 11 Jul 2020 06:04:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E794B154;
	Sat, 11 Jul 2020 06:04:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5456B4B120
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2020 06:04:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9+BLLmOZS8qR for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Jul 2020 06:04:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A0C84B09B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2020 06:04:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1594461886;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=18RrGhQg0ryCP0Pu362q73pYYNwS6wZhRYL4lcHn4sk=;
 b=Ph5eN80m+pfMxsM5iZQCkZH6qXmHRWjV1OKGCSjNIRk4e5dX/gX3slT7dC89agnaY6j3Uc
 ICNEhoAOOSPpDfb/bfdiumes2m+PBC/HGGcfwu169JJ7I4fqiOeM3mqa6VVl+TK/3LyeV5
 /krKcweefwXjuw/YvwMWlp/LF5/KkX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-iXN-K2zNPIy_wH3ZXqwIBg-1; Sat, 11 Jul 2020 06:04:44 -0400
X-MC-Unique: iXN-K2zNPIy_wH3ZXqwIBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B90119057A0;
 Sat, 11 Jul 2020 10:04:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0ACB619D61;
 Sat, 11 Jul 2020 10:04:41 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/5] KVM: arm64: pvtime: Fix stolen time accounting across
 migration
Date: Sat, 11 Jul 2020 12:04:32 +0200
Message-Id: <20200711100434.46660-4-drjones@redhat.com>
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: pbonzini@redhat.com, steven.price@arm.com, maz@kernel.org
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

When updating the stolen time we should always read the current
stolen time from the user provided memory, not from a kernel
cache. If we use a cache then we'll end up resetting stolen time
to zero on the first update after migration.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/pvtime.c           | 23 +++++++++--------------
 include/linux/kvm_host.h          | 19 +++++++++++++++++++
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c3e6fcc664b1..b01f52b61572 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -343,7 +343,6 @@ struct kvm_vcpu_arch {
 
 	/* Guest PV state */
 	struct {
-		u64 steal;
 		u64 last_steal;
 		gpa_t base;
 	} steal;
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index db5ef097a166..025b5f3a97ef 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -13,26 +13,22 @@
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
+	u64 base = vcpu->arch.steal.base;
 	u64 last_steal = vcpu->arch.steal.last_steal;
-	u64 steal;
-	__le64 steal_le;
-	u64 offset;
+	u64 offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
+	u64 steal = 0;
 	int idx;
-	u64 base = vcpu->arch.steal.base;
 
 	if (base == GPA_INVALID)
 		return;
 
-	/* Let's do the local bookkeeping */
-	steal = vcpu->arch.steal.steal;
-	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
-	steal += vcpu->arch.steal.last_steal - last_steal;
-	vcpu->arch.steal.steal = steal;
-
-	steal_le = cpu_to_le64(steal);
 	idx = srcu_read_lock(&kvm->srcu);
-	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
-	kvm_put_guest(kvm, base + offset, steal_le, u64);
+	if (!kvm_get_guest(kvm, base + offset, steal, u64)) {
+		steal = le64_to_cpu(steal);
+		vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+		steal += vcpu->arch.steal.last_steal - last_steal;
+		kvm_put_guest(kvm, base + offset, cpu_to_le64(steal), u64);
+	}
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -68,7 +64,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	 * Start counting stolen time from the time the guest requests
 	 * the feature enabled.
 	 */
-	vcpu->arch.steal.steal = 0;
 	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
 
 	idx = srcu_read_lock(&kvm->srcu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d564855243d8..e2fc655f0b5b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -749,6 +749,25 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
 
+#define __kvm_get_guest(kvm, gfn, offset, x, type)			\
+({									\
+	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
+	type __user *__uaddr = (type __user *)(__addr + offset);	\
+	int __ret = -EFAULT;						\
+									\
+	if (!kvm_is_error_hva(__addr))					\
+		__ret = get_user(x, __uaddr);				\
+	__ret;								\
+})
+
+#define kvm_get_guest(kvm, gpa, x, type)				\
+({									\
+	gpa_t __gpa = gpa;						\
+	struct kvm *__kvm = kvm;					\
+	__kvm_get_guest(__kvm, __gpa >> PAGE_SHIFT,			\
+			offset_in_page(__gpa), x, type);		\
+})
+
 #define __kvm_put_guest(kvm, gfn, offset, value, type)			\
 ({									\
 	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
