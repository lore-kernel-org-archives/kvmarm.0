Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81BFA3D
	for <kvmarm@lists.linux.dev>; Sat, 15 Jul 2023 00:54:14 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57704af0e64so20370157b3.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 17:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382453; x=1689987253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WL/8letflrdUyrlyVQF85H/ANybjC/FZDEF4uZbqq6U=;
        b=YVDFqRDQFjjSpZgD+yDd0+SvcfnYZvIm68d0fipWbsts27Blri9IZUegY1gTHk9JLn
         jW4cOIkHI7T+9t0jnXLUxFTuZO17IqR8lJ6cZXaSpbBldzPtgjsDIh8gJKx+Q5X4q5WY
         ZPeJbtlH0vB2beRgSMZIMEJ9rm99I7jkv+szOwydpHuY8BG/kmiU0z++M/vX2ikqkedk
         oaLqutULiyyyTrPh+XolZ6Wg+wDDEoirUIkGO2UNG8Fwk+w94SJmA9G1jANboqPpmGQC
         SLk94TOF3nNcENDMs73y7DqVrLGQulUm5QIb9no511Uazy0Gh8YgK2tpMEaTmnUm1hja
         FFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382453; x=1689987253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WL/8letflrdUyrlyVQF85H/ANybjC/FZDEF4uZbqq6U=;
        b=SUMIQ4wgwSvt/8Q1nsw9a4x07mTYxWpw0xlj8kfvNz/zTY99fN+Fu19B4nyvdagjWq
         0EWwbqvOJvZts9yIhzujqZdSHCT/7eLUj/uv8o/FVtQ0vPN32e+9hArX6T+ENvIX0NVc
         yLDs9OH6eC8ufaiWlZmJuUCjeuI/EzNJ060zWl+B+NquBk8nkE0eczQ+bSVv4pCXztJH
         IUNJL1V4JE4KmsKuwAQTK+T+46sdybG12l40MczYTQY2goyHMoltYyYnrkUamlx86Yg6
         OAknS+/0cjHIelF0c8j9ijq6xN5gjjuEgtJUmu5raH2SBckUMPLczqekoYI137jJLn+3
         Dvgw==
X-Gm-Message-State: ABy/qLYxzyvg6mdY9nkUxWGk6H/UAYGQaVQwOCHGYQVqk9JdR7CLd9WZ
	XZicKBvSsvggTbYklP/S77IQd48n66YH
X-Google-Smtp-Source: APBJJlG6pzqEAFBPPKZpzL5h20iHYi06y5msU9Sl0lkkt3fZ5kUVjrD2r7DxfNyZ6tDmAhZp0/UiGX/oO4d3
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:b302:0:b0:565:a42c:79fe with SMTP id
 r2-20020a81b302000000b00565a42c79femr46926ywh.1.1689382453561; Fri, 14 Jul
 2023 17:54:13 -0700 (PDT)
Date: Sat, 15 Jul 2023 00:53:57 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-4-rananta@google.com>
Subject: [PATCH v6 03/11] KVM: Allow range-based TLB invalidation from common code
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
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          |  9 ++++-----
 arch/x86/kvm/mmu/mmu_internal.h |  3 ---
 include/linux/kvm_host.h        |  9 +++++++++
 virt/kvm/kvm_main.c             | 13 +++++++++++++
 5 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a2d3cfc2eb75..08900afbf2ad 100644
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
index ec169f5c7dce..aaa5e336703a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -278,16 +278,15 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
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
index d39af5639ce9..86cb83bb3480 100644
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
index e3f968b38ae9..a731967b24ff 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1486,6 +1487,14 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
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
index d6b050786155..804470fccac7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
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
2.41.0.455.g037347b96a-goog

