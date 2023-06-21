Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114F6182C8
	for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 17:50:24 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57059e6f9c7so121600737b3.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 10:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369824; x=1689961824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kDWyMjxvoVHajO1/4l5o4Ja0nzeqDHBQgPru4Ca7PE=;
        b=W51l0QbnmbjxnmmCtuwRuWnx7YubpJlELQpz6rAW3Ho9+5KqkOCPFt4QfJFhF9nUon
         swbQ6/awYlUsaGqw5BY1VoyvwAIrabaj2ur+qqkzwJCB/NNcsB2TLmSfUM9bkTT6i+A4
         zv/DhDYK49UtrL7Z1+rgptqaq9Q8uY3WCpPrvORTrQzEtf3ZKyR4CgzAaNVPIg8XfIOf
         xKKHIilvW0Hfi14ytSJqddkZcKN0LZ/Uu1mc6Uy2aICfHITnrDdzhnZMCpDigz4Ko99J
         zUxuW1o5ZQsYlxMSD8Fc/hkLFRfGl05LWqyGqFNitmFJAcX2vJ9sDvETccbp+2+pgksv
         Gh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369824; x=1689961824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0kDWyMjxvoVHajO1/4l5o4Ja0nzeqDHBQgPru4Ca7PE=;
        b=I0zqwzxiQlHxu0gyg39IFLxVUtqe3/9LJGtqwy5CaNdZz4vkhkwSVe0I9mGdpgaltM
         DekvULhcPaaSIVvvrRHhq3lyV3idAxe1ctB/F320Gsnh1TB+H8jgAVnw9Uy+r51f1xeA
         e02fxhrmV9ast3k7JvwNruB6Nim8UFuwMKrYJmI1oJAi+GmMqJNlb6yxhiTOhG9H6M+j
         1zABnBb7cyyUrNBVBpwgFJcZ5iiLbSc8Ryq5ia69RCmq2+jhWDBVt1AdBJJ3SgwQU93G
         qvGKxFxe3jwKSs+R6QJSz0y4T5lFqDAVOjgqH3vVbS3chZNGhlfPyZxfY0kWFk4AeVOR
         ekyA==
X-Gm-Message-State: AC+VfDyRJxKeRICh4+UBu1DZAKNQQ6VGidXQoW4sc8qbMJSuhjc6MLf1
	f1MXzFtmrLFj9eI0gcgBOD2hgGB/hjMG
X-Google-Smtp-Source: ACHHUZ5K+kZNE7AXUViYSzsrB/zmiZFidf9JUwCxGExwegY/ED1rp2aL7aai9sJtvuWZdoNkgZU1AlyUF8Hg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:e545:0:b0:56c:e53d:ae90 with SMTP id
 c5-20020a81e545000000b0056ce53dae90mr7488843ywm.4.1687369823914; Wed, 21 Jun
 2023 10:50:23 -0700 (PDT)
Date: Wed, 21 Jun 2023 17:49:54 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-4-rananta@google.com>
Subject: [RESEND PATCH v5 03/11] KVM: Allow range-based TLB invalidation from
 common code
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, David Matlack <dmatlack@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Make kvm_flush_remote_tlbs_range() visible in common code and create a
default implementation that just invalidates the whole TLB.

This paves the way for several future features/cleanups:

 - Introduction of range-based TLBI on ARM.
 - Eliminating kvm_arch_flush_remote_tlbs_memslot()
 - Moving the KVM/x86 TDP MMU to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          |  9 ++++-----
 arch/x86/kvm/mmu/mmu_internal.h |  3 ---
 include/linux/kvm_host.h        |  9 +++++++++
 virt/kvm/kvm_main.c             | 13 +++++++++++++
 5 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f6e3aa617d8b8..5c4dc547c030c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1804,6 +1804,9 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1c..32f7fb1b66c8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -275,16 +275,15 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
 	return kvm_x86_ops.flush_remote_tlbs_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
-				 gfn_t nr_pages)
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	int ret = -EOPNOTSUPP;
 
 	if (kvm_x86_ops.flush_remote_tlbs_range)
 		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
-								   nr_pages);
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
+									pages);
+
+	return ret;
 }
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce97..86cb83bb34804 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -170,9 +170,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
-				 gfn_t nr_pages);
-
 /* Flush the given page (huge or not) of guest memory. */
 static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 95c3e364f24b4..a054f48498a8f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1357,6 +1357,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1484,6 +1485,14 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 }
 #endif
 
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+						   gfn_t gfn, u64 pages)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 600a985b86215..fc4ee20d33cc0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -371,6 +371,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages)
+{
+	if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, pages))
+		return;
+
+	/*
+	 * Fall back to a flushing entire TLBs if the architecture range-based
+	 * TLB invalidation is unsupported or can't be performed for whatever
+	 * reason.
+	 */
+	kvm_flush_remote_tlbs(kvm);
+}
+
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
-- 
2.41.0.162.gfafddb0af9-goog

