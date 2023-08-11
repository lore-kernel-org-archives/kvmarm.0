Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9061102
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 04:51:41 +0000 (UTC)
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-56c99e94fa9so1797154eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 21:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729500; x=1692334300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3pnh3N/YIF0SxqOcKLFCFAu/7kR/Uv7ltNd2DAApng=;
        b=Q/eD8y0h2l6JvWr9yxmhkzDz3/gU+uCMrAapE+RfKfpEujedU2m/cioIEtNiwyWcDq
         6oU/mRQTOMuz+meNoZkHUXpRaB1Kf60Q4R97OmOR3SyHx7RuYNOseDNnfQaON1qyo5sp
         Yy7qpgB8KdX4r7NgDYWnxRanbAd0O25zsnOgYls8iU4oaEYwKOd4OuGHRAElOOULjwZ7
         zv+qj9vFVZl3xEcKvgpLumSuTYsp2PPSqwEIKmfHkh1NMsSMLhmU4qETWPBj1KkWIsjx
         AfAcpwHEssHw6PsET2R5l/KBjsPVbkindLK/jYg8Jg4IOgwBWrE2JstApGnRH9vE/HVL
         nJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729500; x=1692334300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3pnh3N/YIF0SxqOcKLFCFAu/7kR/Uv7ltNd2DAApng=;
        b=J5XjM5eDCZOvSylaDqtARPrlxeXJu7KGEObpTvUm29kug04DWT1lw/MV2jdVFNFBGR
         gQGGWZwldv3czXqw167zuix2MoovrpRRhWfSLPcjAaRL6M7zbjBrmGv+0Jdk5G0TkLXG
         rRM5HR/JALTYPxtiBM1O9NtL6Fy14OmtEU5kpGeHVDKCAPlxiLBEWSzZPRrVOs17dRF4
         4GUbrMXX06X4l7B2taiCERcLbkMqus5GUSc25ae1CYP9/pM2qrb7YITVxioLf34HLuOP
         tUg48UlUBjd1fN4EhI52xtV7eqJZlvoQoW7WcX/IJDG+minoCmDXYSf8PSALV4iQr0bh
         GHog==
X-Gm-Message-State: AOJu0YyB5uIcMzPaHrNJU5oZ6atXu+SHAZ+yoelfbMRdI+FXWTgymSTD
	hKWoA8q7/LcY6R8/daS71VbamCPSwmyl
X-Google-Smtp-Source: AGHT+IFGVe7NxFpz5VE0E4/WvtFaQI/uiF+IxB2dFVJtq+EJbiYPxTNleKK3q6v99h+PTIzxrx3AKKcqdkl2
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6870:7685:b0:1c2:d3de:c298 with SMTP
 id dx5-20020a056870768500b001c2d3dec298mr3535oab.11.1691729500567; Thu, 10
 Aug 2023 21:51:40 -0700 (PDT)
Date: Fri, 11 Aug 2023 04:51:18 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-6-rananta@google.com>
Subject: [PATCH v9 05/14] KVM: Allow range-based TLB invalidation from common code
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 10 ++++------
 arch/x86/kvm/mmu/mmu_internal.h |  3 ---
 include/linux/kvm_host.h        | 11 +++++++++++
 virt/kvm/kvm_main.c             | 13 +++++++++++++
 5 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a2d3cfc2eb75c..b547d17c58f63 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1804,6 +1804,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce2..00f7bda9202f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -278,16 +278,14 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
 	return kvm_x86_ops.flush_remote_tlbs_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
-				 gfn_t nr_pages)
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
 {
 	int ret = -EOPNOTSUPP;
 
 	if (kvm_x86_ops.flush_remote_tlbs_range)
-		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
-								   nr_pages);
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
+		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
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
index ade5d4500c2ce..89d2614e4b7a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1488,6 +1489,16 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 #endif
 
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+						    gfn_t gfn, u64 nr_pages)
+{
+	return -EOPNOTSUPP;
+}
+#else
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
+#endif
+
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6b0507861550..26e91000f579d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
+{
+	if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, nr_pages))
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
2.41.0.640.ga95def55d0-goog

