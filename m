Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F75FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 06:17:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBCB94B631;
	Tue, 11 Oct 2022 02:16:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WUwM0iLH94K4; Tue, 11 Oct 2022 02:16:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D574B256;
	Tue, 11 Oct 2022 02:16:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6D540E62
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 02:16:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mq0UinVUGZEo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Oct 2022 02:16:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B4140D0B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2022 02:16:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665469016;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rSkJSga6R9+gIcyTz8ya36SwfXawsfAyNINRVrliHkE=;
 b=jJ+S2tBoKwp+KZiW2+w3SOfi0NXDq/RcIYNnuphrF9Cj4wMraV14IuIWBTXR5aRjjEhWEz
 UW+ElSg9sKQmB0IeQpVuXHbwmiVrFd37XqSukdfa+JRLuSmb2+5WtOKi23mja9+IbqveEj
 eX5Ydr7Ju0US9gE55/rzd7B0VRPW+ks=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-Lj8GXNUTNU-aSE7T2_D8DA-1; Tue, 11 Oct 2022 02:16:51 -0400
X-MC-Unique: Lj8GXNUTNU-aSE7T2_D8DA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A0DD3804505;
 Tue, 11 Oct 2022 06:16:50 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D46B8112D402;
 Tue, 11 Oct 2022 06:16:43 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Date: Tue, 11 Oct 2022 14:14:40 +0800
Message-Id: <20221011061447.131531-2-gshan@redhat.com>
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

This adds KVM_REQ_RING_SOFT_FULL, which is raised when the dirty
ring of the specific VCPU becomes softly full in kvm_dirty_ring_push().
The VCPU is enforced to exit when the request is raised and its
dirty ring is softly full on its entrance.

The event is checked and handled in the newly introduced helper
kvm_dirty_ring_check_request(). With this, kvm_dirty_ring_soft_full()
becomes a private function.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c             | 15 ++++++---------
 include/linux/kvm_dirty_ring.h |  8 ++------
 include/linux/kvm_host.h       |  1 +
 virt/kvm/dirty_ring.c          | 19 ++++++++++++++++++-
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0c47b41c264..0dd0d32073e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10260,16 +10260,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	bool req_immediate_exit = false;
 
-	/* Forbid vmenter if vcpu dirty ring is soft-full */
-	if (unlikely(vcpu->kvm->dirty_ring_size &&
-		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
-		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
-		trace_kvm_dirty_ring_exit(vcpu);
-		r = 0;
-		goto out;
-	}
-
 	if (kvm_request_pending(vcpu)) {
+		/* Forbid vmenter if vcpu dirty ring is soft-full */
+		if (kvm_dirty_ring_check_request(vcpu)) {
+			r = 0;
+			goto out;
+		}
+
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 906f899813dc..66508afa0b40 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -64,11 +64,6 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 {
 }
 
-static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
-{
-	return true;
-}
-
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
 u32 kvm_dirty_ring_get_rsvd_entries(void);
@@ -86,11 +81,12 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
  */
 void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset);
 
+bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu);
+
 /* for use in vm_operations_struct */
 struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
 
 void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
-bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
 
 #endif /* CONFIG_HAVE_KVM_DIRTY_RING */
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..53fa3134fee0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -157,6 +157,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_RING_SOFT_FULL    4
 #define KVM_REQUEST_ARCH_BASE     8
 
 /*
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index d6fabf238032..f68d75026bc0 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -26,7 +26,7 @@ static u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
 	return READ_ONCE(ring->dirty_index) - READ_ONCE(ring->reset_index);
 }
 
-bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
+static bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
 {
 	return kvm_dirty_ring_used(ring) >= ring->soft_limit;
 }
@@ -149,6 +149,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 
 void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
 {
+	struct kvm_vcpu *vcpu = container_of(ring, struct kvm_vcpu, dirty_ring);
 	struct kvm_dirty_gfn *entry;
 
 	/* It should never get full */
@@ -166,6 +167,22 @@ void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
 	kvm_dirty_gfn_set_dirtied(entry);
 	ring->dirty_index++;
 	trace_kvm_dirty_ring_push(ring, slot, offset);
+
+	if (kvm_dirty_ring_soft_full(ring))
+		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
+}
+
+bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
+		kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
+		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
+		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
+		trace_kvm_dirty_ring_exit(vcpu);
+		return true;
+	}
+
+	return false;
 }
 
 struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
