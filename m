Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7E3BA5E
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 00:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065326; cv=none; b=MOuajJN11VgBDptBb+yhA8IPnTTXMeACtgcymbXelXn7KQTSAHTgeN4NEKIZrO7ujwccCKjJtUxc0e08o39H2mqOsGlBzUJjw4IBUFmmkJqG7jpoBnDso5dSxdZ2BQeLnwqTK6oHeQTgnR5U8xSyPM6IayYtvTR25Di/PlN2RMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065326; c=relaxed/simple;
	bh=l1kb8WAhH7ZZEnNCv7caRH5R11IxtoWpLxiHG3YPghg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZdUAc21uq5DhAQSwFLRk9P/V5i3Pey5BaHyIEJqFqnOPzI53i31hOdKaxS+fmYBvUWTY/8wK/33q9LuATZM4kLFoySKsUthwRXMquy37jDxPzoKIR7OgoB7ECHTrR9+IjggpctP8dLIIDaneYSeaeATYTtkpHtbSNhA16yXVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZHunzaBY; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZHunzaBY"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627956be166so99972637b3.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 17:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065323; x=1718670123; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JyxqE8JQbjAibPP1L18H/WB5ae5upDraVd7kSoejAF4=;
        b=ZHunzaBYIQ1nCvcq1Sb8YbAQ1zzAEPWsL61tUuOFXAkJ6t4tvpZpzI+EJ1+TMe/+CP
         GFaVz57ODoS7py35azCeP1w6hNjJfnDrBWk1pn4PjABJzSgPJcsRLv+p/VBig21GK3kR
         1pNOfnVo1SCmJxbzRMUuY+WMAZgKFSTop6GOVTfQDEQACHm8rkGj25f9K5wxzBMoOia0
         BPL0WXReNYABszQkiDU2fqLqisSQybuVpuERI7tk2dXLhO4txgwGJP9BAb05ors4caZO
         9RW6z7PWbU9ILeW96yNf1CJ+/282GCQ68a7FfJ6ALfdPOH6JLZu0E9l04Fovxz+3sN5k
         qwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065323; x=1718670123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JyxqE8JQbjAibPP1L18H/WB5ae5upDraVd7kSoejAF4=;
        b=KbHMCodZyh0AY5ZXEVEPx1f25D7D7RP6RiY2JHR+UYc3mpwd9BiV9D94satLwWHPui
         Nt/EKvD6tOfUoawy0BjqkmSB/6jwASRIrn9t9u28KtRMU7aiuHX7CtB1VVIfBwj6IF17
         90pCeBYG66AT8e3NEHmNE1RjVN9VddVAucLp/UuaWzEJnVUg5GWWoClFb+ozwtAsKgGG
         ht2LqF7X3ZfIiZAh7ZTLy6yquW5Cxsnyz2ovyjesHwk1qioOJyy/w81gIi4ZZwDqLFBM
         ZVFFXjvyOXKUdgQvlFEEGFONlTgDJxib/mZ04PY8fWcZ8Sw1xvvZNLjnZtRqM1H1T97X
         7gFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLfN9WbH1cbN0M4W4dLIgAohDrF5lu3TXTHJLkIbVQ359ifKsyNqxPP1XBO3g+terqrYy2V4OXzwUkYi5ud8MmX7uvSZ7S
X-Gm-Message-State: AOJu0Yz2X0Uf61lZxFfm17G3QsCQC5azzwh+sSl38shQDADtTJ0MFpkk
	GQk9kpHCvZrlbqOqyViPIW+P09/DHLOi83SGmW9hh36Ck9HN7+KviQ3IXGTeOoS9MlJobCm5SIs
	5p/Fr1YgP1/ybxQIEmg==
X-Google-Smtp-Source: AGHT+IE2AKcYsstInOqgudHKTQp6Jdm0LGHMNfnLB4IVzasoq6oW0Y69RVWgTVatpoFZnw0nHcf4J+vZvg80MMrE
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:6101:b0:62a:2a39:ccd9 with
 SMTP id 00721157ae682-62cd5663caemr27714337b3.6.1718065323356; Mon, 10 Jun
 2024 17:22:03 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:41 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-6-jthoughton@google.com>
Subject: [PATCH v5 5/9] KVM: Add kvm_fast_age_gfn and kvm_fast_test_age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Provide the basics for allowing architectures to implement
mmu_notifier_test_clear_young_fast_only().

