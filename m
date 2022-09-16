Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D20ECAAD8
	for <kvmarm@archiver.kernel.org>; Fri, 16 Sep 2022 04:52:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF9D4BC5A;
	Fri, 16 Sep 2022 00:52:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aj767vgcm+PZ; Fri, 16 Sep 2022 00:52:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF544BC7A;
	Fri, 16 Sep 2022 00:52:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0814BC59
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 00:52:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HCEhpLzK6QqQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 00:52:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 772554BBD1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 00:52:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663303921;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vOBgBY51VPGo3XH10vBQxgJ7uR9+D8WGU5ehFHOdBgE=;
 b=SakMMRyN1K16ggSSiS2Rs7APo+wE36ehdkt4qFg8JdlnXwqV8FrrxaTp4ZxAgk4FbtL1A3
 d/LvrvZKFgIUcaP/7XwQtG6RNZ+xa4bK+5xo0ASXYnpKTIAJx6hsEE0N84Ss3JYOg4sACD
 qfR7zAu26RjZ65Q9sTvaBIWLdhWvpaA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-pQbKUtYYOCaCmTQgQlG5hw-1; Fri, 16 Sep 2022 00:51:56 -0400
X-MC-Unique: pQbKUtYYOCaCmTQgQlG5hw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE9BB3C0D865;
 Fri, 16 Sep 2022 04:51:55 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CFBB140EBF3;
 Fri, 16 Sep 2022 04:51:48 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/5] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Date: Fri, 16 Sep 2022 12:51:31 +0800
Message-Id: <20220916045135.154505-2-gshan@redhat.com>
In-Reply-To: <20220916045135.154505-1-gshan@redhat.com>
References: <20220916045135.154505-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: maz@kernel.org, drjones@redhat.com, shan.gavin@gmail.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 corbet@lwn.net, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 will@kernel.org, linux-kselftest@vger.kernel.org, bgardon@google.com,
 dmatlack@google.com, pbonzini@redhat.com, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org
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
 arch/x86/kvm/x86.c       | 5 +++--
 include/linux/kvm_host.h | 1 +
 virt/kvm/dirty_ring.c    | 4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..7f368f59f033 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10265,8 +10265,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	/* Forbid vmenter if vcpu dirty ring is soft-full */
-	if (unlikely(vcpu->kvm->dirty_ring_size &&
-		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
+	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
+	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
+		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
 		trace_kvm_dirty_ring_exit(vcpu);
 		r = 0;
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
