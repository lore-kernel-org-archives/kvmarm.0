Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EA1C32771
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 00:32:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6010B4B62B;
	Wed, 21 Sep 2022 20:32:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id os1ve1lbroUa; Wed, 21 Sep 2022 20:32:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA5664B2B4;
	Wed, 21 Sep 2022 20:32:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4564B287
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CF9pmVl7L7Fj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 20:32:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 649554B1C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:32:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663806755;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WyxjX46AY433SpYYD578c0mv7OskG8wRb+P4j+4lyPU=;
 b=jEkAHeGKR7DAsWpiWxmkt6p94OMPFAvsh9wmyb2AZXK6kRsMLtuAo/gXX+kirrrTMlciTl
 TAbbqOAgDdHBuNHA/W24FSNJw54GwZcjZaZQzRbOwNUFThQrZnWMLguQ2LYlVmzeWtZc+Y
 P0HSRshzRO8wTohdv9MJZRsaOWLhonc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491--Vg5T97KOdWH8oZHh0NAQA-1; Wed, 21 Sep 2022 20:32:31 -0400
X-MC-Unique: -Vg5T97KOdWH8oZHh0NAQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4AE01C14B65;
 Thu, 22 Sep 2022 00:32:30 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7845C2166B26;
 Thu, 22 Sep 2022 00:32:25 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 1/6] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Date: Thu, 22 Sep 2022 08:32:09 +0800
Message-Id: <20220922003214.276736-2-gshan@redhat.com>
In-Reply-To: <20220922003214.276736-1-gshan@redhat.com>
References: <20220922003214.276736-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org
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

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/x86/kvm/x86.c       | 19 ++++++++++---------
 include/linux/kvm_host.h |  1 +
 virt/kvm/dirty_ring.c    |  4 ++++
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..18a4da71989e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10264,16 +10264,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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
+		if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
+		    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
+			kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
+			trace_kvm_dirty_ring_exit(vcpu);
+			r = 0;
+			goto out;
+		}
+
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
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
index f4c2a6eb1666..f0e49937bc9e 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -149,6 +149,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 
 void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
 {
+	struct kvm_vcpu *vcpu = container_of(ring, struct kvm_vcpu, dirty_ring);
 	struct kvm_dirty_gfn *entry;
 
 	/* It should never get full */
@@ -166,6 +167,9 @@ void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
 	kvm_dirty_gfn_set_dirtied(entry);
 	ring->dirty_index++;
 	trace_kvm_dirty_ring_push(ring, slot, offset);
+
+	if (kvm_dirty_ring_soft_full(ring))
+		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
 }
 
 struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