Add CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER that architectures will set
if they implement the fast-only notifier.

kvm_fast_age_gfn and kvm_fast_test_age_gfn both need to support
returning a tri-state state of:
  1. fast && young,
  2. fast && !young,
  3. !fast
This could be done by making gfn_handler_t return int, but that would
mean a lot of churn. Instead, include a new kvm_mmu_notifier_arg
'bool *failed' for kvm_fast_{test,}_age_gfn to optionally use.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h   |  7 ++++++
 include/trace/events/kvm.h | 22 ++++++++++++++++++
 virt/kvm/Kconfig           |  4 ++++
 virt/kvm/kvm_main.c        | 47 ++++++++++++++++++++++++++++++--------
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d7c3e8632e6..e4efeba51222 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -258,6 +258,9 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 union kvm_mmu_notifier_arg {
 	unsigned long attributes;
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+	bool *failed;
+#endif
 };
 
 struct kvm_gfn_range {
@@ -271,7 +274,11 @@ struct kvm_gfn_range {
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+bool kvm_fast_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_fast_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
+#endif /* CONFIG_KVM_GENERIC_MMU_NOTIFIER */
 
 enum {
 	OUTSIDE_GUEST_MODE,
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..7ba6c35c2426 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -489,6 +489,28 @@ TRACE_EVENT(kvm_test_age_hva,
 	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
 );
 
+TRACE_EVENT(kvm_fast_test_age_hva,
+	TP_PROTO(unsigned long start, unsigned long end, bool clear),
+	TP_ARGS(start, end, clear),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+		__field(	bool,		clear		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+		__entry->clear		= clear;
+	),
+
+	TP_printk("mmu notifier fast test age: hva: %#016lx -- %#016lx "
+		  "clear: %d",
+		  __entry->start, __entry->end,
+		  __entry->clear)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 0404857c1702..77ac680af60c 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,6 +100,10 @@ config KVM_GENERIC_MMU_NOTIFIER
 config KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
        bool
 
+config HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+       select KVM_GENERIC_MMU_NOTIFIER
+       bool
+
 config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d8fa0d617f12..aa930a8b903f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -699,7 +699,8 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
 							 unsigned long start,
 							 unsigned long end,
-							 gfn_handler_t handler)
+							 gfn_handler_t handler,
+							 bool *failed)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -711,6 +712,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.may_block	= false,
 		.lockless	=
 			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
+		.arg.failed	= failed,
 	};
 
 	return __kvm_handle_hva_range(kvm, &range).ret;
@@ -901,7 +903,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn, NULL);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -911,9 +913,32 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	trace_kvm_test_age_hva(address);
 
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
+					     kvm_test_age_gfn, NULL);
 }
 
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+static int kvm_mmu_notifier_test_clear_young_fast_only(struct mmu_notifier *mn,
+						       struct mm_struct *mm,
+						       unsigned long start,
+						       unsigned long end,
+						       bool clear)
+{
+	gfn_handler_t handler;
+	bool failed = false, young;
+
+	trace_kvm_fast_test_age_hva(start, end, clear);
+
+	handler = clear ? kvm_fast_age_gfn : kvm_fast_test_age_gfn;
+
+	young = kvm_handle_hva_range_no_flush(mn, start, end, handler, &failed);
+
+	if (failed)
+		return MMU_NOTIFIER_FAST_FAILED;
+
+	return young ? MMU_NOTIFIER_FAST_YOUNG : 0;
+}
+#endif
+
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {
@@ -926,12 +951,16 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
-	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
-	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
-	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
-	.clear_young		= kvm_mmu_notifier_clear_young,
-	.test_young		= kvm_mmu_notifier_test_young,
-	.release		= kvm_mmu_notifier_release,
+	.invalidate_range_start		= kvm_mmu_notifier_invalidate_range_start,
+	.invalidate_range_end		= kvm_mmu_notifier_invalidate_range_end,
+	.clear_flush_young		= kvm_mmu_notifier_clear_flush_young,
+	.clear_young			= kvm_mmu_notifier_clear_young,
+	.test_young			= kvm_mmu_notifier_test_young,
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+	.test_clear_young_fast_only	=
+		kvm_mmu_notifier_test_clear_young_fast_only,
+#endif
+	.release			= kvm_mmu_notifier_release,
 };
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
-- 
2.45.2.505.gda0bf45e8d-goog

