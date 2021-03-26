Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E6CC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C47861A1D
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C47861A1D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2114B41C;
	Fri, 26 Mar 2021 09:54:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3w4mLSZPDWbs; Fri, 26 Mar 2021 09:54:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3909C4B4C9;
	Fri, 26 Mar 2021 09:54:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2E904B1E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MFV+UYBbWvFt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:31 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9AE654B1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:31 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id e129so8309063yba.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=E73AHOQjBPWB3b7eepa8I3g6Ygw9PyS/TuWLtHYWQwQ=;
 b=uDH3hjnLP3hcmHYEfB2Jvqa+r4y3W8wJrJ04/Ad4Fp60G1iEjH+eEjpL+xNuswGHwc
 O0Ok57wCyozz0VL9FccBpaBbi+I+1S82VuXKSKmSgShJqkNrzcpqKBCi4zpbEKo7Oy1y
 4GcWwxpsQp2TFPrfQmrwy7t3mtkT+R864QvWWTKGWj1ItT0sB9clhsfS44jyQbW4Z7Se
 Df0RWv22xs3g8csKziDrQUx/dT8sWdlRXUnsM8ruakpV7oEyvrb+vjcEw8UwxAM3LCEi
 pJtlaKJw3+PyopoHNs1hsxGRbtsq09zI2TKzTGSSiPiMKIJ4KJdulM3S6GbRWv4ftxlH
 7W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=E73AHOQjBPWB3b7eepa8I3g6Ygw9PyS/TuWLtHYWQwQ=;
 b=SSIkWVyF6OPKT0n/tAeKNHTyI1GMq70pOCiz3MHuh8hQXogvDrgsNJ4+geB/pMzSnE
 r/vfk8GuAtjPwdJk+eu00kIa83WEACZiTiYxXFwr0g580oW9kJNO/1vHvRQtnFLjTbaa
 tGa1QFF97G2AL3i2x9SDIC7DzPIRhLhFey2wTumQCmUmSiLPs7HGE25mTuJZ1K7NyBAh
 jgWJd0+n0Sn13SwztwbZNB0xik1Kr/1B8UeTNLAmaUAbH9bNJj+bgOlRKdZdpfm9D4OJ
 H1iNFw1RgycED7AgeaJhO5b1EtZVDMgFz0u83k8qbFJv3y+2g9sWx/PYv7Uyrg6AQI+T
 aCdg==
X-Gm-Message-State: AOAM530ukRfIC0joQ2RN3jXVDIcouFcsB0luBQUkzIcpZVtvFltC41nI
 ut/fXr+15iBCYCU9sFAoU9Vn1WGZoH4=
X-Google-Smtp-Source: ABdhPJx7J0AHjHy4T9ri9h7rxvmUk9A6BI0ZEmrjzjf/OGqwCEhVMFXMsPH+P5e6WRHeKYr+Ul3KVIimyqo=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:6f44:: with SMTP id
 k65mr15774100ybc.218.1616725231197; 
 Thu, 25 Mar 2021 19:20:31 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:48 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 09/18] KVM: Move arm64's MMU notifier trace events to generic
 code
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
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

Move arm64's MMU notifier trace events into common code in preparation
for doing the hva->gfn lookup in common code.  The alternative would be
to trace the gfn instead of hva, but that's not obviously better and
could also be done in common code.  Tracing the notifiers is also quite
handy for debug regardless of architecture.

Remove a completely redundant tracepoint from PPC e500.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c             |  7 +---
 arch/arm64/kvm/trace_arm.h       | 66 --------------------------------
 arch/powerpc/kvm/e500_mmu_host.c |  2 -
 arch/powerpc/kvm/trace_booke.h   | 15 --------
 include/trace/events/kvm.h       | 66 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c              | 10 +++++
 6 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8711894db8c2..4b7e1e327337 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1111,7 +1111,6 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	trace_kvm_unmap_hva_range(start, end);
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
 	return 0;
 }
