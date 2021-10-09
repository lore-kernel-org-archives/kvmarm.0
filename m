Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453CDC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E146461038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E146461038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D004A534;
	Fri,  8 Oct 2021 22:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 05ivGtcFKqu5; Fri,  8 Oct 2021 22:14:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7434B0CC;
	Fri,  8 Oct 2021 22:14:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EDFA4B10D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cLFUDRx7uzP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:14:16 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B68444B1E3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:14:15 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 x16-20020a25b910000000b005b6b7f2f91cso15204923ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=arn3QPCgnyUFm933bKAVezCVOZbbelZBmIXo+qC2e8A=;
 b=NtPYwcGbvpEj33H6dO4R06ZYuMzbhT6h0eIqZuweV7aMaBu2ziVhVO1A4hvx1Ji+cJ
 AgBswGASBvOOoqfVomcOIh0ZHzT1TTJGiHOj+f9sG0AHf/oLjXD6wESX8+v32PdOteOa
 Um62Ru9fWxykQr9ABqAFcipBm+RpHdgIuHU223YquxiOdzQoVkuGxBvdcP5VBkicu3AZ
 7D33zGISGwBLVxXqbiciqkiZPHhXqAM+wIJ5+lE6usO+uyYWHzNCW7B+8JGqSh7ZVhy8
 98+aZ7uc55HORI0YCY76gBC/GAModfD4T1dB+U6UYKL4eI/B9TJb0ULscUkUAonJPfYH
 rgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=arn3QPCgnyUFm933bKAVezCVOZbbelZBmIXo+qC2e8A=;
 b=4EhSfevtRyzomUxjyK4VmeqCNNY/nox5YZMg2FGMqITwR+vtyPr+kTOLuJTCbldQzi
 ZoS+zby5GmlDqHHtQVdWztMtdyqwmBfdRjqkvJs/MZjPA0BJgqYgmkUjOoRhEXseyp8k
 Ole7R+6lax2MULiVssoI3rVRy7lqcnhqLAeXEaaJSWzhWwaJINE9g04Ahy2u0+quzrew
 S5ngwFSgFu8BV4SmCIxaZLoCxUBVOKsqhINxCyxE9m2zYOdtuxiglwMNZ/9KwQbDCEP7
 Naej7aT5PD5cn7c2AOrIwb7YYSsWL5ffW3wGtS4wE3i4FIsyWFAjuPRduhUzQYvPGTDC
 4m2w==
X-Gm-Message-State: AOAM532oRrgkcp0ltQPYyzArSDg/cHn2Sgs0wECU6qB4ZdFy1atUF2+X
 7JbyeRMvYORQIPcXLAOHTWVkeVr+xAs=
X-Google-Smtp-Source: ABdhPJy4qaQ6tIlL2MtP2ahqc06PNWeBv+SOp3R/dcvT+HOsJqGH8QolDswjaKj42MJ7Ncoy+lBhrp1sp74=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:2a0f:: with SMTP id
 q15mr7479663ybq.448.1633745655314; 
 Fri, 08 Oct 2021 19:14:15 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:31 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-39-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 38/43] KVM: Drop defunct kvm_arch_vcpu_(un)blocking() hooks
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Remove kvm_arch_vcpu_(un)blocking() now that all implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c                | 10 ----------
 arch/mips/include/asm/kvm_host.h    |  2 --
 arch/powerpc/include/asm/kvm_host.h |  2 --
 arch/s390/include/asm/kvm_host.h    |  2 --
 arch/x86/include/asm/kvm-x86-ops.h  |  2 --
 arch/x86/include/asm/kvm_host.h     | 13 -------------
 include/linux/kvm_host.h            |  2 --
 virt/kvm/kvm_main.c                 |  4 ----
 8 files changed, 37 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9ff0e85a9f16..444d6f5a980a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -357,16 +357,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 	return kvm_timer_is_pending(vcpu);
 }
 
-void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-
-}
-
-void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_s2_mmu *mmu;
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 72b90d45a46e..28110f71089b 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -895,8 +895,6 @@ static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 int kvm_arch_flush_remote_tlb(struct kvm *kvm);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 4a195c161592..0dfee6866541 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -863,7 +863,5 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_exit(void) {}
-static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..25ed4ec66f4a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1007,7 +1007,5 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *slot) {}
-static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #endif
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c2b007171abd..f2c38acdcad6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -96,8 +96,6 @@ KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_NULL(request_immediate_exit)
 KVM_X86_OP(sched_in)
 KVM_X86_OP_NULL(update_cpu_dirty_logging)
-KVM_X86_OP_NULL(vcpu_blocking)
-KVM_X86_OP_NULL(vcpu_unblocking)
 KVM_X86_OP_NULL(update_pi_irte)
 KVM_X86_OP_NULL(start_assignment)
 KVM_X86_OP_NULL(apicv_post_state_restore)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 76a8dddc1a48..bebd42926321 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1445,9 +1445,6 @@ struct kvm_x86_ops {
 	const struct kvm_pmu_ops *pmu_ops;
 	const struct kvm_x86_nested_ops *nested_ops;
 
-	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
-	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
-
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*start_assignment)(struct kvm *kvm);
@@ -1904,16 +1901,6 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 		irq->delivery_mode == APIC_DM_LOWEST);
 }
 
-static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-	static_call_cond(kvm_x86_vcpu_blocking)(vcpu);
-}
-
-static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
-}
-
 static inline int kvm_cpu_get_apicid(int mps_cpu)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5961a361c73..6a84b020daa6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -966,8 +966,6 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c1850b60f38b..96de905e26e4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3210,8 +3210,6 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.generic.blocking = 1;
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	prepare_to_rcuwait(wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -3224,8 +3222,6 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 	finish_rcuwait(wait);
 
-	kvm_arch_vcpu_unblocking(vcpu);
-
 	vcpu->stat.generic.blocking = 0;
 
 	return waited;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
