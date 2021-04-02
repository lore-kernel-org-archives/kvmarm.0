Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFB5C43603
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FE8B61107
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FE8B61107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB1D54B2C5;
	Fri,  2 Apr 2021 05:20:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ycFK3LP6aAOi; Fri,  2 Apr 2021 05:20:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D75804B2F4;
	Fri,  2 Apr 2021 05:20:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EED584B72A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hLrxOgFmCZhS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 20:57:14 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B28AA4B744
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:14 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id b136so4879060qkc.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Apr 2021 17:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=JN6JeOh2os7TETUBdatO/SE8rrYNulCw/eK8aUoUKlo=;
 b=eMrfPNSFFf9FEy/PgOFXlE0QW6+eiJ/B/GFm3098SJ8t5ML9FvPe4akfK9uP8Odqgd
 5bYn9hI52Cau/Zsc617HbZQPDpkDKTLNcWBqUn/yAO2EpjZEkp+jvMD3XcuPSs4b2NMx
 WTv2z4lQ7k1SMUeYuNPXv8EQZaJNVMMEpYyaJPjxJJHpO0BLXzl+0s9GnNslh5WIcl2o
 TmKMXkqNiylGj6uzaa0oXxBmNOQYDw86juXhCK7lDI7IRZjJKhF4iYXtGKqBsaBj0esq
 MW2yBN8IALvf1FH0CFOQHqQlm6PjoXPO+2fS171RoAUufjT5YLihSSEqzQLxWtTVqGS5
 uufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=JN6JeOh2os7TETUBdatO/SE8rrYNulCw/eK8aUoUKlo=;
 b=VEYwKCjFz4pGytQaHthfk+t+Ujwn+xdOWtQm9dtxRs0n4fg8uXxJlrDmEaSPCLeDo+
 AeTID6wOi59E3XRxqWNzhBflUs0eL1xdNjQ0Vy06OJkxiaqzyCwmkqOP4Q6RUM3oMWyt
 VqHRLpWdkr3eKozr0c/doG1fPKkmR0FPwQXsf08RLBzC13LDvMNaUmqMNgAI6PE9XuuL
 gPB6mB6WSNuF1cqADwAH36NvKgbR9Ewn9OZS/KNxQYS5ywiIBPnOOpBjbZdNHZjqa7qm
 6ep5NMU1F7WMsJxeftU4y55Cu+yqq1Ol5Cp+A7ia6yPjYWQmd0a1MlfAN7FwLqNXTfPC
 WSGA==
X-Gm-Message-State: AOAM530W3LFoDKV0NRXpSa2VEiJxYo1kc9yfrXkKrdhKqMKtfS6Ivjbr
 uZkgWNTpkloyj71tm2BqC7jfqXazalg=
X-Google-Smtp-Source: ABdhPJykRnNFawXAR7GTX30/MArrY/XbyRXdmuqfk1vxAaup1bjQe5AJdJRGU4o3M0zacGSEUMNzYTdDoHo=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a0c:c243:: with SMTP id
 w3mr342583qvh.34.1617325034296; 
 Thu, 01 Apr 2021 17:57:14 -0700 (PDT)
Date: Thu,  1 Apr 2021 17:56:54 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 06/10] KVM: Kill off the old hva-based MMU notifier
 callbacks
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 05:20:36 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Yank out the hva-based MMU notifier APIs now that all architectures that
use the notifiers have moved to the gfn-based APIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h   |  1 -
 arch/mips/include/asm/kvm_host.h    |  1 -
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/x86/include/asm/kvm_host.h     |  1 -
 include/linux/kvm_host.h            |  8 ---
 virt/kvm/kvm_main.c                 | 85 -----------------------------
 6 files changed, 97 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1ad729cf7b0d..72e6b4600264 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -582,7 +582,6 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 374a3c8806e8..feaa77036b67 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -967,7 +967,6 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 /* Emulation */
 int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1335f0001bdd..1e83359f286b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -55,7 +55,6 @@
 #include <linux/mmu_notifier.h>
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 #define HPTEG_CACHE_NUM			(1 << 15)
 #define HPTEG_HASH_BITS_PTE		13
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a21e3698f4dc..99778ac51243 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1718,7 +1718,6 @@ asmlinkage void kvm_spurious_fault(void);
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6bb401dd856..40ac2d40bb5a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -219,7 +219,6 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
@@ -231,13 +230,6 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-#else
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags);
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
-#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
 #endif
 
 enum {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7a7e62ae5eb4..2e809d73c7f1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -451,8 +451,6 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-
 typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 struct kvm_hva_range {
@@ -564,8 +562,6 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 
 	return ret;
 }
-#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
-
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -573,9 +569,6 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	int idx;
-#endif
 	trace_kvm_set_spte_hva(address);
 
 	/*
@@ -585,26 +578,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	 */
 	WARN_ON_ONCE(!kvm->mmu_notifier_count);
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-
-	KVM_MMU_LOCK(kvm);
-
-	if (kvm_set_spte_hva(kvm, address, pte))
-		kvm_flush_remote_tlbs(kvm);
-
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-#endif
 }
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
@@ -613,16 +593,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
-#else
-	int need_tlb_flush = 0, idx;
-#endif
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
 
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	idx = srcu_read_lock(&kvm->srcu);
-#endif
-
 	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
@@ -649,20 +622,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 			max(kvm->mmu_notifier_range_end, range->end);
 	}
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	__kvm_handle_hva_range(kvm, &hva_range);
-#else
-	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
-					     range->flags);
-	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush || kvm->tlbs_dirty)
-		kvm_flush_remote_tlbs(kvm);
-#endif
 
 	KVM_MMU_UNLOCK(kvm);
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	srcu_read_unlock(&kvm->srcu, idx);
-#endif
 
 	return 0;
 }
@@ -696,27 +658,9 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long start,
 					      unsigned long end)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-#endif
 	trace_kvm_age_hva(start, end);
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-
-	young = kvm_age_hva(kvm, start, end);
-	if (young)
-		kvm_flush_remote_tlbs(kvm);
-
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	return young;
-#endif
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -724,11 +668,6 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					unsigned long start,
 					unsigned long end)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-#endif
-
 	trace_kvm_age_hva(start, end);
 
 	/*
@@ -744,41 +683,17 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-	young = kvm_age_hva(kvm, start, end);
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	return young;
-#endif
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long address)
 {
-#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young, idx;
-#endif
 	trace_kvm_test_age_hva(address);
 
-#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
 					     kvm_test_age_gfn);
-#else
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
-	young = kvm_test_age_hva(kvm, address);
-	KVM_MMU_UNLOCK(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	return young;
-#endif
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