@@ -1141,8 +1140,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	trace_kvm_set_spte_hva(hva);
-
 	/*
 	 * We've moved a page around, probably through CoW, so let's treat it
 	 * just like a translation fault and clean the cache to the PoC.
@@ -1173,7 +1170,7 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
-	trace_kvm_age_hva(start, end);
+
 	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
 }
 
@@ -1181,7 +1178,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
-	trace_kvm_test_age_hva(hva);
+
 	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
 				 kvm_test_age_hva_handler, NULL);
 }
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index ff0444352bba..33e4e7dd2719 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -135,72 +135,6 @@ TRACE_EVENT(kvm_mmio_emulate,
 		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
 );
 
-TRACE_EVENT(kvm_unmap_hva_range,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	start		)
-		__field(	unsigned long,	end		)
-	),
-
-	TP_fast_assign(
-		__entry->start		= start;
-		__entry->end		= end;
-	),
-
-	TP_printk("mmu notifier unmap range: %#016lx -- %#016lx",
-		  __entry->start, __entry->end)
-);
-
-TRACE_EVENT(kvm_set_spte_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier set pte hva: %#016lx", __entry->hva)
-);
-
-TRACE_EVENT(kvm_age_hva,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	start		)
-		__field(	unsigned long,	end		)
-	),
-
-	TP_fast_assign(
-		__entry->start		= start;
-		__entry->end		= end;
-	),
-
-	TP_printk("mmu notifier age hva: %#016lx -- %#016lx",
-		  __entry->start, __entry->end)
-);
-
-TRACE_EVENT(kvm_test_age_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
-);
-
 TRACE_EVENT(kvm_set_way_flush,
 	    TP_PROTO(unsigned long vcpu_pc, bool cache),
 	    TP_ARGS(vcpu_pc, cache),
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index ed0c9c43d0cf..648aefe1a3e7 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -723,8 +723,6 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu,
 
 static int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 {
-	trace_kvm_unmap_hva(hva);
-
 	/*
 	 * Flush all shadow tlb entries everywhere. This is slow, but
 	 * we are 100% sure that we catch the to be unmapped page
diff --git a/arch/powerpc/kvm/trace_booke.h b/arch/powerpc/kvm/trace_booke.h
index 3837842986aa..eff6e82dbcd4 100644
--- a/arch/powerpc/kvm/trace_booke.h
+++ b/arch/powerpc/kvm/trace_booke.h
@@ -69,21 +69,6 @@ TRACE_EVENT(kvm_exit,
 		)
 );
 
-TRACE_EVENT(kvm_unmap_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("unmap hva 0x%lx\n", __entry->hva)
-);
-
 TRACE_EVENT(kvm_booke206_stlb_write,
 	TP_PROTO(__u32 mas0, __u32 mas8, __u32 mas1, __u64 mas2, __u64 mas7_3),
 	TP_ARGS(mas0, mas8, mas1, mas2, mas7_3),
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 49d7d0fe29f6..200eb7465530 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -462,6 +462,72 @@ TRACE_EVENT(kvm_dirty_ring_exit,
 	TP_printk("vcpu %d", __entry->vcpu_id)
 );
 
+TRACE_EVENT(kvm_unmap_hva_range,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier unmap range: %#016lx -- %#016lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_set_spte_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier set pte hva: %#016lx", __entry->hva)
+);
+
+TRACE_EVENT(kvm_age_hva,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier age hva: %#016lx -- %#016lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_test_age_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 383df23514b9..d1de843b7618 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -459,6 +459,8 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int idx;
 
+	trace_kvm_set_spte_hva(address);
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	KVM_MMU_LOCK(kvm);
@@ -478,6 +480,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int need_tlb_flush = 0, idx;
 
+	trace_kvm_unmap_hva_range(range->start, range->end);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	/*
@@ -548,6 +552,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
 
+	trace_kvm_age_hva(start, end);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 
@@ -569,6 +575,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
 
+	trace_kvm_age_hva(start, end);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	/*
@@ -598,6 +606,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
 
+	trace_kvm_test_age_hva(address);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	young = kvm_test_age_hva(kvm, address);
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
